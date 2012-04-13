//
//  AdView.h
//  BaseGallery
//
//  Created by Tianhang Yu on 12-1-10.
//  Copyright (c) 2012年 99fang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GADBannerView.h"

@interface AdView : UIView {
 
    BOOL hasLoaded;
}

@property (nonatomic) BOOL isPortrait;

@property (nonatomic, retain) GADBannerView *bannerView;
@property (nonatomic, retain) UIButton *hideBtn;

- (id)initWithFrame:(CGRect)frame withRootViewController:(UIViewController *)viewController;
- (void)showAdView;
- (void)hideAdView;

@end
