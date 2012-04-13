//
//  SSSimpleIndicator.h
//  BaseGallery
//
//  Created by Tianhang Yu on 12-2-10.
//  Copyright (c) 2012年 99fang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SimpleViewController : UIViewController

@property (nonatomic, retain) UILabel *msgLabel;

- (void)showMessage:(NSString *)msg withRect:(CGRect)aRect;
- (void)showMessage:(NSString *)msg withY:(CGFloat)y;

@end

@interface KMSimpleIndicator : UIWindow

@property (nonatomic, retain) SimpleViewController *rootVC;

+ (KMSimpleIndicator *)sharedIndicator;

- (void)showMessage:(NSString *)msg withRect:(CGRect)aRect;
- (void)showMessage:(NSString *)msg withY:(CGFloat)y;

@end
