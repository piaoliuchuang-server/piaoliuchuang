//
//  ShakeRequestSever.m
//  ShakeMobile
//
//  Created by he yk on 3/20/12.
//  Copyright (c) 2012 qh. All rights reserved.
//

#import "ShakeRequestSever.h"
#import "ASIFormDataRequest.h"


#define SHAKEURL @"http://mobiletest.evonsoft.com/sharkdemo/index.php"
#define  kIntRequestTimeOut 30

@implementation ShakeRequestSever
@synthesize delegate;
@synthesize bIsRequest;

-(void)ShakeRequestFinished:(ASIHTTPRequest *)request{

    
    NSData *responseData = [request responseData];
    
    
    [self.delegate geShakeDataFinished:self recieveData:responseData];
    bIsRequest=NO;
}
-(void)ShakeRequestFailed:(ASIHTTPRequest *)request{
    //NSError *error = [request error];
}



- (void)SendData:(NSString*)xmlData {
   
    NSURL *URL = [NSURL URLWithString:SHAKEURL];
    
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:URL];
    [request setValidatesSecureCertificate:NO];
    [request addPostValue:xmlData forKey:@"xml"];
    [request setDelegate:self];
    [request setRequestMethod:@"POST"];
    [request setTimeOutSeconds:kIntRequestTimeOut];
    [request setDidFinishSelector:@selector(ShakeRequestFinished:)];
    [request setDidFailSelector:@selector(ShakeRequestFailed:)];
    
    [request startAsynchronous];
    
    [request release];
    
}
- (void)requestStarted:(ASIHTTPRequest *)request{
     bIsRequest = YES;
}
-(void)dealloc{
    [super dealloc];
    delegate = nil;
}
@end
