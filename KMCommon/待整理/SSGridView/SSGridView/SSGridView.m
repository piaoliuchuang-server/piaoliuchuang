//
//  SSGridView.m
//  SSGridView
//
//  Created by Tianhang Yu on 11-12-16.
//  Copyright (c) 2011年 99fang. All rights reserved.
//

#import "SSGridView.h"
#import "SSGridViewCell.h"

@implementation SSGridView
@synthesize ssEditing=_ssEditing;

- (void)setSsEditing:(BOOL)ssEditing
{
    for (UIView *v in self.subviews) {
        if ([v isKindOfClass:[SSGridViewCell class]]) {
            [((SSGridViewCell *)v) setSsEditing:ssEditing];
        }
    }
    
    _ssEditing = ssEditing;
}

- (void)reloadData
{
    [super reloadData];
    
//    self.ssEditing = NO;
}

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

@end
