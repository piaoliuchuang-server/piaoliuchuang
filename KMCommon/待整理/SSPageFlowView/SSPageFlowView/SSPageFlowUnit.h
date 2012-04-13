//
//  SSPageFlowUnit.h
//  SSPageFlowView
//
//  Created by Tianhang Yu on 12-1-16.
//  Copyright (c) 2012年 99fang. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol SSPageFlowUnitDelegate;

@interface SSPageFlowUnit : UIView <UIGestureRecognizerDelegate>

@property (nonatomic, assign) id<SSPageFlowUnitDelegate> ssDelegate;
@property (nonatomic) NSInteger index;
@property (nonatomic) BOOL reportAnyTapEnable;

- (void)unitClean;
- (void)reportAnyTapGesture:(UITapGestureRecognizer *)recognizer;

@end


@protocol SSPageFlowUnitDelegate <NSObject>

@optional
- (void)didAnyTapInSSPageFlowUnit:(SSPageFlowUnit *)pageFlowUnit;

@end