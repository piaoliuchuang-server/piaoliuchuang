//
//  ShakeXMLCreateor.h
//  ShakeMobile
//
//  Created by he yk on 3/20/12.
//  Copyright (c) 2012 qh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShakeXMLCreateor : NSObject
{

}






+(NSString*)adminShakeXMLCreate:(NSString*)deviceName 
                   adminLatitue:(NSString*)latitude 
                 adminLongitude:(NSString*)longitude;

+(NSString*)memberShakeXMLCreateLatitue:(NSString*)latitude 
                 memberLongitude:(NSString*)longitude;
@end
