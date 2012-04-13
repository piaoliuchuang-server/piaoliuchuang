//
//  StatisticsHelper.m
//  BaseGallery
//
//  Created by Tianhang Yu on 12-1-5.
//  Copyright (c) 2012年 99fang. All rights reserved.
//

#import "StatisticsHelper.h"

@implementation StatisticsHelper

+ (void)trackEventWithAppName:(NSString *)appName andEvent:(NSString *)event andLabel:(NSString *)label
{
    NSError * error = nil;
    [[GANTracker sharedTracker] trackPageview:[NSString stringWithFormat:@"/ios/%@/%@/%@", appName, event, label]
                                    withError:&error];
    [MobClick event:event label:label];   
}

+ (void)trackEventWithAppName:(NSString *)appName andEvent:(NSString *)event
{
    NSError * error = nil;
    [[GANTracker sharedTracker] trackPageview:[NSString stringWithFormat:@"/ios/%@/%@/%@", appName, event, nil]
                                    withError:&error];
    [MobClick event:event];
}

@end
