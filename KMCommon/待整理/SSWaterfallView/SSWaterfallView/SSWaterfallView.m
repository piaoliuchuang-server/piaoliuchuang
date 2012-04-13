//
//  SSWaterfallView.m
//  BaseGallery
//
//  Created by Tianhang Yu on 11-12-7.
//  Copyright (c) 2011年 99fang. All rights reserved.
//

#import "SSWaterfallView.h"

#define CONTENT_VIEW_MARGIN 3.f


@implementation SSWaterfallView

@synthesize ssDataSource=_ssDataSource;
@synthesize ssDelegate=_ssDelegate;
@synthesize unitCount=_unitCount;


#pragma mark - private
- (void)numberOfUnits
{
    if (_ssDataSource != nil) {
        if ([_ssDataSource respondsToSelector:@selector(numberOfUnitsInWaterfallView:)]) {
            _unitCount = [_ssDataSource numberOfUnitsInWaterfallView:self];
        }
    }
}

- (void)numberOfRowsInUnit
{
    if (_ssDataSource != nil) {
        if ([_ssDataSource respondsToSelector:@selector(waterfallView:numberOfRowsInUnit:)]) {
            if ([mCellCountArray count] > 0) {
                [mCellCountArray removeAllObjects];
            }
            
            for (int i=0; i < _unitCount; i++) {
                [mCellCountArray addObject:[NSNumber numberWithInt:[_ssDataSource waterfallView:self numberOfRowsInUnit:i]]];
            }
        }
    }
}

- (void)cellRects
{
    if (_ssDataSource != nil) {
        if ([_ssDataSource respondsToSelector:@selector(waterfallView:cellFrameForRowAtIndexPath:)]) {
            
            CGFloat subviewOffsetX = CONTENT_VIEW_MARGIN;
            CGFloat subviewOffsetY = 0.f;
            CGFloat subviewWidth = (self.frame.size.width - 2*CONTENT_VIEW_MARGIN) / _unitCount;
            
            if ([mCellFrameArray count] > 0) {
                [mCellFrameArray removeAllObjects];
            }
            
            for (int i=0; i < _unitCount; i++) {
                NSInteger cellCount = [[mCellCountArray objectAtIndex:i] intValue];
                
                NSMutableArray *tmpArray = [[NSMutableArray alloc] init];
                
                for (int j=0; j < cellCount; j++) {
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:j inSection:i];
                    CGRect tmpFrame = [_ssDataSource waterfallView:self cellFrameForRowAtIndexPath:indexPath];
                    CGFloat tmpHeight = tmpFrame.size.height;
                    
                    if (_ssDelegate != nil) {
                        if ([_ssDelegate respondsToSelector:@selector(waterfallView:heightForRowAtIndexPath:)]) {
                            tmpHeight = [_ssDelegate waterfallView:self heightForRowAtIndexPath:indexPath];
                        }
                    }
                    
                    tmpFrame = CGRectMake(subviewOffsetX, subviewOffsetY, subviewWidth, tmpHeight);
                    NSString *tmpStr2 = NSStringFromCGRect(tmpFrame);
                    [tmpArray addObject:tmpStr2];
                    
                    subviewOffsetY += tmpFrame.size.height;
                }
                
                [mCellFrameArray addObject:tmpArray];
                [tmpArray release];
                
                subviewOffsetX += subviewWidth;
                
                CGFloat contentHeight = self.contentSize.height > subviewOffsetY ? self.contentSize.height : subviewOffsetY;
                self.contentSize = CGSizeMake(self.contentSize.width, contentHeight);
                
                subviewOffsetY = 0.f;
            }
        }
    }
}

- (void)reuseableCell:(SSWaterfallCell *)cell orNot:(BOOL)reuse
{
    if (reuse) {
        //add to current presented cells' array
        [mCurrentCellAry addObject:cell];

        [self addSubview:cell];
        [self sendSubviewToBack:cell];
        
        //rm from reusable sets' dictionary
        [[mReusableSetDict objectForKey:cell.reuseIdentifier] removeObject:cell];
        
        if ([[mReusableSetDict objectForKey:cell.reuseIdentifier] count] == 0) {
            [mReusableSetDict removeObjectForKey:cell.reuseIdentifier];
        }
    } else {
        //add to reusable sets' dictionary
        BOOL keyExist = NO;
        
        for (NSString *key in mReusableSetDict.allKeys) {
            if ([cell.reuseIdentifier isEqualToString:key]) {
                [[mReusableSetDict objectForKey:key] addObject:cell];
                keyExist = YES;
                break;
            }
        }
        
        //rm from current presented cells' array
        [mCurrentCellAry removeObject:cell];
        
        if (keyExist == NO) {
            NSMutableSet *tmpSet = [[NSMutableSet alloc] init];
            [tmpSet addObject:cell];
            [mReusableSetDict setObject:tmpSet forKey:cell.reuseIdentifier];
            [tmpSet release];
        }
        
        [cell cellClean];
        [cell removeFromSuperview];
    }
}

- (void)cells
{
//    NSLog(@"cell count:%@", mCellCountArray);
//    NSLog(@"cell frame:%@", mCellFrameArray);
//    NSLog(@"cells");
    
    for (NSArray *tmpAry in mCellFrameArray) {
        
        for (NSString *tmpStr in tmpAry) {
    
            CGRect tmpFrame = CGRectFromString(tmpStr);
            CGFloat top = tmpFrame.origin.y;
            CGFloat bottom = tmpFrame.origin.y + tmpFrame.size.height;
            
            if (bottom > self.contentOffset.y && top < self.contentOffset.y + self.frame.size.height) {
                
                BOOL isExist = NO;
                
                for (SSWaterfallCell *cell in mCurrentCellAry) {
                    if ([NSStringFromCGRect(cell.frame) isEqualToString:NSStringFromCGRect(tmpFrame)]) {
                        isExist = YES;
                        break;
                    }
                }
                
                if (isExist == NO) {
                    if (_ssDataSource != nil) {
                        if ([_ssDataSource respondsToSelector:@selector(waterfallView:cellForRowAtIndexPath:)]) {
                            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[tmpAry indexOfObject:tmpStr] inSection:[mCellFrameArray indexOfObject:tmpAry]];
                            
                            SSWaterfallCell *cell = [_ssDataSource waterfallView:self cellForRowAtIndexPath:indexPath];
                            cell.ssCellDelegate = self;
                            cell.frame = tmpFrame;
                            cell.indexPath = indexPath;
                            [self reuseableCell:cell orNot:YES];
                        }
                    }
                }
            }
        }
    }
    
    for (int i=0; i < [mCurrentCellAry count]; i++) {
        SSWaterfallCell *cell = [mCurrentCellAry objectAtIndex:i];
        
        CGRect tmpFrame = cell.frame;
        CGFloat top = tmpFrame.origin.y;
        CGFloat bottom = tmpFrame.origin.y + tmpFrame.size.height;
        
        if (bottom < self.contentOffset.y || top > self.contentOffset.y + self.frame.size.height) {
            [self reuseableCell:cell orNot:NO];
        }
    }
}


#pragma mark - public

- (void)reloadData
{
    [self numberOfUnits];
    [self numberOfRowsInUnit];
    [self cellRects];
    [self cells];
}

- (void)firstReloadData
{
    for (SSWaterfallCell *cell in mCurrentCellAry) {
        [cell cellClean];
        [cell removeFromSuperview];
    }
    
    [mCellCountArray  removeAllObjects];
    [mCellFrameArray  removeAllObjects];
    [mCurrentCellAry  removeAllObjects];
    [mReusableSetDict removeAllObjects];
    
    //add following code for scroll to top
    self.contentSize = CGSizeZero;
    
    [self reloadData];
}

- (SSWaterfallCell *)cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    for (SSWaterfallCell *cell in mCurrentCellAry) {
        if (cell.indexPath == indexPath) {
            return cell;
        }
    }
    
    return nil;
}

- (SSWaterfallCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier
{
    for (NSString *key in mReusableSetDict.allKeys) {
        if ([key isEqualToString:identifier]) {
            return [[mReusableSetDict objectForKey:identifier] anyObject];
        }
    }
    
    return nil;
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self cells];
}

#pragma mark - SSWaterfallCellDelegate
- (void)didAnyTapInSSWaterfallCell:(SSWaterfallCell *)waterfallCell
{
    if (_ssDelegate != nil) {
        if ([_ssDelegate respondsToSelector:@selector(waterfallView:didSelectRowAtIndexPath:)]) {
            [_ssDelegate waterfallView:self didSelectRowAtIndexPath:waterfallCell.indexPath];
        }
    }
}

#pragma mark - init
- (id)init
{
    self = [super init];
    if (self) {
        self.delegate = self;
        
        mCellCountArray = [[NSMutableArray alloc] init];
        mCellFrameArray = [[NSMutableArray alloc] init];
        mCurrentCellAry = [[NSMutableArray alloc] init];
        
        mReusableSetDict = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
        
        mCellCountArray = [[NSMutableArray alloc] init];
        mCellFrameArray = [[NSMutableArray alloc] init];
        mCurrentCellAry = [[NSMutableArray alloc] init];
        
        mReusableSetDict = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)dealloc 
{
    [mCellCountArray release];
    [mCellFrameArray release];
    [mCurrentCellAry release];
    [mReusableSetDict release];
    
    [super dealloc];
}


@end
