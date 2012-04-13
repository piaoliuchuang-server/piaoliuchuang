//
//  ShakeXMLParser.h
//  ShakeMobile
//
//  Created by he yk on 3/20/12.
//  Copyright (c) 2012 qh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShakeRecieveDataVO.h"
@interface ShakeXMLParser : NSObject{
 
   
}
+ (ShakeRecieveDataVO*)parseAdminShakeResult:(NSData*)aData;
+ (ShakeRecieveDataVO*)parseMemberShakeResult:(NSData*)aData;
@end
