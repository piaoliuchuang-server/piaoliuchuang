//
//  SSGridCellUnit.h
//  BaseGallery
//
//  Created by Tianhang Yu on 11-12-9.
//  Copyright (c) 2011年 99fang. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol SSGridCellUnitDelegate;

@interface SSGridCellUnit : UIView <UIGestureRecognizerDelegate>

@property (nonatomic, assign) id<SSGridCellUnitDelegate> ssUnitDelegate;
@property (nonatomic) NSInteger index;
@property (nonatomic) BOOL enabled;
@property (nonatomic) BOOL editing;

@property (nonatomic, retain) UIButton *delButton;
@property (nonatomic, retain) UITapGestureRecognizer *anyTap;

@end


@protocol SSGridCellUnitDelegate <NSObject>

@optional
- (void)didAnyTapInSSGridCellUnit:(SSGridCellUnit *)gridCellUnit;
- (void)didDelBtnClickedInSSGridCellUnit:(SSGridCellUnit *)gridCellUnit;

@end