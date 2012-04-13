//
//  KMPopupButtonView.h
//  Drawus
//
//  Created by Tianhang Yu on 12-3-23.
//  Copyright (c) 2012年 99fang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KMPopupButton.h"


@protocol KMPopupButtonViewDelegate;

@interface KMPopupButtonView : UIView <KMPopupButtonDelegate>

@property (nonatomic, assign) id<KMPopupButtonViewDelegate> kmDelegate; 
@property (nonatomic, retain) NSArray *items;

- (id)initWithFrame:(CGRect)frame visibleFrame:(CGRect)visibleFrame;

@end


@protocol KMPopupButtonViewDelegate <NSObject>

- (void)popupButton:(KMPopupButton *)popupButton inPopupButtonView:(KMPopupButtonView *)popupButtonView didSelectItemAtIndex:(int)index;
- (void)popupButton:(KMPopupButton *)popupButton inPopupButtonView:(KMPopupButtonView *)popupButtonView didClickCenterBtn:(UIButton *)centerBtn;
- (void)didClickedBackgroundBtnInPopupButtonView:(KMPopupButtonView *)popupButtonView delay:(CGFloat)delay;

@end