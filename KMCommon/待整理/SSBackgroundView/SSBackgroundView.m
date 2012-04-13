//
//  SSBackgroundView.m
//  BaseGallery
//
//  Created by Tianhang Yu on 12-1-8.
//  Copyright (c) 2012年 99fang. All rights reserved.
//

#import "SSBackgroundView.h"

@implementation SSBackgroundView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor blackColor];
        self.alpha = 0.7f;
        
    }
    return self;
}

- (void)addTarget:(id)delegate action:(SEL)action
{
    UITapGestureRecognizer *anyTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:action];
    [self addGestureRecognizer:anyTap];
    [anyTap release];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
