//
//  SSSlideBgSegmentControl.h
//  BaseGallery
//
//  Created by Tianhang Yu on 12-1-4.
//  Copyright (c) 2012年 99fang. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol SSSlideBgSegmentControlDelegate;

@interface SSSlideBgSegmentControl : UIView

@property (nonatomic, assign) id<SSSlideBgSegmentControlDelegate> ssDelegate;

@property (nonatomic, retain) NSArray *items;
@property (nonatomic, retain) UIImageView *bgImageView;
@property (nonatomic, retain) UIImageView *slideBgImageView;

@end


@protocol SSSlideBgSegmentControlDelegate <NSObject>

@required
- (void)slideBgSegmentControl:(SSSlideBgSegmentControl *)slideBgSegControl didSelectAtIndex:(NSInteger)index;

@end
