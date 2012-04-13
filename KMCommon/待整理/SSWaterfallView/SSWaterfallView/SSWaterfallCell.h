//
//  SSWaterfallCell.h
//  BaseGallery
//
//  Created by Tianhang Yu on 11-12-7.
//  Copyright (c) 2011年 99fang. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol SSWaterfallCellDelegate;

@interface SSWaterfallCell : UIView <UIGestureRecognizerDelegate>

@property (nonatomic, assign) id<SSWaterfallCellDelegate> ssCellDelegate;

@property (nonatomic, retain) NSString *reuseIdentifier;
@property (nonatomic, retain) NSIndexPath *indexPath;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier;
- (void)cellClean;
- (void)reportAnyTapGesture:(UITapGestureRecognizer *)recognizer;

@end


@protocol SSWaterfallCellDelegate <NSObject>

@optional
- (void)didAnyTapInSSWaterfallCell:(SSWaterfallCell *)waterfallCell;

@end


