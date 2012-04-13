//
//  CurrentLocationVO.h
//  ShakeMobile
//
//  Created by he yk on 3/20/12.
//  Copyright (c) 2012 qh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface CurrentLocationSV : NSObject<CLLocationManagerDelegate>{
   
     CLLocationManager *locationManager;
   

}
@property  CLLocationCoordinate2D CurrentCoordinate;
+ (CurrentLocationSV*)sharedCurrentLocationSV;

- (void)initLocationManager;
@end
