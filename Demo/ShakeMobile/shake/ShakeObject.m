//
//  ShakeObject.m
//  ShakeMobile
//
//  Created by he yk on 3/14/12.
//  Copyright (c) 2012 qh. All rights reserved.
//

#import "ShakeObject.h"

@implementation ShakeObject
@synthesize  delegate;

-(void)dealloc{
    [super dealloc];
    delegate =nil;
    
}

- (ShakeObject*) init{
    
	self = [super init];
	
	if (nil != self) {
        [[UIAccelerometer sharedAccelerometer] setUpdateInterval:(1.0 / kAccelerometerFrequency)];
        [[UIAccelerometer sharedAccelerometer] setDelegate:self];
        
    }
    return self;
}

#pragma mark UIAccelerometer delegate
- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration{
    
    
    static NSInteger shakeCount = 0;
    static NSDate *shakeStart;
    NSDate *now = [[NSDate alloc] init];
    
    ////  摇晃 2秒内
    NSDate *checkDate = [[NSDate alloc] initWithTimeInterval:2.0f sinceDate:shakeStart];
    
    ////  超过2秒  重计算晃动次数
    if ([now compare:checkDate] == NSOrderedDescending || shakeStart == nil)
    {
        shakeCount = 0;
        [shakeStart release];
        shakeStart = [[NSDate alloc] init];
    }
    [now release];
    [checkDate release];
    
    //// 三轴摇晃的G力超过２则 列入计次
    if (fabsf(acceleration.x) >1.8 || fabsf(acceleration.y) > 1.8|| fabsf(acceleration.z) >1.8)
    {
        shakeCount++;
        if (shakeCount > 4)
        {
            // [locationManager startUpdatingLocation];
            [self.delegate shakeCallback];
            
            shakeCount = 0;
            [shakeStart release];
            shakeStart = [[NSDate alloc] init];
        }
    }
}


@end
