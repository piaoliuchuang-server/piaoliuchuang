//
//  PopupButton.h
//  DrawBoard
//
//  Created by Tianhang Yu on 12-3-22.
//  Copyright (c) 2012年 99fang. All rights reserved.
//

#import <UIKit/UIKit.h>

#define POPUP_DURATION   0.5f

typedef enum {
	POPUP_BUTTON_STATE_NORMAL,
	POPUP_BUTTON_STATE_SELECTED,
	POPUP_BUTTON_STATE_POPUPED
} POPUP_BUTTON_STATE;

typedef enum {
	POPUP_BUTTON_DIRECTION_UP,
	POPUP_BUTTON_DIRECTION_DOWN,
	POPUP_BUTTON_DIRECTION_LEFT,
	POPUP_BUTTON_DIRECTION_RIGHT
} POPUP_BUTTON_DIRECTION;

typedef enum {
	BORDER_TYPE_THIN,
	BORDER_TYPE_THICK
} BORDER_TYPE;


@protocol KMPopupButtonDelegate;

@interface KMPopupButton : UIView

@property (nonatomic, assign) id<KMPopupButtonDelegate> kmDelegate;
@property (nonatomic) POPUP_BUTTON_STATE popupState;
@property (nonatomic, retain) UIColor *borderColor;
@property (nonatomic, retain) UIColor *centerColor;
@property (nonatomic, retain) UIColor *selectColor;
@property (nonatomic, retain) UIColor *unSelectColor;
@property (nonatomic, retain) NSArray *itemAry;
@property (nonatomic, retain) UIImage *image;
@property (nonatomic, retain) NSString *title;
@property (nonatomic) CGRect visibleFrame;
@property (nonatomic) int index;

@property (nonatomic, retain) UIButton *centerBtn;

- (id)initWithVisibleFrame:(CGRect)visibleframe itemCount:(int)count centerBtn:(UIButton *)centerBtn;

@end


@protocol KMPopupButtonDelegate <NSObject>

@optional
- (void)popupButton:(KMPopupButton *)popupButton didClickCenterBtn:(UIButton *)centerBtn;
- (void)popupButton:(KMPopupButton *)popupButton didSelectItemAtIndex:(int)index;
- (void)popupButton:(KMPopupButton *)popupButton didPopupItems:(BOOL)popup;

@end