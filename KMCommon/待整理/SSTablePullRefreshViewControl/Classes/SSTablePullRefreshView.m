//
//  NNHTableViewPullRefresh.m
//  Diary
//
//  Created by David Fox on 2/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SSTablePullRefreshView.h"
#import "UIColorAdditions.h"

#define FLIP_ANIMATION_DURATION 0.18f

@interface SSTablePullRefreshView (Private)

- (void) setState:(SSPullRefreshState)state;

@end

@implementation SSTablePullRefreshView
@synthesize delegate=SS_delegate;

- (id)initWithFrame:(CGRect)frame {
    
	if ((self = [super initWithFrame:frame])) {
		
        CALayer *layer = [CALayer layer];
		layer.frame = CGRectMake(0.0f, frame.size.height - 162.0f, frame.size.width, 162.0f);
		layer.contentsGravity = kCAGravityResizeAspectFill;
		layer.contents = (id)[UIImage imageNamed:@"refresh.png"].CGImage;   //refresh.png has not used
		[[self layer] addSublayer:layer];
		SS_refreshImage = layer;
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//		self.backgroundColor = [UIColor colorWithRed:238.0/255.0 green:246.0/255.0 blue:252.0/255.0 alpha:1.0];
        self.backgroundColor = [UIColor clearColor];
		
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, frame.size.height - 20.0f, self.frame.size.width , 20.0f)];
		label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		label.font = [UIFont systemFontOfSize:10.0f];
		label.textColor = [UIColor colorWithHexString:@"#999999"];
//		label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
//		label.shadowOffset = CGSizeMake(0.0f, 1.0f);
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = UITextAlignmentCenter;
		[self addSubview:label];
		SS_upDatedLabel = label;
		[label release];
		//设置最后更新日期标签的性质
		label = [[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.height - 45.0f, self.frame.size.width, 20.0f)];
		label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		label.font = [UIFont boldSystemFontOfSize:12.0f];
		label.textColor = [UIColor colorWithHexString:@"#99ccff"];
//		label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
//		label.shadowOffset = CGSizeMake(0.0f, 1.0f);
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = UITextAlignmentCenter;
		[self addSubview:label];
		SS_statusLabel = label;
		[label release];
		//设置状态标签的性质
		layer = [CALayer layer];
		layer.frame = CGRectMake(25.0f, frame.size.height - 65.0f, 30.0f, 55.0f);
		layer.contentsGravity = kCAGravityResizeAspect;
		layer.contents = (id)[UIImage imageNamed:@"SSTablePullRefreshViewBlueArrow.png"].CGImage;
		[[self layer] addSublayer:layer];
		SS_arrowImage = layer;
		//设置箭头的绘画层
		UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		view.frame = CGRectMake(25.0f, frame.size.height - 38.0f, 20.0f, 20.0f);
		[self addSubview:view];
		SS_activityView = view;
		[view release];
		//设置进度条
		SS_upDataItemLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, frame.size.height - 30.0f, self.frame.size.width, 20.0f)];
		SS_upDataItemLabel.text = @"加载了n条";
		SS_hasSuper = NO;
		[self setState:SSPullRefreshNormal];
		
    }
	
    return self;
	
}

- (NSString *)getSSRefreshLastUpdatedDate
{
    return SS_upDatedLabel.text;
}

- (void)setState:(SSPullRefreshState)state{
	
	switch (state) {
		case SSPullRefreshPulling:
			
			SS_statusLabel.text = @"松开立即更新...";
			[CATransaction begin];
			[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
			SS_arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
			[CATransaction commit];
			//视图下拉开始，播放箭头转向动画（由下向上），提示用户松开更新内容
			break;
		case SSPullRefreshNormal:
			
			if (SS_state == SSPullRefreshPulling) {
				[CATransaction begin];
				[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
				SS_arrowImage.transform = CATransform3DIdentity;
				[CATransaction commit];
			}//第一次设置不会触发前面这段代码
			//如果当前状态是下拉更新提示中，箭头向下
			SS_statusLabel.text = @"下拉可以更新...";
			[SS_activityView stopAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions]; 
			SS_arrowImage.hidden = NO;
			SS_arrowImage.transform = CATransform3DIdentity;
			[CATransaction commit];
			//第一次设置的时候，只是初始话为默认的情况，并不会显示出来
			//只有进行下来的时候才能看到效果
			//停止进度指示，将箭头向下
			[self SSRefreshLastUpdatedDate];
			//显示最后更新时间
			
			break;
		case SSPullRefreshLoading:
			
			SS_statusLabel.text = @"正在加载...";
			[SS_activityView startAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions]; 
			SS_arrowImage.hidden = YES;
			[CATransaction commit];
			//开始进度指示，箭头隐藏
			break;
		default:
			break;
	}
	
	SS_state = state; //保存变更状态
}

- (void)SSRefreshSetAlertMessage:(NSString*)message
{
	SS_upDataItemLabel.text=message;
}

- (void)SSRefreshLastUpdatedDate {
	
	if ([SS_delegate respondsToSelector:@selector(SSTablePullRefreshViewDataSourceLastUpdated:)]) {
		
		NSDate *date = [SS_delegate SSTablePullRefreshViewDataSourceLastUpdated:self];
		
		NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
		[formatter setAMSymbol:@"AM"];
		[formatter setPMSymbol:@"PM"];
		[formatter setDateFormat:@"MM/dd/yyyy hh:mm a"];
		NSString * olddate=[[NSUserDefaults standardUserDefaults] objectForKey:@"NNHTableViewPullRefreshView_date"];
		if (olddate!=nil) {
			SS_upDatedLabel.text=olddate;
		}
		else {
			SS_upDatedLabel.text = [NSString stringWithFormat:@"最后更新于: %@", [formatter stringFromDate:date]];
		}
		olddate=[NSString stringWithFormat:@"最后更新于: %@", [formatter stringFromDate:date]];
		[[NSUserDefaults standardUserDefaults] setObject:olddate forKey:@"NNHTableViewPullRefreshView_date"];
		[[NSUserDefaults standardUserDefaults] synchronize];
		[formatter release];
		
	} else {
		
		SS_upDatedLabel.text = nil;
		
	}
	
}
#pragma mark -
#pragma mark ScrollView Methods

- (void)SSRefreshScrollViewDidScroll:(UIScrollView *)scrollView {	
	
	if (SS_state == SSPullRefreshLoading) {
		
		CGFloat offset = MAX(scrollView.contentOffset.y * -1, 0);
		offset = MIN(offset, 60);
		scrollView.contentInset = UIEdgeInsetsMake(offset, 0.0f, 0.0f, 0.0f);
		//加载数据中
		
	} else if (scrollView.isDragging) {
		//开始下拉
		BOOL loading = NO;
		if ([SS_delegate respondsToSelector:@selector(SSTablePullRefreshViewDataSourceIsLoading:)]) {
			loading = [SS_delegate SSTablePullRefreshViewDataSourceIsLoading:self];
		}
		//是否在loading，没在loading就要做事情了
		if (SS_state == SSPullRefreshPulling && scrollView.contentOffset.y > -65.0f && scrollView.contentOffset.y < 0.0f && !loading) {
			[self setState:SSPullRefreshNormal];
			//干嘛不松手推回去呀。。。
		} else if (SS_state == SSPullRefreshNormal && scrollView.contentOffset.y < -65.0f && !loading) {
			[self setState:SSPullRefreshPulling];
			//下拉65距离，并且没有处于加载数据的状态中，转换状态，提示用户松手
		}
		
		if (scrollView.contentInset.top != 0) {
			scrollView.contentInset = UIEdgeInsetsZero;
		}
	}
	
}

- (void)SSRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView {
	
	BOOL loading = NO;
	if ([SS_delegate respondsToSelector:@selector(SSTablePullRefreshViewDataSourceIsLoading:)]) {
		loading = [SS_delegate SSTablePullRefreshViewDataSourceIsLoading:self];
	}
	if (scrollView.contentOffset.y <= - 65.0f && !loading) {
		//松手了，没在加载，那么触发加载吧，加载数据
		if ([SS_delegate respondsToSelector:@selector(SSTablePullRefreshViewDidTriggerRefresh:)]) {
			[SS_delegate SSTablePullRefreshViewDidTriggerRefresh:self];
		}
		
		[self setState:SSPullRefreshLoading];
		//进入加载状态
		//[UIView beginAnimations:nil context:NULL];
		//[UIView setAnimationDuration:0.2];
		//scrollView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
		//[UIView commitAnimations];
		//慢慢的滑动回去了
	}
	
}

- (void)SSRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView ShowAlert:(BOOL)alert {	
	
	[UIView beginAnimations:nil context:NULL];
	[UIView  setAnimationDuration:0.3];
	[scrollView  setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
	[UIView  commitAnimations];
	if (SS_hasSuper) {
		[SS_upDataItemLabel removeFromSuperview];
		SS_hasSuper=NO;
	}

	SS_upDataItemLabel.frame=CGRectMake(0.0f,0.0f,self.frame.size.width,0.0f);
	if (alert) {
		[scrollView addSubview:SS_upDataItemLabel];
		SS_hasSuper=YES;
		[UIView beginAnimations:@"UpDatedLabel" context:nil];
		[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDuration:1.5f];
		SS_upDataItemLabel.frame=CGRectMake(0.0f, 0.0f,self.frame.size.width, 40.0f);
		[UIView commitAnimations];
	}

	[self setState:SSPullRefreshNormal];
	//加载完数据了，回到常态，准备再次被拉
	
}
- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
	if ([animationID isEqualToString:@"UpDatedLabel"] ) {
		[UIView beginAnimations:@"UpDatedLabelEnd" context:nil];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
		[UIView setAnimationDuration:1.5f];
		SS_upDataItemLabel.frame=CGRectMake(0.0f, 0.0f,self.frame.size.width, 0.0f);
		[UIView commitAnimations];
	}else if([animationID isEqualToString:@"UpDatedLabelEnd"]){
		if (SS_hasSuper) {
			SS_hasSuper=NO;
			[SS_upDataItemLabel removeFromSuperview];
			
		}
	}
}
- (void)dealloc {
	SS_delegate=nil;
	SS_activityView = nil;
	SS_statusLabel = nil;
	SS_arrowImage = nil;
	SS_upDatedLabel = nil;
	[SS_upDatedLabel release];
	SS_upDatedLabel=nil;
    [super dealloc];
}


@end
