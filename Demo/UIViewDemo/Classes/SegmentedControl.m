//
//  SegmentedControl.m
//  UIViewDemo
//
//  Created by Mengke WANG on 3/3/10.
//  Copyright 2010 Abvent R&D. All rights reserved.
//

#import "SegmentedControl.h"


@implementation SegmentedControl

- (void)awakeFromNib{
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(switchViews:)
												 name:@"switchViews"
											   object:nil];
}

- (void)switchViews:(NSNotification*)notification{
	NSNumber *viewNumber = [notification object];
	NSInteger i = [viewNumber integerValue];	
	[self setSelectedSegmentIndex:i];
	UIView *chosenView = nil;
	switch (i) {
		case 0:
			chosenView = view1;
			break;
		case 1:
			chosenView = view2;
			break;
		case 2:
			chosenView = view3;
			break;
		default:
			break;
	}
	if (chosenView) {
		[[viewController view] bringSubviewToFront:chosenView];
	}
}

- (void)dealloc{
	[super dealloc];
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
