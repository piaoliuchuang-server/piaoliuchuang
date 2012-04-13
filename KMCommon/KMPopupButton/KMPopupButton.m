//
//  PopupButton.m
//  DrawBoard
//
//  Created by Tianhang Yu on 12-3-22.
//  Copyright (c) 2012年 99fang. All rights reserved.
//

#import "KMPopupButton.h"
#import "KMPopupButtonItem.h"
#import <QuartzCore/QuartzCore.h>

#define VERTICAL_PADDING 5.f

CGFloat thinBorderWidth  = 2.f;
CGFloat thickBorderWidth = 4.f;


@interface KMPopupButton () {

	POPUP_BUTTON_STATE _popupState;
	POPUP_BUTTON_DIRECTION _popupDirection;

	BOOL _popup;
    int _selectIndex;
    CGRect _visibleFrame;
}

@property (nonatomic, retain) CALayer *borderLayer;

@end


@implementation KMPopupButton

@synthesize kmDelegate    =_kmDelegate;
@synthesize borderColor   =_borderColor;
@synthesize centerColor   =_centerColor;
@synthesize selectColor   =_selectColor;
@synthesize unSelectColor =_unSelectColor;
@synthesize itemAry       =_itemAry;
@synthesize image         =_image;
@synthesize title         =_title;
@synthesize visibleFrame  =_visibleFrame;
@synthesize index=_index;

@synthesize popupState    =_popupState;
@synthesize centerBtn     =_centerBtn;
@synthesize borderLayer   =_borderLayer;

#pragma mark - private

- (void)changBorderWidth:(BORDER_TYPE)borderType
{
	if (borderType == BORDER_TYPE_THIN)
	{
        _borderLayer.frame = rectWithPadding(_visibleFrame, -thinBorderWidth);
		_borderLayer.borderWidth = thinBorderWidth;
	}
	else if (borderType == BORDER_TYPE_THICK)
	{
        _borderLayer.frame = rectWithPadding(_visibleFrame, -thickBorderWidth);
		_borderLayer.borderWidth = thickBorderWidth;
	}
}

- (void)popupItems:(BOOL)popup
{
	if (_popup != popup)
	{
		if (_popupDirection == POPUP_BUTTON_DIRECTION_UP)
		{
			_popup = popup;

            if (_popup) 
            {
                CGRect aFrame = _visibleFrame;
                
                __block CGFloat subviewsX      = aFrame.origin.x;
                __block CGFloat subviewsY      = aFrame.origin.y - aFrame.size.height - VERTICAL_PADDING;
                __block CGFloat subviewsWidth  = aFrame.size.width;
                __block CGFloat subviewsHeight = aFrame.size.height;
                
                [UIView animateWithDuration:POPUP_DURATION animations:^{
                    for (int i = 0; i < [_itemAry count]; ++i)
                    {
                        KMPopupButtonItem *item = [_itemAry objectAtIndex:i];
                        item.frame = CGRectMake(subviewsX, subviewsY, subviewsWidth, subviewsHeight);
                        
                        subviewsY -= aFrame.size.height + VERTICAL_PADDING;
                    }    
                } completion:^(BOOL finished){
                    if (_kmDelegate != nil)
                    {
                        if([_kmDelegate respondsToSelector:@selector(popupButton:didPopupItems:)])
                        {
                            [_kmDelegate popupButton:self didPopupItems:popup];
                        }
                    }
                }];
            }
            else
            {
                CGRect aFrame = _visibleFrame;
                
                [UIView animateWithDuration:POPUP_DURATION animations:^{
                    for (int i = 0; i < [_itemAry count]; ++i)
                    {
                        KMPopupButtonItem *item = [_itemAry objectAtIndex:i];
                        item.frame = aFrame;
                    }    
                } completion:^(BOOL finished){
                	if (_kmDelegate != nil)
                    {
                        if([_kmDelegate respondsToSelector:@selector(popupButton:didPopupItems:)])
                        {
                            [_kmDelegate popupButton:self didPopupItems:popup];
                        }
                    }
                }];
            }
			
		}

		// 暂不支持其他方向
	}
}

- (void)centerBtnClicked:(id)sender
{
	if (_popupState != POPUP_BUTTON_STATE_POPUPED)
	{
		self.popupState = POPUP_BUTTON_STATE_POPUPED;
        
        if (_kmDelegate != nil)
		{
			if ([_kmDelegate respondsToSelector:@selector(popupButton:didClickCenterBtn:)])
			{
				[_kmDelegate popupButton:self didClickCenterBtn:sender];
			}
		}
	}
}

- (void)itemAction:(id)sender
{
	if (_popupState == POPUP_BUTTON_STATE_POPUPED)
	{
		self.popupState = POPUP_BUTTON_STATE_SELECTED;

		KMPopupButtonItem *item = sender;
        _selectIndex = item.index;

        for (int i = 0; i < [_itemAry count]; ++i)
        {
            KMPopupButtonItem *item = [_itemAry objectAtIndex:i];
            item.backgroundColor = _selectIndex == i ? _selectColor : _unSelectColor;
        }

		if (_kmDelegate != nil)
		{
			if ([_kmDelegate respondsToSelector:@selector(popupButton:didSelectItemAtIndex:)])
			{
				[_kmDelegate popupButton:self didSelectItemAtIndex:item.index];
			}
		}
	}
}

- (void)setPopupState:(POPUP_BUTTON_STATE)popupState
{
    if (_popupState != popupState)
    {
        _popupState = popupState;

        if (_popupState == POPUP_BUTTON_STATE_NORMAL)
        {
            [self changBorderWidth:BORDER_TYPE_THIN];
            [self popupItems:NO];
        }
        else if (_popupState == POPUP_BUTTON_STATE_POPUPED)
        {
            [self changBorderWidth:BORDER_TYPE_THICK];
            [self popupItems:YES];
        }
        else if (_popupState == POPUP_BUTTON_STATE_SELECTED)
        {
            [self changBorderWidth:BORDER_TYPE_THICK];
            [self popupItems:NO];
        }    
    }
}

#pragma mark - public

- (void)setSelectColor:(UIColor *)selectColor
{
    [_selectColor release];
    _selectColor = [selectColor retain];

    ((KMPopupButtonItem *)[_itemAry objectAtIndex:_selectIndex]).backgroundColor = _selectColor;
}

- (void)setVisibleFrame:(CGRect)visibleFrame
{
    CGRect frame = visibleFrame;
    int count = [_itemAry count];
    
    frame.origin.y    -= (visibleFrame.size.height + VERTICAL_PADDING) * count;
    frame.size.height += (visibleFrame.size.height + VERTICAL_PADDING) * count;   
    
    self.frame             = frame;
    _visibleFrame          = visibleFrame;
    _visibleFrame.origin.x = 0;
    _visibleFrame.origin.y = self.bounds.size.height - _visibleFrame.size.height;

    _centerBtn.frame = _visibleFrame;
    _borderLayer.frame = rectWithPadding(_visibleFrame, - _borderLayer.borderWidth);
    
    for (KMPopupButtonItem *item in _itemAry) {
        item.frame = _visibleFrame;
    }
}

- (void)setImage:(UIImage *)image
{
	[_image release];
	_image = [image retain];

	[_centerBtn setImage:_image forState:UIControlStateNormal];
}

- (void)setTitle:(NSString *)title
{
    [_title release];
    _title = [title retain];
    
    [_centerBtn setTitle:_title forState:UIControlStateNormal];
}

- (void)setItemAry:(NSArray *)itemAry
{
    [_itemAry release];
    _itemAry = [itemAry retain];
	
    CGRect aFrame = _visibleFrame;

	for (int i = 0; i < [_itemAry count]; ++i)
	{
		KMPopupButtonItem *item = [itemAry objectAtIndex:i];
		item.frame = aFrame;
		[item addTarget:self action:@selector(itemAction:) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:item];
		[self sendSubviewToBack:item];
	}
}

- (void)setBorderColor:(UIColor *)borderColor
{
    [_borderColor release];
    _borderColor = [borderColor retain];
    
    _borderLayer.borderColor = _borderColor.CGColor;
}

- (void)setCenterColor:(UIColor *)centerColor
{
    [_centerColor release];
    _centerColor = [centerColor retain];

    _centerBtn.backgroundColor = _centerColor;
}

#pragma mark - default

- (id)initWithVisibleFrame:(CGRect)visibleframe itemCount:(int)count centerBtn:(UIButton *)centerBtn
{
    CGRect frame = visibleframe;

    frame.origin.y    -= (visibleframe.size.height + VERTICAL_PADDING) * count;
    frame.size.height += (visibleframe.size.height + VERTICAL_PADDING) * count;

    self = [super initWithFrame:frame];
    if (self) {
        _visibleFrame = visibleframe;
        _visibleFrame.origin.x = 0;

        _popupDirection = POPUP_BUTTON_DIRECTION_UP;
        _popupState     = POPUP_BUTTON_STATE_NORMAL;

        _selectIndex = 0;

        _itemAry = [[NSMutableArray alloc] init];

        if (centerBtn == nil)
        {
            self.centerBtn = [UIButton buttonWithType:UIButtonTypeCustom];            
        }
        else
        {
            self.centerBtn = centerBtn;
        }

        _centerBtn.frame = _visibleFrame;
        _centerBtn.backgroundColor = [UIColor clearColor];
        [_centerBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_centerBtn addTarget:self action:@selector(centerBtnClicked:) forControlEvents:UIControlEventTouchUpInside]; 
        [self addSubview:_centerBtn];
        
        self.borderLayer = [[[CALayer alloc] init] autorelease];
        _borderLayer.frame = rectWithPadding(_visibleFrame, - thinBorderWidth);
        _borderLayer.borderColor = [UIColor blackColor].CGColor;
        _borderLayer.borderWidth = thinBorderWidth;
        _borderLayer.cornerRadius = 5.f;
        [self.layer addSublayer:_borderLayer];
    }
    return self;
}

- (void)dealloc
{
    self.borderColor   = nil;
    self.itemAry = nil;
    self.image = nil;
    self.title = nil;
	self.centerBtn     = nil;
    self.borderLayer = nil;

	[super dealloc];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
