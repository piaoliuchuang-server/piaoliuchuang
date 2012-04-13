//
//  KMPopupButtonView.m
//  Drawus
//
//  Created by Tianhang Yu on 12-3-23.
//  Copyright (c) 2012年 99fang. All rights reserved.
//

#import "KMPopupButtonView.h"

#define VIEW_PADDING 5.f


@interface KMPopupButtonView () {

	CGRect _visibleFrame;
    int _selectIndex;
}

@property (nonatomic, retain) UIButton *backgroundBtn;

@end


@implementation KMPopupButtonView

@synthesize kmDelegate=_kmDelegate;
@synthesize items=_items;
@synthesize backgroundBtn=_backgroundBtn;

#pragma mark - private

- (void)backgroundBtnClicked:(id)sender
{
	for (int i = 0; i < [_items count]; ++i)
	{
        if (_selectIndex == i) {
            KMPopupButton *item = [_items objectAtIndex:i];
            
            item.popupState = POPUP_BUTTON_STATE_SELECTED;    
        }
	}

	if (_kmDelegate != nil)
	{
		if ([_kmDelegate respondsToSelector:@selector(didClickedBackgroundBtnInPopupButtonView:delay:)])
		{
			[_kmDelegate didClickedBackgroundBtnInPopupButtonView:self delay:POPUP_DURATION];
		}
	}
}

#pragma mark - public

- (void)setItems:(NSArray *)items
{
	[_items release];
	_items = [items retain];
    
	CGRect aFrame = _visibleFrame;
    
	CGFloat subviewsX      = aFrame.origin.x + VIEW_PADDING;
	CGFloat subviewsY      = aFrame.origin.y + VIEW_PADDING;
	CGFloat subviewsWidth  = aFrame.size.height - 2*VIEW_PADDING;
	CGFloat subviewsHeight = aFrame.size.height - 2*VIEW_PADDING;
    
	for (int i = 0; i < [items count]; ++i)
	{
		KMPopupButton *item = [items objectAtIndex:i];
		item.kmDelegate = self;
		item.visibleFrame = CGRectMake(subviewsX, subviewsY, subviewsWidth, subviewsHeight);
		if (i == 0)
		{
			item.popupState = POPUP_BUTTON_STATE_SELECTED;
		}
        item.index = i;
		[self addSubview:item];
        
		subviewsX += subviewsWidth + 2*VIEW_PADDING;
	}
    
    [self sendSubviewToBack:_backgroundBtn];
}

#pragma mark - default

- (id)initWithFrame:(CGRect)frame visibleFrame:(CGRect)visibleFrame
{
    self = [super initWithFrame:frame];
    if (self) {

    	_visibleFrame = visibleFrame;
        _selectIndex = 0;

 		self.backgroundBtn = [UIButton buttonWithType:UIButtonTypeCustom];
 		_backgroundBtn.frame = self.bounds;
        _backgroundBtn.hidden = YES;
 		_backgroundBtn.backgroundColor = [UIColor clearColor];
 		[_backgroundBtn addTarget:self action:@selector(backgroundBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
 		[self addSubview:_backgroundBtn];
        [self sendSubviewToBack:_backgroundBtn];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    _backgroundBtn.frame = self.bounds;
}

- (void)dealloc
{
	self.backgroundBtn = nil;
	self.items = nil;

	[super dealloc];
}

#pragma mark - KMPopupButtonDelegate

- (void)popupButton:(KMPopupButton *)popupButton didClickCenterBtn:(UIButton *)centerBtn
{
	for (int i = 0; i < [_items count]; ++i)
	{
		KMPopupButton *item = [_items objectAtIndex:i];
		if (popupButton != item)
		{
			item.popupState = POPUP_BUTTON_STATE_NORMAL;
		}
		else
		{
		    _selectIndex = i;
		}
	}
    
    if (_kmDelegate != nil) {
        if ([_kmDelegate respondsToSelector:@selector(popupButton:inPopupButtonView:didClickCenterBtn:)]) {
            [_kmDelegate popupButton:popupButton inPopupButtonView:self didClickCenterBtn:centerBtn];
        }
    }
}

- (void)popupButton:(KMPopupButton *)popupButton didSelectItemAtIndex:(int)index
{
	if (_kmDelegate != nil)
	{
		if ([_kmDelegate respondsToSelector:@selector(popupButton:inPopupButtonView:didSelectItemAtIndex:)])
		{
			[_kmDelegate popupButton:popupButton inPopupButtonView:self didSelectItemAtIndex:index];
		}
	}
	
	if (_kmDelegate != nil)
	{
		if ([_kmDelegate respondsToSelector:@selector(didClickedBackgroundBtnInPopupButtonView:delay:)])
		{
			[_kmDelegate didClickedBackgroundBtnInPopupButtonView:self delay:POPUP_DURATION];
		}
	}
}

- (void)popupButton:(KMPopupButton *)popupButton didPopupItems:(BOOL)popup
{
    if (_selectIndex == popupButton.index) {
        _backgroundBtn.hidden = !popup;
    }
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
