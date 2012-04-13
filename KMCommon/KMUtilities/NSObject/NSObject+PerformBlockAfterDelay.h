//
//  NSObject+PerformBlockAfterDelay.h
//  Drawus
//
//  Created by Tianhang Yu on 12-3-27.
//  Copyright (c) 2012年 99fang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (PerformBlockAfterDelay)

- (void)performBlock:(void (^)(void))block 
          afterDelay:(NSTimeInterval)delay;

@end
