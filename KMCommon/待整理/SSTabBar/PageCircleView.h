//
//  PageCircleView.h
//  NewHouse
//
//  Created by kimimaro on 11-8-31.
//  Copyright 2011年 99fang.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PageCircleView : UIView {
    CGRect currentFrame;
    UIColor * currentColor;
    NSString * currentString;
}

@property (nonatomic, retain) UILabel * pageNumberLabel;

- (id)initWithFrame:(CGRect)aFrame andColor:(UIColor *)aColor andText:(NSString *)aString;
- (void)changeColor:(UIColor *)aColor;

@end
