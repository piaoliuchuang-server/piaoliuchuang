//
//  LoadCommentOperation.m
//  Gallery
//
//  Created by 剑锋 屠 on 1/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LoadCommentOperation.h"
#import "CJSONDeserializer.h"
#import "FeedbackConstants.h"
#import "FeedbackViewController.h"

@implementation LoadCommentOperation

- (id)initWithAppKey:(NSString *)appKey
{
    self = [super init];
    if (self) {
        mAppKey = [appKey copy];
    }
    
    return self;
}

- (void)start
{
    NSString * urlStr = [NSString stringWithFormat:@"%@list/?appkey=%@&app_version=%@&uuid=%@&device=%@&os_version=%@", APP_PREFIX, mAppKey, [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"], [FeedbackViewController getUniqueIdentifier], [[[UIDevice currentDevice] model] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], [[[UIDevice currentDevice] systemVersion] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//    NSLog(@"url: %@", urlStr);
    NSURL * url = [NSURL URLWithString:urlStr];

    NSData * data = [[NSData alloc] initWithContentsOfURL:url];
    
    CJSONDeserializer * jsonparser = [[CJSONDeserializer alloc] init];
    NSDictionary * root = [jsonparser deserialize:data error:nil];
    [jsonparser release];
    [data release];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:KEY_FEEDBACK_RESULT object:root];
}

- (void)dealloc
{
    [mAppKey release];
    
    [super dealloc];
}

@end
