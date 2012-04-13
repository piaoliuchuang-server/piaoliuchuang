//
//  NNHTableViewPullRefresh.h
//  Diary
//
//  Created by David Fox on 2/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


typedef enum{
	SSPullRefreshPulling = 0,
	SSPullRefreshNormal,
	SSPullRefreshLoading,	
} SSPullRefreshState;

@protocol SSTablePullRefreshViewDelegate;

@interface SSTablePullRefreshView : UIView {
	id					SS_delegate;
	SSPullRefreshState  SS_state;
	
	UILabel				*SS_upDatedLabel;
	UILabel				*SS_statusLabel;
	UILabel				*SS_upDataItemLabel;
	CALayer				*SS_arrowImage;
	UIActivityIndicatorView *SS_activityView;
    CALayer	             *SS_refreshImage;
    
	BOOL				SS_hasSuper;
}

@property (nonatomic,assign) id <SSTablePullRefreshViewDelegate> delegate;

- (void) animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context;
- (void) SSRefreshLastUpdatedDate;
- (void) SSRefreshScrollViewDidScroll:(UIScrollView *)scrollView;
- (void) SSRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView;
- (void) SSRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView ShowAlert:(BOOL)alert;
- (void) SSRefreshSetAlertMessage:(NSString*)message;

- (NSString *) getSSRefreshLastUpdatedDate;

@end


@protocol SSTablePullRefreshViewDelegate

- (void) SSTablePullRefreshViewDidTriggerRefresh:(SSTablePullRefreshView*)view;
- (BOOL) SSTablePullRefreshViewDataSourceIsLoading:(SSTablePullRefreshView*)view;
@optional
- (NSDate*) SSTablePullRefreshViewDataSourceLastUpdated:(SSTablePullRefreshView*)view;

@end
