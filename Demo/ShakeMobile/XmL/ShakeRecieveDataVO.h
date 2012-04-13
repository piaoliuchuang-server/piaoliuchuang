//
//  ShakeRecieveData.h
//  ShakeMobile
//
//  Created by he yk on 3/20/12.
//  Copyright (c) 2012 qh. All rights reserved.
//

#import <Foundation/Foundation.h>




@interface ShakeRecieveDataVO : NSObject{
    BOOL addOK;
    NSString *familyName;
}
@property (nonatomic,retain) NSString *familyName;
@property BOOL addOK;
@end
