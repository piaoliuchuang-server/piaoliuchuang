//
//  ShakeRecieveData.m
//  ShakeMobile
//
//  Created by he yk on 3/20/12.
//  Copyright (c) 2012 qh. All rights reserved.
//

#import "ShakeRecieveDataVO.h"

@implementation ShakeRecieveDataVO
@synthesize  addOK,familyName;

-(void)dealloc{
    [super dealloc];
    [familyName release];
}
@end
