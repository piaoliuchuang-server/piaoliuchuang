//
//  SSTabBarItem.m
//  Essay
//
//  Created by YuTianhang on 12-03-04.
//  Copyright (c) 2011年 Invidel. All rights reserved.
//

#import "SSTabBarItem.h"
#import "PageCircleView.h"

@interface SSTabBarItem ()

@property (nonatomic, retain) UIButton *itemBtn;
@property (nonatomic, retain) UILabel  *titleLabel;

@end

@implementation SSTabBarItem

@synthesize itemBtn=_itemBtn;
@synthesize titleLabel=_titleLabel;

- (id)init
{
	self = [super init];
	if (self)
	{
		self.itemBtn = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		[self addSubview: _itemBtn];

		self.titleLabel = [[[UILabel alloc] init] autorelease];
		[self addSubview:_titleLabel];
	}
	return self;
}

- (void)dealloc
{
	self.itemBtn = nil;
	self.titleLabel = nil;

	[super dealloc];
}

- (void)setBadgeWithValue:(NSString *)value
{
    CGFloat circleX = 294.f;

    PageCircleView *tempCircle = [[PageCircleView alloc] initWithFrame:CGRectMake(circleX , 433, 28, 17)
                                                               andColor:[UIColor blackColor]
                                                                andText:[NSString stringWithFormat:@"%@", value]];
    tempCircle.hidden = NO;
    [self addSubview:tempCircle];
    [tempCircle release];
}

@end
