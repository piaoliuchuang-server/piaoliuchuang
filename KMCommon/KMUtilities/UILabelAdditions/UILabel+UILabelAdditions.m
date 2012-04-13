//
//  UILabel+UILabelAdditions.m
//  Drawus
//
//  Created by Tianhang Yu on 12-4-2.
//  Copyright (c) 2012年 99fang. All rights reserved.
//

#import "UILabel+UILabelAdditions.h"

@implementation UILabel (UILabelAdditions)

- (void)heightToFit:(CGFloat)fixWidth
{
    self.numberOfLines = 0.f;
    
    CGRect frame = self.frame;
    
    CGSize size = [self.text sizeWithFont:self.font
                        constrainedToSize:CGSizeMake(fixWidth, 9999.f)
                            lineBreakMode:UILineBreakModeCharacterWrap];
    CGFloat textHeight = size.height;
    
    frame.size.width = fixWidth;
    frame.size.height = textHeight;
    
    self.frame = frame;
}

@end
