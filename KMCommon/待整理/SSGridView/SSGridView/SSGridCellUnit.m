//
//  SSGridCellUnit.m
//  BaseGallery
//
//  Created by Tianhang Yu on 11-12-9.
//  Copyright (c) 2011年 99fang. All rights reserved.
//

#import "SSGridCellUnit.h"


@implementation SSGridCellUnit

@synthesize ssUnitDelegate=_ssUnitDelegate;
@synthesize enabled=_enabled;
@synthesize editing=_editing;
@synthesize index;

@synthesize delButton=_delButton;
@synthesize anyTap=_anyTap;


#pragma mark - private
- (void)reportAnyTapGesture:(UITapGestureRecognizer *)recognizer
{
    if (_ssUnitDelegate != nil) {
        if ([_ssUnitDelegate respondsToSelector:@selector(didAnyTapInSSGridCellUnit:)]) {
            [_ssUnitDelegate didAnyTapInSSGridCellUnit:self];
        }
    }
}

- (void)delBtnClicked:(id)sender
{
    if (_ssUnitDelegate != nil) {
        if ([_ssUnitDelegate respondsToSelector:@selector(didDelBtnClickedInSSGridCellUnit:)]) {
            [_ssUnitDelegate didDelBtnClickedInSSGridCellUnit:self];
        }
    }
}


#pragma mark - public
- (void)setEditing:(BOOL)editing
{
    _editing = editing;
    
    if (_editing == YES) {
        _anyTap.enabled = NO;
        _delButton.hidden = NO;
    } else {
        _anyTap.enabled = YES;
        _delButton.hidden = YES;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect tmpFrame = self.bounds;
    
    tmpFrame.origin.x = tmpFrame.size.width - 40.f;
    tmpFrame.origin.y = 0;
    tmpFrame.size.width = 40.f;
    tmpFrame.size.height = 40.f;
    
    [_delButton setFrame:tmpFrame];
    [self bringSubviewToFront:_delButton];
}


#pragma mark - UIGestureRecognizer
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return _enabled;
}


#pragma mark - init
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.anyTap = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reportAnyTapGesture:)] autorelease];
        [self addGestureRecognizer:_anyTap];
        
        self.delButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_delButton setImage:[UIImage imageNamed:@"delbtn_pad.png"] forState:UIControlStateNormal];
        _delButton.backgroundColor = [UIColor clearColor];
        _delButton.hidden = YES;
        [_delButton addTarget:self action:@selector(delBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_delButton];
    }
    return self;
}

- (void)dealloc {
    
    self.anyTap = nil;
    self.delButton = nil;
    
    [super dealloc];
}


@end
