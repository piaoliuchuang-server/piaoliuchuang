//
//  ShakeRequestSever.h
//  ShakeMobile
//
//  Created by he yk on 3/20/12.
//  Copyright (c) 2012 qh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASINetworkQueue.h"
#import "NetWorkHelper.h"
#import "ASIFormDataRequest.h"
//#import "ShakeRecieveData.h"
//#import "ShakeXMLParser.h"


@protocol ShakeRequestSeverDelegate;

@interface ShakeRequestSever :NSObject<ASIHTTPRequestDelegate>{
    
    id<ShakeRequestSeverDelegate>   delegate;
    BOOL                            bIsRequest;
}
@property(nonatomic,assign) id<ShakeRequestSeverDelegate>delegate;
@property BOOL bIsRequest;
-(void)SendData:(NSString*)xmlData;
@end

@protocol ShakeRequestSeverDelegate <NSObject>

- (void)geShakeDataFinished:(ShakeRequestSever*)shakeRequest recieveData:(NSData*)shakeRecieveData;
@end