//
//  SSTabBar.m
//  Essay
//
//  Created by YuTianhang on 12-03-04.
//  Copyright (c) 2011年 Invidel. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "SSTabBar.h"

#define TEXT_COLOR_NORMAL    [UIColor grayColor]
#define TEXT_COLOR_HIGHLIGHT [UIColor whiteColor]

@interface SSTabBar()

@property (nonatomic, retain) UIImageView *itemBg;
@property (nonatomic, retain) UIImageView *tagBg;

@end

@implementation SSTabBar

@synthesize ssDelegate=_ssDelegate;

@synthesize itemBg=_itemBg;
@synthesize tagBg=_tagBg;

#pragma mark - private
- (void)disableSelectedButton:(UIButton *)btn
{
    for (int i = 0; i < 4; i++) {
        if (btn.tag == i) {
            [[_itemAry objectAtIndex:i] setEnabled:NO];
            [[_itemLabelAry objectAtIndex:i] setTextColor:TEXT_COLOR_HIGHLIGHT];
        }
    }
}

- (void)changeItemBg:(id)sender
{
    UIButton * btn = sender;
    _preIndex = _itemBg.frame.origin.x / _itemBg.frame.size.width;

    for (int i = 0; i < 4; i++) {
        if (btn.tag == i) {
            //do nothing
        }
        else {
            [[_itemAry objectAtIndex:i] setEnabled:YES];
            [[_itemLabelAry objectAtIndex:i] setTextColor:TEXT_COLOR_NORMAL];
        }
    }

    CGRect frame = _itemBg.frame;
    
    frame.origin.x = btn.frame.origin.x + (btn.frame.size.width - frame.size.width) / 2;
    frame.origin.y = (btn.frame.size.height - frame.size.height) / 2;
    
    if (_tabType == TAB_TYPE_SLIDE)
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.2f];
        [UIView setAnimationDelegate:self];

        _itemBg.frame = frame;

        [UIView commitAnimations];
    } else if (_tabType == TAB_TYPE_FLICK) {

        _itemBg.frame = frame;
    }

    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(disableSelectedButton:) object:[_itemAry objectAtIndex:_preIndex]];
    
    if (_tabType == TAB_TYPE_FLICK) {
        [self disableSelectedButton:btn];
    } else if (_tabType == TAB_TYPE_SLIDE) {
        [self performSelector:@selector(disableSelectedButton:) withObject:btn afterDelay:0.17f];    
    }
}

- (void)selectedTab:(id)sender
{
    UIButton *button = sender;

    if (_index == button.tag) {
        return;
    }

    _index = button.tag;

    if (_ssDelegate != nil) {
        if ([_ssDelegate respondsToSelector:@selector(ssTabBar:didSelectItemAtIndex:)]) {
            [_ssDelegate ssTabBar:self didSelectItemAtIndex:_index];
        }
    }

    [self performSelector:@selector(changeItemBg:) withObject:button];
}

- (void)hideSlideTabBar:(BOOL)hide animated:(BOOL)animated
{
    _hidden = hide;

    CGRect frame = self.bounds;

    if (animated) {

        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.35];

        if (hide) {
            [self setFrame:CGRectMake(- frame.size.width, frame.origin.y, frame.size.width, frame.size.height)];
        }
        else {
            [self setFrame:CGRectMake(0, frame.origin.y, frame.size.width, frame.size.height)];
        }

        [UIView commitAnimations];
    }
    else {
        if (hide) {
            [self setFrame:CGRectMake(- frame.size.width, frame.origin.y, frame.size.width, frame.size.height)];
        }
        else {
            [self setFrame:CGRectMake(0, frame.origin.y, frame.size.width, frame.size.height)];
        }
    }
}

#pragma mark - add tab items
- (void)itemBgTabBar
{
    CGRect frame = self.bounds;

    //给tabBar加上阴影
    CGColorRef darkColor = [[UIColor blackColor] colorWithAlphaComponent:0.3f].CGColor;
    CGColorRef lightColor = [UIColor clearColor].CGColor;
    CAGradientLayer * newShadow = [[CAGradientLayer alloc] init];
    newShadow.frame = CGRectMake(0, 0, frame.size.width, -4);
    newShadow.colors = [NSArray arrayWithObjects:(id)lightColor, (id)darkColor, nil];
    [self.layer addSublayer:newShadow];
    [newShadow release];

    int viewCount = 4;
    CGFloat width = frame.size.width / viewCount;
    CGFloat height = frame.size.height;

    self.tagBg = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:TAB_BG]] autorelease];
    _tagBg.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);

    [self addSubview:_tagBg];
    [self sendSubviewToBack:_tagBg];

    self.itemBg = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:TAB_SELECT_BG]] autorelease];
    [_itemBg sizeToFit];
    
    frame = _itemBg.frame;
    frame.origin.x = (width - frame.size.width) / 2;
    frame.origin.y = (height - frame.size.height) / 2;
    _itemBg.frame = frame;

    [self addSubview:_itemBg];

    _itemAry      = [[NSMutableArray arrayWithCapacity:viewCount] retain];
    _itemLabelAry = [[NSMutableArray arrayWithCapacity:viewCount] retain];

    int i = 0;
    while (i < viewCount) {
        UIButton * tempBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        tempBtn.frame = CGRectMake(i * width, 0, width, height);

        UIImage * tempImage = nil;
        UIImage * tempImage2 = nil;
        NSString * tempString = nil;
        switch (i) {
            case 0:
                tempImage = [UIImage imageNamed:TAB_NEW];
                tempImage2 = [UIImage imageNamed:TAB_NEW_HIGHLIGHT];
                tempString = @"最新";
                break;

            case 1:
                tempImage = [UIImage imageNamed:TAB_HOT];
                tempImage2 = [UIImage imageNamed:TAB_HOT_HIGHLIGHT];
                tempString = @"热门";
                break;

            case 2:
                tempImage = [UIImage imageNamed:TAB_FAVE];
                tempImage2 = [UIImage imageNamed:TAB_FAVE_HIGHLIGHT];
                tempString = @"收藏";
                break;

            case 3:
                tempImage = [UIImage imageNamed:TAG_MORE];
                tempImage2 = [UIImage imageNamed:TAB_MORE_HIGHLIGHT];
                tempString = @"更多";
                break;

            default:
                break;
        }

        [tempBtn setImage:tempImage forState:UIControlStateNormal];
        [tempBtn setImage:tempImage forState:UIControlStateHighlighted];
        [tempBtn setImage:tempImage2 forState:UIControlStateDisabled];
        [tempBtn setImageEdgeInsets:UIEdgeInsetsMake(5, 0, 15, 0)];

        UILabel * tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 32, 50, 10)];
        tempLabel.backgroundColor = [UIColor clearColor];
        tempLabel.text = tempString;
        
        tempLabel.textColor = TEXT_COLOR_NORMAL;
        tempLabel.font = [UIFont systemFontOfSize:10.f];
        [tempLabel sizeToFit];
        [tempLabel setFrame:CGRectMake(tempBtn.frame.size.width/2 - tempLabel.frame.size.width/2, tempLabel.frame.origin.y, tempLabel.frame.size.width, tempLabel.frame.size.height)];
        [tempLabel setTag:i];

        [tempBtn addSubview:tempLabel];
        [_itemLabelAry addObject:tempLabel];
        [tempLabel release];

        tempBtn.tag = i;
        [tempBtn addTarget:self action:@selector(selectedTab:) forControlEvents:UIControlEventTouchUpInside];

        [self addSubview:tempBtn];
        [_itemAry addObject:tempBtn];

        i++;
    }

    [[_itemAry objectAtIndex:0] setEnabled:NO];
    [[_itemLabelAry objectAtIndex:0] setTextColor:TEXT_COLOR_HIGHLIGHT];

    _hidden = NO;
}

#pragma mark - init & memory
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        _tabType = TAB_TYPE_SLIDE;
        [self setBackgroundColor:[UIColor clearColor]];
        [self itemBgTabBar];
    }
    return self;
}

- (void)dealloc
{
    self.itemBg = nil;
    self.tagBg = nil;

    [super dealloc];
}

@end
