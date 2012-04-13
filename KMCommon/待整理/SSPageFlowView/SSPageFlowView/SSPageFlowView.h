//
//  SSPageFlowView.h
//  SSPageFlowView
//
//  Created by Tianhang Yu on 12-1-16.
//  Copyright (c) 2012年 99fang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SSPageFlowUnit.h"


@protocol SSPageFlowViewDataSource;
@protocol SSPageFlowViewDelegate;

@interface SSPageFlowView : UIView <UIScrollViewDelegate, SSPageFlowUnitDelegate> {
    
    NSInteger _unitCount;
    NSInteger _currentPage;     //start from zero
    CGFloat _pageWidth; //default is self.bounds.size.width
    
    BOOL isPageControlChangedPage;
    
    NSMutableArray *_currentUnitAry;
}

@property (nonatomic, assign) id<SSPageFlowViewDataSource> ssDataSource;
@property (nonatomic, assign) id<SSPageFlowViewDelegate> ssDelegate;

@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) NSInteger guardPageShortTo;  //guard a page to do sth such as loading more
@property (nonatomic) BOOL pageControlHidden;
@property (nonatomic) BOOL ssScrollEnable;

@property (nonatomic, retain) NSMutableArray *currentUnitAry;

- (void)reloadData;     //default start at index 0
- (void)reloadDataAtStartIndex:(NSInteger)index;
- (SSPageFlowUnit *)dequeueReusableUnit;

@end


@protocol SSPageFlowViewDataSource <NSObject>

@optional
- (void)pageFlowViewArriveAtGuardPage:(SSPageFlowView *)pageFlowView;

@required
- (NSInteger)numberOfUnitsInPageFlowView:(SSPageFlowView *)pageFlowView;
- (SSPageFlowUnit *)pageFlowView:(SSPageFlowView *)pageFlowView unitForColumnAtIndex:(NSInteger)index;

@end


@protocol SSPageFlowViewDelegate <NSObject>

@optional
- (void)pageFlowView:(SSPageFlowView *)pageFlowView didSelectColumnAtIndex:(NSInteger)index;

@end
