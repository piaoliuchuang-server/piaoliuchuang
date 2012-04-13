//
//  SSSlideBgSegmentControl.m
//  BaseGallery
//
//  Created by Tianhang Yu on 12-1-4.
//  Copyright (c) 2012年 99fang. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "SSSlideBgSegmentControl.h"


@implementation SSSlideBgSegmentControl

@synthesize ssDelegate = _ssDelegate;

@synthesize items=_items;
@synthesize bgImageView=_bgImageView;
@synthesize slideBgImageView=_slideBgImageView;


#pragma mark - private
- (void)itemBtnClicked:(id)sender
{
    UIButton *btn = sender;
    int index = btn.tag;
    
    [UIView animateWithDuration:0.3f animations:^{
        CGRect frame = _slideBgImageView.frame;    
        CGFloat subviewWidth = self.bounds.size.width / [_items count];
        frame.origin.x = subviewWidth * index;
        
        _slideBgImageView.frame = frame;  
    }];
    
    if (_ssDelegate != nil) {
        if ([_ssDelegate respondsToSelector:@selector(slideBgSegmentControl:didSelectAtIndex:)]) {
            [_ssDelegate slideBgSegmentControl:self didSelectAtIndex:index];
        }
    }
}


#pragma mark - public
- (void)setItems:(NSArray *)items
{
    [_items release];
    [items retain];
    _items = items;
    
    CGFloat subviewWidth = self.bounds.size.width / [_items count];
    CGFloat subviewHeight = self.bounds.size.height;
    CGFloat subviewOffsetX = 0.f;
    CGFloat subviewOffsetY = 0.f;
    
    _slideBgImageView.frame = CGRectMake(subviewOffsetX, subviewOffsetY, subviewWidth, subviewHeight);
    
    int tag = 0;
    for (UIButton *btn in _items) {
        btn.frame = CGRectMake(subviewOffsetX, subviewOffsetY, subviewWidth, subviewHeight);
        btn.tag = tag;
        btn.backgroundColor = [UIColor clearColor];
//        [btn setBackgroundImage:[UIImage imageNamed:@"sort_buttons_normal_middle.png"] forState:UIControlStateNormal];
//        [btn setBackgroundImage:[UIImage imageNamed:@"sort_buttons_select_middle.png"] forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(itemBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
        subviewOffsetX += subviewWidth;
        tag ++;
    }
}

- (void)layoutSubviews
{
    _bgImageView.frame = self.bounds;
}


#pragma mark - init&memory
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.layer.cornerRadius = 6.5f;
        self.layer.masksToBounds = YES;
        
        self.bgImageView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sort_buttons_normal_middle.png"]] autorelease];
        _bgImageView.backgroundColor = [UIColor clearColor];
        [self addSubview:_bgImageView];
        
        self.slideBgImageView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sort_buttons_select_middle.png"]] autorelease];
        _slideBgImageView.backgroundColor = [UIColor clearColor];
        [self addSubview: _slideBgImageView];
    }
    return self;
}

- (void)dealloc
{
    self.items = nil;
    self.bgImageView = nil;
    self.slideBgImageView = nil;
    
    [super dealloc];
}

@end
