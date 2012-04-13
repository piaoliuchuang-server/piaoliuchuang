//
//  SSPageFlowView.m
//  SSPageFlowView
//
//  Created by Tianhang Yu on 12-1-16.
//  Copyright (c) 2012年 99fang. All rights reserved.
//

#import "SSPageFlowView.h"

@interface SSPageFlowView ()

@property (nonatomic, retain) SSPageFlowUnit *reuseableUnit;
@property (nonatomic, retain) UIScrollView   *scrollView;
@property (nonatomic, retain) UIPageControl  *pageControl;

@end

@implementation SSPageFlowView

@synthesize ssDataSource=_ssDataSource;
@synthesize ssDelegate=_ssDelegate;
@synthesize currentPage=_currentPage;
@synthesize guardPageShortTo=_guardPageShortTo;
@synthesize pageControlHidden = _pageControlHidden;
@synthesize ssScrollEnable=_ssScrollEnable;
@synthesize currentUnitAry=_currentUnitAry;

@synthesize reuseableUnit=_reuseableUnit;
@synthesize scrollView=_scrollview;
@synthesize pageControl=_pageControl;


#pragma mark - private
- (void)numberOfUnits
{
    if (_ssDataSource != nil
        && [_ssDataSource respondsToSelector:@selector(numberOfUnitsInPageFlowView:)]) {
        
        _unitCount = [_ssDataSource numberOfUnitsInPageFlowView:self];
        
        _scrollview.frame = self.bounds;
        _scrollview.contentSize = CGSizeMake(_pageWidth * _unitCount, _scrollview.bounds.size.height);
        
        _pageControl.numberOfPages = _unitCount;
        [_pageControl sizeToFit];
        _pageControl.center = CGPointMake(self.bounds.size.width / 2, _scrollview.bounds.size.height *  5/6 + 15);
    }
}

- (void)units
{
    NSInteger tmpPage = (_scrollview.contentOffset.x + _pageWidth / 2) / _pageWidth;
    
    if (_currentPage < tmpPage) {
        
        _currentPage = tmpPage;
        
        for (int i=0; i < [_currentUnitAry count]; i++) {
            SSPageFlowUnit *unit = [_currentUnitAry objectAtIndex:i];
            if (unit.index < _currentPage - 1) {
//                NSLog(@"u index:%d", unit.index);
                [unit unitClean];
                self.reuseableUnit = unit;
                [unit removeFromSuperview];
                [_currentUnitAry removeObject:unit];    
            }
        }
                
        if (_ssDataSource != nil
            && [_ssDataSource respondsToSelector:@selector(pageFlowView:unitForColumnAtIndex:)]
            && _currentPage + 1 < _unitCount) {
            
            SSPageFlowUnit *unit = [_ssDataSource pageFlowView:self unitForColumnAtIndex:_currentPage + 1];
            unit.ssDelegate = self;
            unit.frame = CGRectMake(_pageWidth * (_currentPage + 1), 0, _pageWidth, _scrollview.bounds.size.height);
            [_scrollview addSubview:unit];
            [_currentUnitAry addObject:unit];            
        }
    } else if (_currentPage > tmpPage) {
        
        _currentPage = tmpPage;
        for (int i=0; i < [_currentUnitAry count]; i++) {
            SSPageFlowUnit *unit = [_currentUnitAry objectAtIndex:i];
            if (unit.index > _currentPage + 1) {
                [unit unitClean];
                self.reuseableUnit = unit;
                [unit removeFromSuperview];
                [_currentUnitAry removeObject:unit];
            }
        }
        
        if (_ssDataSource != nil
            && [_ssDataSource respondsToSelector:@selector(pageFlowView:unitForColumnAtIndex:)]
            && _currentPage - 1 >= 0) {
            
            SSPageFlowUnit *unit = [_ssDataSource pageFlowView:self unitForColumnAtIndex:_currentPage - 1];
            unit.ssDelegate = self;
            unit.frame = CGRectMake(_pageWidth * (_currentPage - 1), 0, _pageWidth, _scrollview.bounds.size.height);
            [_scrollview addSubview:unit];
            [_currentUnitAry addObject:unit];            
        }
    }
}


#pragma mark - public
- (void)setPageControlHidden:(BOOL)pageControlHidden
{
    _pageControlHidden = pageControlHidden;
    _pageControl.hidden = _pageControlHidden;
}

- (void)setSsScrollEnable:(BOOL)ssScrollEnable
{
    _ssScrollEnable = ssScrollEnable;
    _scrollview.scrollEnabled = _ssScrollEnable;
}

- (void)slideAction
{
    if (_unitCount > 0) {
        
        [self units];

        _currentPage = (_currentPage + 1) % _unitCount;
        
        [_scrollview scrollRectToVisible:CGRectMake(_pageWidth * _currentPage, 0, _pageWidth, _scrollview.bounds.size.height)
                                animated:YES];
        
        [self performSelector:@selector(slideAction) 
                   withObject:nil 
                   afterDelay:5]; 
    }
}

- (void)autoSlide
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self 
                                             selector:@selector(slideAction)
                                               object:nil];
    [self performSelector:@selector(slideAction) 
               withObject:nil 
               afterDelay:5];
}

- (void)reloadData
{
    for (SSPageFlowUnit *unit in _currentUnitAry) {
        [unit unitClean];
        [unit removeFromSuperview];
    }
    [_currentUnitAry removeAllObjects];
    
    self.reuseableUnit = nil;
    _currentPage = 0;
    _pageWidth = self.bounds.size.width;
    
    [self numberOfUnits];
    
    if (_ssDataSource != nil 
        && [_ssDataSource respondsToSelector:@selector(pageFlowView:unitForColumnAtIndex:)]) {
            
        for (int i=0; i < MIN(2, _unitCount); i++) {
            SSPageFlowUnit *unit = [_ssDataSource pageFlowView:self unitForColumnAtIndex:i];
            unit.ssDelegate = self;
            unit.frame = CGRectMake(_pageWidth * i, 0, _pageWidth, _scrollview.bounds.size.height);
            [_scrollview addSubview:unit];
            
            [_currentUnitAry  addObject:unit];
        }        
    }

    [self autoSlide];
}

- (void)reloadDataAtStartIndex:(NSInteger)index
{
    for (SSPageFlowUnit *unit in _currentUnitAry) {
        [unit unitClean];
        [unit removeFromSuperview];
    }
    [_currentUnitAry removeAllObjects];
    
    self.reuseableUnit = nil;
    _currentPage = index;
    _pageWidth = self.bounds.size.width;
    
    [self numberOfUnits];
    
    if (_ssDataSource != nil 
        && [_ssDataSource respondsToSelector:@selector(pageFlowView:unitForColumnAtIndex:)]) {
        
        int subviewsCount = (index == 0 || index == _unitCount - 1) ? MIN(2, _unitCount) : MIN(3, _unitCount);
        CGFloat subviewsOffsetX = index == 0 ? _pageWidth * index : _pageWidth * (index - 1);
        int startLoadIndex = index == 0 ? index : index - 1;
        
        for (int i=0; i < subviewsCount; i++) {
            SSPageFlowUnit *unit = [_ssDataSource pageFlowView:self unitForColumnAtIndex:startLoadIndex + i];
            unit.ssDelegate = self;
            unit.frame = CGRectMake(subviewsOffsetX, 0, _pageWidth, _scrollview.bounds.size.height);
            
            [_scrollview addSubview:unit];
            [_currentUnitAry  addObject:unit];
            
            subviewsOffsetX += _pageWidth;
        }
        
        [_scrollview scrollRectToVisible:CGRectMake(_pageWidth * index, 0, _pageWidth, _scrollview.bounds.size.height) animated:NO];
    }
}

- (SSPageFlowUnit *)dequeueReusableUnit
{
    return _reuseableUnit;
}


#pragma mark - SSPageFlowUnitDelegate
- (void)didAnyTapInSSPageFlowUnit:(SSPageFlowUnit *)pageFlowUnit
{
    if (_ssDelegate != nil
        && [_ssDelegate respondsToSelector:@selector(pageFlowView:didSelectColumnAtIndex:)]) {
        [_ssDelegate pageFlowView:self didSelectColumnAtIndex:pageFlowUnit.index];
    }
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self units];
    
    _pageControl.currentPage = _currentPage;
    
    if (_currentPage > _unitCount - _guardPageShortTo) {
        if (_ssDataSource != nil) {
            if ([_ssDataSource respondsToSelector:@selector(pageFlowViewArriveAtGuardPage:)]) {
                [_ssDataSource pageFlowViewArriveAtGuardPage:self];
            }
        }
    }
} 

#pragma mark - init

- (id)init
{
    self = [super init];
    if (self) {
        
        _scrollview = [[UIScrollView alloc] init];
        _scrollview.pagingEnabled = YES;
        _scrollview.delegate = self;
        _scrollview.showsVerticalScrollIndicator = NO;
        _scrollview.showsHorizontalScrollIndicator = NO;
        [self addSubview:_scrollview];
        
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.backgroundColor = [UIColor clearColor];
        [self addSubview:_pageControl];
        
        _currentUnitAry = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)dealloc
{
    self.scrollView = nil;
    self.pageControl = nil;
    self.reuseableUnit = nil;
    self.currentUnitAry = nil;
    
    [super dealloc];
}

@end
