//
//  UIViewDemoViewController.m
//  UIViewDemo
//
//  Created by WANG Mengke on 09-12-6.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "UIViewDemoViewController.h"

@implementation UIViewDemoViewController

@synthesize lastAnimation;

- (void)dealloc {
    [super dealloc];
	[view2 release];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	[self.view addSubview:view2];
	[self.view addSubview:view3];
	[self.view addSubview:view1];
	isHalfAnimation = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)doUIViewAnimation:(id)sender{
	[UIView beginAnimations:@"animationID" context:nil];
	[UIView setAnimationDuration:0.5f];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationRepeatAutoreverses:NO];
	UIButton *theButton = (UIButton *)sender;
	switch (theButton.tag) {
		case 0:
			[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view cache:YES];//oglFlip, fromLeft 
			break;
		case 1:
			[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];//oglFlip, fromRight 	 
			break;
		case 2:
			[UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.view cache:YES];
			break;
		case 3:
			[UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self.view cache:YES];
			break;
		default:
			break;
	}
	[self.view exchangeSubviewAtIndex:1 withSubviewAtIndex:0];
	[UIView commitAnimations];
}

- (IBAction)doPrivateCATransition:(id)sender{
	//http://www.iphonedevwiki.net/index.php?title=UIViewAnimationState
	/*
	Don't be surprised if Apple rejects your app for including those effects,
	and especially don't be surprised if your app starts behaving strangely after an OS update.
	*/
	CATransition *animation = [CATransition animation];
    animation.delegate = self;
    animation.duration = 0.5f * slider.value;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
	animation.fillMode = kCAFillModeForwards;
	animation.endProgress = slider.value;
	animation.removedOnCompletion = NO;
	
	UIButton *theButton = (UIButton *)sender;
	
	switch (theButton.tag) {
		case 0:
			animation.type = @"cube";//---
			break;
		case 1:
			animation.type = @"suckEffect";//103
			break;
		case 2:
			animation.type = @"oglFlip";//When subType is "fromLeft" or "fromRight", it's the official one.
			break;
		case 3:
			animation.type = @"rippleEffect";//110
			break;
		case 4:
			animation.type = @"pageCurl";//101
			break;
		case 5:
			animation.type = @"pageUnCurl";//102
			break;
		case 6:
			animation.type = @"cameraIrisHollowOpen ";//107
			break;
		case 7:
			animation.type = @"cameraIrisHollowClose ";//106
			break;
		default:
			break;
	}
	
	[self.view.layer addAnimation:animation forKey:@"animation"];
	self.lastAnimation = animation;
	if(slider.value == 1)
		[self.view exchangeSubviewAtIndex:1 withSubviewAtIndex:0];//Just remove, not release or dealloc
	else{
		for (int i = 0; i < [self.view.subviews count]; i++) {
			[[self.view.subviews objectAtIndex:i] setUserInteractionEnabled:NO];
		}
		isHalfAnimation = YES;
	}
}

- (IBAction)doPublicCATransition:(id)sender{
	CATransition *animation = [CATransition animation];
    //animation.delegate = self;
    animation.duration = 0.5f;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
	animation.fillMode = kCAFillModeForwards;
	//animation.removedOnCompletion = NO;
	
	UIButton *theButton = (UIButton *)sender;
	/*
	 kCATransitionFade;
	 kCATransitionMoveIn;
	 kCATransitionPush;
	 kCATransitionReveal;
	 */
	/*
	 kCATransitionFromRight;
	 kCATransitionFromLeft;
	 kCATransitionFromTop;
	 kCATransitionFromBottom;
	 */
	switch (theButton.tag) {
		case 0:
			animation.type = kCATransitionPush;
			animation.subtype = kCATransitionFromTop;
			break;
		case 1:
			animation.type = kCATransitionMoveIn;
			animation.subtype = kCATransitionFromTop;
			break;
		case 2:
			animation.type = kCATransitionReveal;
			animation.subtype = kCATransitionFromTop;
			break;
		case 3:
			animation.type = kCATransitionFade;
			animation.subtype = kCATransitionFromTop;
			break;
		default:
			break;
	}
	
	[self.view.layer addAnimation:animation forKey:@"animation"];
}

- (IBAction)switchViews:(id)sender{
	UISegmentedControl *segmentedControl = sender;
	[[NSNotificationCenter defaultCenter] postNotificationName:@"switchViews" object:[NSNumber numberWithInteger:[segmentedControl selectedSegmentIndex]]];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	if (isHalfAnimation) {
		self.lastAnimation.duration = 0.5f - self.lastAnimation.duration;
		self.lastAnimation.startProgress = lastAnimation.endProgress;
		self.lastAnimation.endProgress = 1;
		self.lastAnimation.fillMode = kCAFillModeRemoved;
		[self.view.layer removeAnimationForKey:@"animation"];
		[self.view.layer addAnimation:self.lastAnimation forKey:@"animation"];
		[self.view exchangeSubviewAtIndex:1 withSubviewAtIndex:0];
		isHalfAnimation = NO;
		
		for (int i = 0; i < [self.view.subviews count]; i++) {
			[[self.view.subviews objectAtIndex:i] setUserInteractionEnabled:YES];
		}
	}
}

@end