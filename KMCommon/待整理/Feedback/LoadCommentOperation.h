//
//  LoadCommentOperation.h
//  Gallery
//
//  Created by 剑锋 屠 on 1/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoadCommentOperation : NSOperation
{
    NSString * mAppKey;
}

- (id)initWithAppKey:(NSString *)appKey;

@end
