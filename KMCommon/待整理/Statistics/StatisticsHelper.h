//
//  StatisticsHelper.h
//  BaseGallery
//
//  Created by Tianhang Yu on 12-1-5.
//  Copyright (c) 2012年 99fang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GANTracker.h"
#import "MobClick.h"


@interface StatisticsHelper : NSObject

+ (void)trackEventWithAppName:(NSString *)appName andEvent:(NSString *)event andLabel:(NSString *)label;
+ (void)trackEventWithAppName:(NSString *)appName andEvent:(NSString *)event;

@end
