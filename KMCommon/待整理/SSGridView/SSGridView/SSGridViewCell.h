//
//  SSGridViewCell.h
//  BaseGallery
//
//  Created by Tianhang Yu on 11-12-9.
//  Copyright (c) 2011年 99fang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSGridCellUnit.h"


@protocol SSGridViewCellDelegate;
@protocol SSGridViewCellDataSource;

@interface SSGridViewCell : UITableViewCell <SSGridCellUnitDelegate> {
    
    NSInteger _unitCount;
    NSInteger _totalUnitCout;
}

@property (nonatomic, assign) id<SSGridViewCellDelegate>   delegate;
@property (nonatomic, assign) id<SSGridViewCellDataSource> dataSource;
@property (nonatomic) NSInteger index;
@property (nonatomic) BOOL ssEditing;

- (void)reloadData;

@end


@protocol SSGridViewCellDataSource <NSObject>

@optional
- (NSInteger)numberOfUnitsInGridViewCell:(SSGridViewCell *)gridViewCell withIndex:(NSInteger)index;
- (NSInteger)numberOfUnitsInGridViewCell:(SSGridViewCell *)gridViewCell; 

@required
- (NSInteger)totalNumberOfUnitsInGridViewCell:(SSGridViewCell *)gridViewCell;
- (SSGridCellUnit *)gridViewCell:(SSGridViewCell *)gridViewCell unitForColumnAtIndex:(NSInteger)index;

@end


@protocol SSGridViewCellDelegate <NSObject>

@optional
- (void)gridViewCell:(SSGridViewCell *)gridViewCell didSelectColumnAtIndex:(NSInteger)index;
- (void)gridViewCell:(SSGridViewCell *)gridViewCell didDeleteColumnAtIndex:(NSInteger)index;

@end