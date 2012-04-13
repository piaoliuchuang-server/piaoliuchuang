//
//  AdView.m
//  BaseGallery
//
//  Created by Tianhang Yu on 12-1-10.
//  Copyright (c) 2012年 99fang. All rights reserved.
//

#import "AdView.h"

#define HIDE_BTN_RIGHT_MARGIN 3.f
#define HIDE_BTN_TOP_MARGIN   3.f


@implementation AdView

@synthesize isPortrait=_isPortrait;

@synthesize bannerView=_bannerView;
@synthesize hideBtn=_hideBtn;


- (void)hideBtnClicked:(id)sender
{
    self.hidden = YES;
}

- (void)showAdView
{
    self.hidden = NO;
}

- (void)hideAdView
{
    self.hidden = YES;
}

- (id)initWithFrame:(CGRect)frame withRootViewController:(UIViewController *)viewController
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.hidden = YES;
        self.backgroundColor = [UIColor clearColor];
        
        self.bannerView = [[[GADBannerView alloc] initWithFrame:CGRectZero] autorelease];

        _bannerView.backgroundColor = [UIColor clearColor];
        _bannerView.adUnitID = @"a14f0ba24b39167";
        _bannerView.rootViewController = viewController;

        [self addSubview:_bannerView];
        
        self.hideBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_hideBtn setImage:[UIImage imageNamed:AD_CLOSE_BTN_BG] forState:UIControlStateNormal];
        [_hideBtn addTarget:self action:@selector(hideBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_hideBtn];
    }
    return self;
}

- (void)setIsPortrait:(BOOL)isPortrait
{
    _isPortrait = isPortrait;
    
    if (isPortrait) {
        _bannerView.frame = CGRectMake(0, 0, GAD_SIZE_320x50.width, GAD_SIZE_320x50.height);
        [_bannerView setCenter:CGPointMake(self.bounds.size.width / 2, _bannerView.center.y)];
        
        if (hasLoaded == NO) {
            hasLoaded = YES;
            [_bannerView loadRequest:[GADRequest request]];
        } 
        
        [_hideBtn sizeToFit];
        CGRect frame = _hideBtn.frame;
        frame.origin.x = _bannerView.frame.origin.x + _bannerView.bounds.size.width - _hideBtn.bounds.size.width / 2 - HIDE_BTN_RIGHT_MARGIN;
        frame.origin.y = HIDE_BTN_TOP_MARGIN;
        frame.size.width = _hideBtn.bounds.size.width / 2;
        frame.size.height = _hideBtn.bounds.size.height / 2;
        _hideBtn.frame = frame;
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
