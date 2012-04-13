//
//  CustomAlertView.m
//  CustomAlertViewDemo
//
//  Created by apple appale on 11-10-12.
//  Copyright 2011 sfdsfdsfsdfsdfs. All rights reserved.
//

#import "CustomAlertView.h"


@implementation CustomAlertView
@synthesize backgroundView;

- (id)initWithTitle:(NSString*)title Message:(NSString*)message Cancelbutton:(NSString*)cancelname OtherButton:(NSString*)otherbutton Delegate:(id)delegate SuperView:(UIView*)superView{
	
	self=[super initWithFrame:CGRectZero];
	self.backgroundColor=[UIColor grayColor];
	
	//set delegate
	m_delegate=delegate;
	mysuperView=superView;
	
	//set title
	UIFont *titlefont = [UIFont boldSystemFontOfSize:18];
	CGSize titlesize = [title sizeWithFont:titlefont constrainedToSize:CGSizeMake(180.0f, 1000.0f) lineBreakMode:UILineBreakModeCharacterWrap];
	
	UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, 10.0f, titlesize.width+5, titlesize.height+5)];
	titleLabel.backgroundColor = [UIColor clearColor];
	titleLabel.textColor=[UIColor whiteColor];
	titleLabel.font = titlefont;
	titleLabel.numberOfLines = 0;
	[titleLabel setTextAlignment:UITextAlignmentCenter];
	titleLabel.lineBreakMode = UILineBreakModeCharacterWrap;
	titleLabel.text = title;
	
	//set message
	UIFont *messagefont = [UIFont systemFontOfSize:16];
	CGSize messagesize = [message sizeWithFont:messagefont constrainedToSize:CGSizeMake(200.0f, 1000.0f) lineBreakMode:UILineBreakModeCharacterWrap];
	UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 10.0f+titlesize.height+8, messagesize.width+5, messagesize.height+5)];
	messageLabel.backgroundColor = [UIColor clearColor];
	messageLabel.textColor=[UIColor whiteColor];
	messageLabel.font = messagefont;
	messageLabel.numberOfLines = 0;
	messageLabel.lineBreakMode = UILineBreakModeCharacterWrap;
	messageLabel.text = message;
	
	//set cancelbtn
	UIButton *cancelBtn;
	UIButton *otherBtn;
	if (cancelname!=nil) {
		cancelBtn=[UIButton buttonWithType:UIButtonTypeCustom];
		[cancelBtn setTitle:cancelname forState:UIControlStateNormal];
		[cancelBtn setBackgroundImage:[UIImage imageNamed:@"btn4"] forState:UIControlStateNormal];
		cancelBtn.frame=CGRectMake(20, titlesize.height+messagesize.height+40, 200, 40);
		[cancelBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
		cancelBtn.tag=100;
	}	
	//set otherbutton
	if (otherbutton!=nil) {
		otherBtn=[UIButton buttonWithType:UIButtonTypeCustom];
		[otherBtn setTitle:otherbutton forState:UIControlStateNormal];
		[otherBtn setBackgroundImage:[UIImage imageNamed:@"btn4"] forState:UIControlStateNormal];
		[otherBtn setFrame:CGRectMake(20,titlesize.height+messagesize.height+90, 200, 40)];
		[otherBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
		otherBtn.tag=101;
		[self setFrame:CGRectMake(0, 0, 240, titlesize.height+messagesize.height+140)];
		[self addSubview:otherBtn];
	}else {
		[self setFrame:CGRectMake(0, 0, 240, titlesize.height+messagesize.height+100)];

	}
	self.layer.cornerRadius=18.0;
	
	
	[self addSubview:titleLabel];
	titleLabel.center=CGPointMake(120, titleLabel.center.y);
	[titleLabel release];
	
	[self addSubview:messageLabel];
	messageLabel.center=CGPointMake(120, messageLabel.center.y);
	[messageLabel release];
	
	[self addSubview:cancelBtn];
	
	//setbackground
	self.backgroundView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
	backgroundView.layer.cornerRadius=18.0;
	[self addSubview:backgroundView];
	[self sendSubviewToBack:backgroundView];

	[self setCenter:mysuperView.center];
    return self;
}

- (void)alertShow
{
	alertShowView=[[UIView alloc]initWithFrame:mysuperView.frame];
	alertShowView.backgroundColor=[UIColor clearColor];
	mysuperView.alpha=0.8;
	self.alpha = 0.0;
	[mysuperView addSubview:alertShowView];
	
	[mysuperView addSubview:self];
	CABasicAnimation *boundBigAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
	boundBigAnimation.removedOnCompletion = YES;
	boundBigAnimation.duration = 0.3;
	boundBigAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.2,0.2,1)];
	boundBigAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1,1.1,1)];

	[self.layer addAnimation:boundBigAnimation forKey:@"scaleBig"];
	[UIView beginAnimations:@"bgappear" context:nil];
	[UIView setAnimationDelegate:self];
	self.alpha = 1;
	[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
	[UIView commitAnimations];
}


- (void)buttonClick:(id)sender
{
	CABasicAnimation *boundSmallAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
	boundSmallAnimation.removedOnCompletion = YES;
	boundSmallAnimation.duration = 0.3;
	boundSmallAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0,1.0,1)];
	boundSmallAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.3,1.3,1)];
	[self.layer addAnimation:boundSmallAnimation forKey:@"scaleSmall"];
	
	[UIView beginAnimations:@"bgdisappear" context:nil];
	[UIView setAnimationDuration:0.3];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
	
	self.alpha = 0.0;
	
	[UIView commitAnimations];

}
- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
	if ([animationID isEqualToString:@"bgappear"])
	{

	}
	else if([animationID isEqualToString:@"bgdisappear"])
	{
		[[self superview] setAlpha:1.0];
		[alertShowView removeFromSuperview];
		[alertShowView release];
		[self removeFromSuperview];
		
	}
	
}


-(void)setAlertBackgroundImage:(NSString *)imagename{
	[backgroundView setImage:[UIImage imageNamed:imagename]];
}
- (void)dealloc {
    [super dealloc];
	[self.backgroundView release];
}


@end
