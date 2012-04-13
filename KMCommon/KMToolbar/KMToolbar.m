//
//  SSVerticalToolbar.m
//  BaseGallery
//
//  Created by Tianhang Yu on 11-12-11.
//  Copyright (c) 2011年 99fang. All rights reserved.
//

#import "KMToolbar.h"
#import "KMToolbarButton.h"

#define TOOLBAR_PADDING 5.f

@implementation KMToolbar
@synthesize items=_items, orderType=_orderType;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)dealloc 
{
    [super dealloc];
}

- (void)layoutSubviews
{
    if (_orderType == TOOLBAR_ORDER_VERTICAL_NORMAL) 
    {
        CGFloat subviewsWidth   = self.frame.size.width - 2*TOOLBAR_PADDING;
        CGFloat subviewsHeight  = 0.f;
        CGFloat subviewsOffsetX = TOOLBAR_PADDING;
        CGFloat subviewsOffsetY = TOOLBAR_PADDING;
        
        for (int i=0; i<[_items count] ;i++) {
            UIButton *button = [_items objectAtIndex:i];
            subviewsHeight = button.frame.size.height * (subviewsWidth / button.frame.size.width);
            button.frame = CGRectMake(subviewsOffsetX, subviewsOffsetY, subviewsWidth, subviewsHeight);
            subviewsOffsetY += subviewsHeight;
        }
    } 
    else if (_orderType == TOOLBAR_ORDER_VERTICAL_UPSIDEDOWN) 
    {
        CGFloat subviewsWidth   = self.frame.size.width - 2*TOOLBAR_PADDING;
        CGFloat subviewsHeight  = 0.f;
        CGFloat subviewsOffsetX = TOOLBAR_PADDING;
        CGFloat subviewsOffsetY = 0.f;
        
        for (int i=0; i<[_items count] ;i++) {
            UIButton *button = [_items objectAtIndex:i];
            subviewsHeight = button.frame.size.height * (subviewsWidth / button.frame.size.width);
            
            if (i == 0) {
                subviewsOffsetY = self.frame.size.height - (subviewsHeight + TOOLBAR_PADDING) * [_items count];
            }
            
            button.frame = CGRectMake(subviewsOffsetX, subviewsOffsetY, subviewsWidth, subviewsHeight);
            subviewsOffsetY += subviewsHeight;
        }
    } 
    else if (_orderType == TOOLBAR_ORDER_HORIZONTAL_NORMAL)
    {
        CGFloat subviewsWidth   = 0.f;
        CGFloat subviewsHeight  = self.frame.size.height - 2*TOOLBAR_PADDING;
        CGFloat subviewsOffsetX = TOOLBAR_PADDING;
        CGFloat subviewsOffsetY = TOOLBAR_PADDING;
        
        for (int i=0; i<[_items count] ;i++) {
            UIButton *button = [_items objectAtIndex:i];
            subviewsWidth = button.frame.size.width * (subviewsHeight / button.frame.size.height);
            button.frame = CGRectMake(subviewsOffsetX, subviewsOffsetY, subviewsWidth, subviewsHeight);
            subviewsOffsetX += subviewsWidth + TOOLBAR_PADDING;
        }
    }
    else if (_orderType == TOOLBAR_ORDER_HORIZONTAL_RIGHT_TO_LEFT)
    {
        CGFloat subviewsWidth   = 0.f;
        CGFloat subviewsHeight  = self.frame.size.height - 2*TOOLBAR_PADDING;
        CGFloat subviewsOffsetX = 0.f;
        CGFloat subviewsOffsetY = TOOLBAR_PADDING;
        
        for (int i=0; i<[_items count] ;i++) {
            UIButton *button = [_items objectAtIndex:i];
            subviewsWidth = button.frame.size.width * (subviewsHeight / button.frame.size.height);
            
            if (i == 0) {
                subviewsOffsetX = self.frame.size.width - (subviewsWidth + TOOLBAR_PADDING) * [_items count];
            }
            
            button.frame = CGRectMake(subviewsOffsetX, subviewsOffsetY, subviewsWidth, subviewsHeight);
            subviewsOffsetX += subviewsWidth + TOOLBAR_PADDING;
        }
    }
}


#pragma mark - public
- (void)setItems:(NSArray *)items
{
    [items retain];
    [_items release];
    _items = items;
    
    for (int i=0; i<[items count]; i++) {
        if ([[items objectAtIndex:i] isKindOfClass:[KMToolbarButton class]]) {
            KMToolbarButton *item = [items objectAtIndex:i];
            item.index = i;
            [self addSubview:item];
        }
    }
    
    [self layoutSubviews];
}

@end
