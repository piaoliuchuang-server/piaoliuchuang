//
//  SSWaterfallView.h
//  BaseGallery
//
//  Created by Tianhang Yu on 11-12-7.
//  Copyright (c) 2011年 99fang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSWaterfallCell.h"


@protocol SSWaterfallViewDataSource;
@protocol SSWaterfallViewDelegate;

@interface SSWaterfallView : UIScrollView <UIScrollViewDelegate, SSWaterfallCellDelegate> {
    
    NSMutableArray *mCellCountArray;
    NSMutableArray *mCellFrameArray; 
    NSMutableArray *mCurrentCellAry;
    
    NSMutableDictionary *mReusableSetDict;
}

@property (nonatomic, assign) id<SSWaterfallViewDataSource> ssDataSource;
@property (nonatomic, assign) id<SSWaterfallViewDelegate> ssDelegate;
@property (nonatomic, readonly) NSInteger unitCount;
 
- (void)reloadData;
- (void)firstReloadData;
- (SSWaterfallCell *)cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (SSWaterfallCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier;

@end


@protocol SSWaterfallViewDataSource <NSObject>

@required
- (NSInteger)numberOfUnitsInWaterfallView:(SSWaterfallView *)waterfallView;
- (NSInteger)waterfallView:(SSWaterfallView *)waterfallView numberOfRowsInUnit:(NSInteger)unit;
- (CGRect)waterfallView:(SSWaterfallView *)waterfallView cellFrameForRowAtIndexPath:(NSIndexPath *)indexPath;
- (SSWaterfallCell *)waterfallView:(SSWaterfallView *)waterfallView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@end


@protocol SSWaterfallViewDelegate <NSObject>

@optional
- (CGFloat)waterfallView:(SSWaterfallView *)waterfallView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)waterfallView:(SSWaterfallView *)waterfallView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end
