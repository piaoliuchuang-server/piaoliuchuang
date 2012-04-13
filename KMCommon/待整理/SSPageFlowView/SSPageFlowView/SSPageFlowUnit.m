//
//  SSPageFlowUnit.m
//  SSPageFlowView
//
//  Created by Tianhang Yu on 12-1-16.
//  Copyright (c) 2012年 99fang. All rights reserved.
//

#import "SSPageFlowUnit.h"

@interface SSPageFlowUnit ()

@property (nonatomic, retain) UITapGestureRecognizer *anyTap;

@end

@implementation SSPageFlowUnit

@synthesize ssDelegate=_ssDelegate;
@synthesize index;
@synthesize reportAnyTapEnable=_reportAnyTapEnable;
@synthesize anyTap=_anyTap;

- (void)setReportAnyTapEnable:(BOOL)reportAnyTapEnable
{
    _reportAnyTapEnable = reportAnyTapEnable;
    _anyTap.enabled = _reportAnyTapEnable;
}

- (void)reportAnyTapGesture:(UITapGestureRecognizer *)recognizer
{
    if (_ssDelegate != nil) {
        if ([_ssDelegate respondsToSelector:@selector(didAnyTapInSSPageFlowUnit:)]) {
            [_ssDelegate didAnyTapInSSPageFlowUnit:self];
        }
    }
}

- (void)unitClean
{
    //should be extended
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.anyTap = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reportAnyTapGesture:)] autorelease];
        _anyTap.delegate = self;
        [self addGestureRecognizer:_anyTap];
    }
    return self;
}

- (void)dealloc
{    
    self.anyTap = nil;
    
    [super dealloc];
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
