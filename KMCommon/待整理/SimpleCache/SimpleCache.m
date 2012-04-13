//
//  Created by David Alpha Fox on 3/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


#import "BaseHeader.h"
#import "SimpleCache.h"


static SimpleCache * _sharedCache = nil;

static NSString * _CacheDirectory = nil;

static inline NSString* CacheDirectory() {
	if(!_CacheDirectory) {
		_CacheDirectory = [[[NSString stringWithString:@"SimpleCache"] stringCachePath] copy];
	}
	
	return _CacheDirectory;
}

static inline NSString* cachePathForKey(NSString* key) {
	return [CacheDirectory() stringByAppendingPathComponent:key];
}

@implementation SimpleCache

@synthesize defaultTimeoutInterval = _defaultTimeoutInterval;

+ (SimpleCache *)sharedCache
{
    @synchronized(self) {
		if (!_sharedCache) {
			_sharedCache = [[SimpleCache alloc] init];
		}
	}
    return _sharedCache;
}

+ (id)alloc
{
	NSAssert(_sharedCache == nil, @"Attempted to allocate a second instance of a singleton.");
    
	return [super alloc];
}

- (id)init
{
    self = [super init];
    
    if (self) {
        NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
        
        _infiniteDate = [[NSDate dateWithTimeIntervalSince1970:-1] retain];
        
        NSDictionary* dict = [NSDictionary dictionaryWithContentsOfFile:cachePathForKey(@"SimpleCache.plist")];
        if([dict isKindOfClass:[NSDictionary class]]) {
			_cacheDictionary = [dict mutableCopy];
		} 
        else {
			_cacheDictionary = [[NSMutableDictionary alloc] init];
		}
        _diskOperationQueue = [[NSOperationQueue alloc] init];
		
		[[NSFileManager defaultManager] createDirectoryAtPath:CacheDirectory() 
								  withIntermediateDirectories:YES 
												   attributes:nil 
														error:NULL];
		NSDictionary * shadowCacheDicionary = [[_cacheDictionary copy] autorelease];
		for(NSString* key in [shadowCacheDicionary allKeys]) {
			NSDate* date = [shadowCacheDicionary objectForKey:key];
            if ([_infiniteDate isEqualToDate:date]) {
                continue;
            }else if([[[NSDate date] earlierDate:date] isEqualToDate:date]) {
				[[NSFileManager defaultManager] removeItemAtPath:cachePathForKey(key) error:NULL];
                [_cacheDictionary removeObjectForKey:key];
			}
		}
        
		[pool release];
        //do not use saveCacheDictionary here deadlock
        [_cacheDictionary writeToFile:cachePathForKey(@"SimpleCache.plist") atomically:YES];
        self.defaultTimeoutInterval = SS_WEEK;
    }
    return self;
}

- (void)dealloc {
    SS_RELEASE_SAFELY(_diskOperationQueue);
    SS_RELEASE_SAFELY(_cacheDictionary);
    SS_RELEASE_SAFELY(_infiniteDate);
	[super dealloc];
}

#pragma mark -
#pragma mark meta operations

- (void)saveCacheDictionary {
	@synchronized(self) {
		[_cacheDictionary writeToFile:cachePathForKey(@"SimpleCache.plist") atomically:YES];
	}
}

#pragma mark -
#pragma mark io operations

- (void)writeData:(NSData *)data toPath:(NSString *)path {
	[data writeToFile:path atomically:YES];
} 

- (void)deleteDataAtPath:(NSString *)path {
	[[NSFileManager defaultManager] removeItemAtPath:path error:NULL];
}

- (void)performDiskWriteOperation:(NSInvocation *)invoction {
	NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithInvocation:invoction];
	[_diskOperationQueue addOperation:operation];
	[operation release];
}

#pragma mark -
#pragma mark delete operations

//paramter must real key
- (void)removeItemFromCache:(NSString*)key {
	NSString* cachePath = cachePathForKey(key);
	
	NSInvocation* deleteInvocation = [NSInvocation invocationWithMethodSignature:[self methodSignatureForSelector:@selector(deleteDataAtPath:)]];
	[deleteInvocation setTarget:self];
	[deleteInvocation setSelector:@selector(deleteDataAtPath:)];
	[deleteInvocation setArgument:&cachePath atIndex:2];
	
	[self performDiskWriteOperation:deleteInvocation];
	[_cacheDictionary removeObjectForKey:key];
}

- (void)clearCache {
	for(NSString* key in [_cacheDictionary allKeys]) {
		[self removeItemFromCache:key];
	}
	
	[self saveCacheDictionary];
}

- (void)removeCacheForKey:(NSString *)key {
    NSString * real_key = [key MD5HashString];
	[self removeItemFromCache:real_key];
	[self saveCacheDictionary];
}

//paramter must real key
- (BOOL)hasCacheForKey:(NSString *)key {
	NSDate* date = [_cacheDictionary objectForKey:key];
	if(!date) return NO;
    if (![_infiniteDate isEqualToDate:date]) {
        if([[[NSDate date] earlierDate:date] isEqualToDate:date])
        {
            [self removeCacheForKey:key];
            return NO;  
        }
    }
	return [[NSFileManager defaultManager] fileExistsAtPath:cachePathForKey(key)];
}

#pragma mark - 
#pragma mark cache operations

- (void)saveAfterDelay { // Prevents multiple-rapid saves from happening, which will slow down your app
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(saveCacheDictionary) object:nil];
	[self performSelector:@selector(saveCacheDictionary) withObject:nil afterDelay:0.3];
}

- (void)setData:(NSData*)data forKey:(NSString*)key {
	[self setData:data forKey:key withTimeoutInterval:self.defaultTimeoutInterval];
}

- (void)setData:(NSData*)data forKey:(NSString*)key withTimeoutInterval:(NSTimeInterval)timeoutInterval
{
    BOOL doSave = YES;
    if (data == nil) {
        return;//do nothing
    }
	NSString * real_key = [key MD5HashString];
    
	NSString* cachePath = cachePathForKey(real_key);
	NSInvocation* writeInvocation = [NSInvocation invocationWithMethodSignature:[self methodSignatureForSelector:@selector(writeData:toPath:)]];
	[writeInvocation setTarget:self];
	[writeInvocation setSelector:@selector(writeData:toPath:)];
	[writeInvocation setArgument:&data atIndex:2];
	[writeInvocation setArgument:&cachePath atIndex:3];
	
	[self performDiskWriteOperation:writeInvocation];
    if ([_cacheDictionary objectForKey:real_key] != nil) {
        NSDate* date = [_cacheDictionary objectForKey:real_key];
        if ([date isEqualToDate:_infiniteDate]) {
            doSave = NO;
        }
    }
    
    if (doSave) {
        if(timeoutInterval > 0)
        {
            [_cacheDictionary setObject:[NSDate dateWithTimeIntervalSinceNow:timeoutInterval] forKey:real_key];
        }
        else
        {
            [_cacheDictionary setObject:_infiniteDate forKey:real_key];
        }
        
        [self performSelectorOnMainThread:@selector(saveAfterDelay) withObject:nil waitUntilDone:YES]; // Need to make sure the save delay get scheduled in the main runloop, not the current threads
    }
}

- (NSData*)dataForKey:(NSString*)key {
    NSString * real_key = [key MD5HashString];
	if ([self hasCacheForKey:real_key]) {
		return [NSData dataWithContentsOfFile:cachePathForKey(real_key) options:0 error:NULL];
	} 
    else {
		return nil;
	}
}

#pragma mark -
#pragma mark persist

-(void)persistKey:(NSString *)key
{
    NSString * real_key = [key MD5HashString];
    [_cacheDictionary setObject:_infiniteDate forKey:real_key];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(saveCacheDictionary) object:nil];
    [self performSelectorOnMainThread:@selector(saveCacheDictionary) withObject:nil waitUntilDone:YES]; 
}

-(void)unPersistKey:(NSString*)key
{
    NSString * real_key =[key MD5HashString];
    [_cacheDictionary setObject:[NSDate dateWithTimeIntervalSinceNow:self.defaultTimeoutInterval] forKey:real_key];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(saveCacheDictionary) object:nil];
    [self performSelectorOnMainThread:@selector(saveCacheDictionary) withObject:nil waitUntilDone:YES]; 
}

#pragma mark -
#pragma mark raw Path

- (NSString*) cacheFilePath:(NSString*)key
{
    NSString * real_key = [key MD5HashString];
    NSString * cacheFile = cachePathForKey(real_key);
    if ([[NSFileManager defaultManager] fileExistsAtPath:cacheFile]) {
        return cacheFile;
    }
    return nil;
    
}
@end
