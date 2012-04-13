//
//  NetWorkHelper.h
//  MobleSecurity
//
//  Created by andylee1988 on 11-8-11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"
#import "ASINetworkQueue.h"

@interface NetWorkHelper : NSObject<ASIHTTPRequestDelegate> {
    ASINetworkQueue *queue;
}
@property(retain,nonatomic)ASINetworkQueue *queue;

- (void)cancelAllRequest;


@end
