//
//  CurrentLocationVO.m
//  ShakeMobile
//
//  Created by he yk on 3/20/12.
//  Copyright (c) 2012 qh. All rights reserved.
//

#import "CurrentLocationSV.h"
static CurrentLocationSV *sharedCurrentLocation = nil;

@implementation CurrentLocationSV
@synthesize CurrentCoordinate;

#pragma mark CLLocationManager delegate


+ (CurrentLocationSV*)sharedCurrentLocationSV {
    @synchronized(self){
        if (!sharedCurrentLocation) {
            sharedCurrentLocation = [[CurrentLocationSV alloc] init];
            [sharedCurrentLocation initLocationManager];
        }
    }
    return sharedCurrentLocation;
}


- (void)initLocationManager{
    if (locationManager==nil)   
    {  
        locationManager =[[CLLocationManager alloc] init];  
        if ([CLLocationManager locationServicesEnabled])   
        {  
            locationManager.delegate=self;  
            locationManager.desiredAccuracy=kCLLocationAccuracyBest;  
            locationManager.distanceFilter=10.0f;  
            [locationManager startUpdatingLocation];
        } 
    }  
    
  
}

-(void)dealloc{
    [super dealloc];
    [locationManager release];
}

- (void) locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation  
            fromLocation:(CLLocation *)oldLocation   
{    
    CurrentCoordinate = newLocation.coordinate;
    
}
@end
