//
//  SSWaterfallCell.m
//  BaseGallery
//
//  Created by Tianhang Yu on 11-12-7.
//  Copyright (c) 2011年 99fang. All rights reserved.
//

#import "SSWaterfallCell.h"


@implementation SSWaterfallCell

@synthesize ssCellDelegate=_ssCellDelegate; 
@synthesize reuseIdentifier=_reuseIdentifier;
@synthesize indexPath=_indexPath;


#pragma mark - public
- (void)reportAnyTapGesture:(UITapGestureRecognizer *)recognizer
{
    if (_ssCellDelegate != nil) {
        if ([_ssCellDelegate respondsToSelector:@selector(didAnyTapInSSWaterfallCell:)]) {
            [_ssCellDelegate didAnyTapInSSWaterfallCell:self];
        }
    }
}

- (void)cellClean
{
    //clean cell subviews
}

#pragma mark - init
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UITapGestureRecognizer *anyTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reportAnyTapGesture:)];
        anyTap.delegate = self;
        [self addGestureRecognizer:anyTap];
        [anyTap release];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [self initWithFrame:frame];
    if (self) {
        _reuseIdentifier = [reuseIdentifier copy]; 
    }
    return self;
}


@end
