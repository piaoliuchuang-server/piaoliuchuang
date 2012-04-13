//
//  Created by David Alpha Fox on 3/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


#import <Foundation/Foundation.h>
//需要用B＋树和多线程进行优化
//需要模仿git的方法，防止目录下inode被耗尽
//需要添加LRU的内存缓冲，而不是纯粹的磁盘缓冲。

@interface SimpleCache : NSObject {
    NSMutableDictionary * _cacheDictionary;
	NSOperationQueue    * _diskOperationQueue;
    NSDate              * _infiniteDate;
    
    NSTimeInterval _defaultTimeoutInterval;
}

@property (assign) NSTimeInterval defaultTimeoutInterval;

//public
+ (SimpleCache *)sharedCache;

- (void)removeCacheForKey:(NSString *)key;
- (void)clearCache;
- (void)setData:(NSData *)data forKey:(NSString *)key;
- (void)setData:(NSData *)data forKey:(NSString *)key withTimeoutInterval:(NSTimeInterval)timeoutInterval;
- (NSData *)dataForKey:(NSString *)key;
- (void)unPersistKey:(NSString *)key;
- (void)persistKey:(NSString *)key;
- (NSString *)cacheFilePath:(NSString *)key;

@end
