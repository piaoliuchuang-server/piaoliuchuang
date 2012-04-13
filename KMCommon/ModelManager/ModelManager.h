//
//  ModelManager.h
//  Drawus
//
//  Created by Tianhang Yu on 12-3-30.
//  Copyright (c) 2012年 99fang. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface ModelManager : NSObject

- (NSString *)databaseName;
- (BOOL)save;

@end
