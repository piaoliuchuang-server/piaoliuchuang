//
//  SSSimpleIndicator.h
//  BaseGallery
//
//  Created by Tianhang Yu on 12-2-10.
//  Copyright (c) 2012年 99fang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SimpleViewController;

@interface SSSimpleIndicator : UIWindow

@property (nonatomic, retain) SimpleViewController *rootVC;

+ (SSSimpleIndicator *)sharedIndicator;

- (void)showMessage:(NSString *)msg withRect:(CGRect)aRect;
- (void)showMessage:(NSString *)msg withY:(CGFloat)y;

@end
