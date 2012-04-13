//
//  NetWorkHelper.m
//  MobleSecurity
//
//  Created by andylee1988 on 11-8-11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NetWorkHelper.h"


@implementation NetWorkHelper
@synthesize queue;
- (void)dealloc {
    [queue release];
    [super dealloc];
}

- (id)init {
    if (self = [super init]) {
        @synchronized(self) {
            if (!self.queue) {
                ASINetworkQueue *queueTemp = [[ASINetworkQueue alloc] init];
                self.queue = queueTemp;
                [self.queue setShouldCancelAllRequestsOnFailure:NO];
                [queueTemp release];
            }
        }
    }
    return self;
}

- (void)cancelAllRequest {
//    [self.queue cancelAllOperations];
    [self.queue setShouldCancelAllRequestsOnFailure:YES];
    for (ASIHTTPRequest *activeRequest in [self.queue operations]) {
        [activeRequest clearDelegatesAndCancel];
        activeRequest.delegate = nil;
    }
    [self.queue cancelAllOperations];
}




@end
