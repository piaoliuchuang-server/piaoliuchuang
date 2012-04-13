//
//  ExtendView.m
//  Rent
//
//  Created by YuTianhang on 11-11-8.
//  Copyright (c) 2011年 Invidel. All rights reserved.
//

#import "ExtendView.h"
#import "UIColorAdditions.h"
#import "Constants.h"

@implementation ExtendView

@synthesize delegate;
@synthesize extended=mExtended;
@synthesize minHeight=mMinHeight;
@synthesize title=mTitle;
@synthesize content=mContent;

#pragma mark - private

- (void)extendBtnClicked:(id)sender
{
    mExtended = !mExtended;
    
    if (delegate != nil) {    
        if ([delegate respondsToSelector:@selector(extendView:didClickedExtendBtn:)]) {
            [delegate extendView:self didClickedExtendBtn:sender];
        }
    }
}

- (void)communityDetailStyle
{
    mBgImageView.hidden = YES;
    mPartingLine.hidden = YES;
    [mExtendBtn setImage:nil forState:UIControlStateNormal];
    [mExtendBtn setEnabled:NO]; 
    [mExtendBtn.titleLabel setFont:FONT_DEFAULT(18.f)];
}

- (void)heightToFit:(UILabel *)aLabel
{
    CGFloat textHeight = 0;
    NSString * tempContent = [aLabel.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([tempContent length] > 0) {
        CGSize size = [tempContent sizeWithFont:aLabel.font
                              constrainedToSize:CGSizeMake(aLabel.frame.size.width, 9999.f)
                                  lineBreakMode:UILineBreakModeCharacterWrap];
        textHeight = size.height;
    }
    aLabel.numberOfLines = 0.f;
    CGRect frame = aLabel.frame;
    frame.size.height = textHeight;           
    aLabel.frame = frame;
}

#pragma mark - public

- (void)updateUI
{
    CGRect frame = self.frame;
    CGFloat contentMargin = 10.f;
    
    if (mExtended) {
        [mExtendBtn setTitle:mTitle forState:UIControlStateNormal];
        [mExtendBtn setImage:[UIImage imageNamed:@"MinusIcon.png"] forState:UIControlStateNormal];
        [mExtendBtn setFrame:CGRectMake(0, 0, frame.size.width, 41)];
        [mExtendBtn setImageEdgeInsets:UIEdgeInsetsMake(15, frame.size.width - 35, 15, 0)];
        [mPartingLine setFrame:CGRectMake(mExtendBtn.frame.origin.x, mExtendBtn.frame.origin.y + mExtendBtn.frame.size.height, frame.size.width, 1)];

        mContentLabel.text = mContent;
        [mContentLabel setFrame:CGRectMake(mPartingLine.frame.origin.x + contentMargin, mPartingLine.frame.origin.y + mPartingLine.frame.size.height + contentMargin, frame.size.width - contentMargin * 2, [mMinHeight floatValue] - contentMargin * 2)];
        
        CGSize size = [mContentLabel.text sizeWithFont:mContentLabel.font
                                     constrainedToSize:CGSizeMake(mContentLabel.frame.size.width, 9999.f)
                                         lineBreakMode:UILineBreakModeCharacterWrap];
        if (size.height <= [mMinHeight floatValue]) {
            [mExtendBtn setEnabled:NO];
            mExtendBtn.imageView.hidden = YES;
        } else {
            [self heightToFit:mContentLabel];    
        }
    } else {
        [mExtendBtn setTitle:mTitle forState:UIControlStateNormal];
        [mExtendBtn setImage:[UIImage imageNamed:@"PlusIcon.png"] forState:UIControlStateNormal];
        [mExtendBtn setFrame:CGRectMake(0, 0, frame.size.width, 41)];
        [mExtendBtn setImageEdgeInsets:UIEdgeInsetsMake(15, frame.size.width - 35, 15, 0)];
        [mPartingLine setFrame:CGRectMake(mExtendBtn.frame.origin.x, mExtendBtn.frame.origin.y + mExtendBtn.frame.size.height, frame.size.width, 1)];

        mContentLabel.text = mContent;
        [mContentLabel setFrame:CGRectMake(mPartingLine.frame.origin.x + contentMargin, mPartingLine.frame.origin.y + mPartingLine.frame.size.height + contentMargin, frame.size.width - contentMargin * 2, [mMinHeight floatValue] - contentMargin * 2)];
        
        CGSize size = [mContentLabel.text sizeWithFont:mContentLabel.font
                              constrainedToSize:CGSizeMake(mContentLabel.frame.size.width, 9999.f)
                                  lineBreakMode:UILineBreakModeCharacterWrap];
        if (size.height <= [mMinHeight floatValue]) {
            [mExtendBtn setEnabled:NO];
            mExtendBtn.imageView.hidden = YES;
        }
    }
    
    frame.size.height = mExtendBtn.frame.size.height + mPartingLine.frame.size.height + mContentLabel.frame.size.height + contentMargin * 2;
    self.frame = frame;    
    frame.origin.x = 0;
    frame.origin.y = 0; 
    mBgImageView.frame = frame;

    if (delegate != nil)
    {
        if ([delegate respondsToSelector:@selector(communityDetailStyle:)])
        {
            [delegate communityDetailStyle:self];
        }
    }
}

#pragma mark - init&memory

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        mBgImageView = [[UIImageView alloc] initWithFrame:frame];
        UIImage * bgImage = [UIImage imageNamed:@"moreBack.png"];
        bgImage = [bgImage stretchableImageWithLeftCapWidth:floorf(bgImage.size.width / 2) topCapHeight:floorf(bgImage.size.height /2)];
        [mBgImageView setImage:bgImage];
        [self addSubview:mBgImageView];
        
        mExtendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        mExtendBtn.frame = CGRectMake(0, 0, 50, 50);
        [mExtendBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [mExtendBtn.titleLabel setFont:FONT_DEFAULT(15.f)];
        [mExtendBtn setTitleEdgeInsets:UIEdgeInsetsMake(5, -230, 5, 0)];
        [mExtendBtn addTarget:self action:@selector(extendBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:mExtendBtn];
        
        mPartingLine = [[UIImageView alloc] initWithFrame:frame];
        [mPartingLine setBackgroundColor:[UIColor colorWithHexString:@"#cccccc"]];
        [self addSubview:mPartingLine];
        
        mContentLabel = [[UILabel alloc] initWithFrame:frame];
        [mContentLabel setBackgroundColor:[UIColor clearColor]]; 
        mContentLabel.numberOfLines = 0;
        mContentLabel.font = [mContentLabel.font fontWithSize:15.0f];
        [mContentLabel setLineBreakMode:UILineBreakModeTailTruncation];
        [self addSubview:mContentLabel];
    }
    return self;
}

- (void)dealloc
{
    [mPartingLine release];
    [mContentLabel release];
    [super dealloc];
}

@end
