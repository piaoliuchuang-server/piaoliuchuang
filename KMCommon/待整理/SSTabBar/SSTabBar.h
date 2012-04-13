//
//  SSTabBar.h
//  Essay
//
//  Created by YuTianhang on 12-03-04.
//  Copyright (c) 2011年 Invidel. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    TAB_TYPE_FLICK,
    TAB_TYPE_SLIDE
} TAB_TYPE;

@protocol SSTabBarDelegate;

@interface SSTabBar : UIView {

	NSMutableArray *_itemAry;
	NSMutableArray *_itemLabelAry;
	TAB_TYPE _tabType;
	int _index;
	int _preIndex;
	BOOL _hidden;
}

@property (nonatomic, assign) id<SSTabBarDelegate> ssDelegate;

@end

@protocol SSTabBarDelegate <NSObject>

@required
- (void)ssTabBar:(SSTabBar *)tabBar didSelectItemAtIndex:(int)index;

@end
