//
//  SSGridViewCell.m
//  BaseGallery
//
//  Created by Tianhang Yu on 11-12-9.
//  Copyright (c) 2011年 99fang. All rights reserved.
//

#import "SSGridViewCell.h"


@implementation SSGridViewCell
@synthesize dataSource=_dataSource, delegate=_delegate, index=_index, ssEditing=_ssEditing;


#pragma mark - private
- (void)numberOfUnits
{
    if (_dataSource != nil) {
        //need update following code
        if ([_dataSource respondsToSelector:@selector(numberOfUnitsInGridViewCell:withIndex:)]) {
            _unitCount = [_dataSource numberOfUnitsInGridViewCell:self withIndex:_index];
            _totalUnitCout = [_dataSource totalNumberOfUnitsInGridViewCell:self];
        } else {
            if ([_dataSource respondsToSelector:@selector(numberOfUnitsInGridViewCell:)]) {
                _unitCount = [_dataSource numberOfUnitsInGridViewCell:self];
                _totalUnitCout = [_dataSource totalNumberOfUnitsInGridViewCell:self];
            }
        }
    }
}

- (void)units
{
    if (_dataSource != nil) {
        if ([_dataSource respondsToSelector:@selector(gridViewCell:unitForColumnAtIndex:)]) {
            
            CGFloat subviewOffsetX = 0.f;
            CGFloat subviewOffsetY = 0.f;
            CGFloat subviewWidth = self.frame.size.width / _totalUnitCout;
            CGFloat subviewHeight = self.frame.size.height;
            
            for (int i=0; i < _unitCount; i++) {
                SSGridCellUnit *unit = [_dataSource gridViewCell:self unitForColumnAtIndex:i];
                unit.ssUnitDelegate = self;
                unit.index = i;
                unit.frame = CGRectMake(subviewOffsetX, subviewOffsetY, subviewWidth, subviewHeight);
                [unit layoutSubviews];
                [self addSubview:unit];
                
                unit.editing = _ssEditing;
                
                subviewOffsetX += subviewWidth;
            }
        }
    }
}


#pragma mark - public
- (void)reloadData
{
    int count = [self.subviews count];
    for (int i=0; i < count; i++) {
        [[self.subviews objectAtIndex:0] removeFromSuperview];
    }
    [self numberOfUnits];
    [self units];
}

- (void)setSsEditing:(BOOL)ssEditing
{   
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[SSGridCellUnit class]]) {
            [((SSGridCellUnit *)view) setEditing:ssEditing];
        }
    }
    
    _ssEditing = ssEditing;
}


#pragma mark - SSGridCellUnitDelegate
- (void)didAnyTapInSSGridCellUnit:(SSGridCellUnit *)gridCellUnit
{
    if (_delegate != nil) {
        if ([_delegate respondsToSelector:@selector(gridViewCell:didSelectColumnAtIndex:)]) {
            [_delegate gridViewCell:self didSelectColumnAtIndex:gridCellUnit.index];
        }
    }
}

- (void)didDelBtnClickedInSSGridCellUnit:(SSGridCellUnit *)gridCellUnit
{
    if (_delegate != nil) {
        if ([_delegate respondsToSelector:@selector(gridViewCell:didDeleteColumnAtIndex:)]) {
            [_delegate gridViewCell:self didDeleteColumnAtIndex:gridCellUnit.index];
        }
    }
}


#pragma mark - init
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
