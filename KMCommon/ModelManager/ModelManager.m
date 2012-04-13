//
//  ModelManager.m
//  Drawus
//
//  Created by Tianhang Yu on 12-3-30.
//  Copyright (c) 2012年 99fang. All rights reserved.
//

#import "ModelManager.h"

@interface ModelManager () {

	NSManagedObjectModel         *_managedObjectModel;
	NSManagedObjectContext       *_managedObjectContext;
	NSPersistentStoreCoordinator *_persistentStoreCoordinator;
}

@end

@implementation ModelManager

#pragma mark - public

- (NSString *)databaseName
{
    /* should be extended */
    
	return nil;
}

- (BOOL)save
{
	NSError *error = nil;

	if (_managedObjectContext != nil)
	{
		if ([_managedObjectContext hasChanges] && ![_managedObjectContext save:&error])
		{
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);

			return NO;
		}
	}

	return YES;
}

#pragma mark - CoreData

- (NSManagedObjectModel *)managedObjectModel
{
	if (_managedObjectModel == nil)
	{
		_managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];
	}
	return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
	if (_persistentStoreCoordinator == nil)
	{
		NSURL *storeURL = [NSURL fileURLWithPath:
                           [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory,
                                                                NSUserDomainMask, 
                                                                YES) lastObject] 
                  stringByAppendingPathComponent:[self databaseName]]];

		NSError *error = nil;

		_persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];

		NSMutableDictionary *optionDict = [[NSMutableDictionary alloc] init];
		[optionDict setObject:[NSNumber numberWithBool:YES] 
                       forKey:NSMigratePersistentStoresAutomaticallyOption];
		[optionDict setObject:[NSNumber numberWithBool:YES] 
                       forKey:NSInferMappingModelAutomaticallyOption];

        NSPersistentStore *store = [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                                             configuration:nil 
                                                                                       URL:storeURL 
                                                                                   options:optionDict
                                                                                     error:&error];
		if (store == nil)
		{
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			abort();
		}

		[optionDict release];
	}

	return _persistentStoreCoordinator;
}

- (NSManagedObjectContext *)managedObjectContext
{
	if (_managedObjectContext == nil)
	{
		NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
		
		if (coordinator != nil)
		{
			_managedObjectContext = [[NSManagedObjectContext alloc] init];
			[_managedObjectContext setPersistentStoreCoordinator:_persistentStoreCoordinator];	
		}
	}

	return _managedObjectContext;
}

#pragma mark - default

- (id)init
{
	self = [super init];
	if (self)
	{
		[self managedObjectContext];
	}
    return self;
}

@end
