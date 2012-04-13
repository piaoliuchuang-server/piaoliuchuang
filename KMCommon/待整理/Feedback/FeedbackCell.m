//
//  FeedbackCell.m
//  Diting
//
//  Created by Jianfeng Tu on 11/7/11.
//  Copyright (c) 2011 Invidel. All rights reserved.
//

#import "FeedbackCell.h"

#define DEFAULT_X         10
#define DEFAULT_Y         5
#define CONTENT_WIDTH     200
#define CONTENT_FONT_SIZE 16
#define TIME_FONT_SIZE    12

@implementation FeedbackCell

@synthesize left = mLeft;
@synthesize feedbackTimeLabel = mFeedbackTimeLabel;
@synthesize feedbackContentLabel = mFeedbackContentLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        mBackgroundView = [[UIImageView alloc] initWithFrame:self.frame];
        mBackgroundView.contentStretch = CGRectMake(0.5, 0.5, 0, 0);
        [self addSubview:mBackgroundView];
        
        mFeedbackContentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        mFeedbackContentLabel.font = [UIFont systemFontOfSize:CONTENT_FONT_SIZE];
        mFeedbackContentLabel.backgroundColor = [UIColor clearColor];
        mFeedbackContentLabel.numberOfLines = 0;
        mFeedbackContentLabel.lineBreakMode = UILineBreakModeCharacterWrap;
        [mBackgroundView addSubview:mFeedbackContentLabel];
        
        mFeedbackTimeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        mFeedbackTimeLabel.font = [UIFont systemFontOfSize:TIME_FONT_SIZE];
        mFeedbackTimeLabel.textColor = [UIColor grayColor];
        mFeedbackTimeLabel.backgroundColor = [UIColor clearColor];
        [mBackgroundView addSubview:mFeedbackTimeLabel];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

+ (CGFloat)heightForContent:(NSString *)content
{
    static CGFloat singleLineHeight = 0;
    if (singleLineHeight == 0) {
        CGSize size = [@"0" sizeWithFont:[UIFont systemFontOfSize:CONTENT_FONT_SIZE]
                       constrainedToSize:CGSizeMake(CONTENT_WIDTH, 9999.f)
                           lineBreakMode:UILineBreakModeCharacterWrap];
        singleLineHeight = size.height;
    }
    
    CGSize size = [content sizeWithFont:[UIFont systemFontOfSize:CONTENT_FONT_SIZE] 
                                         constrainedToSize:CGSizeMake(CONTENT_WIDTH, 9999.f)
                                             lineBreakMode:UILineBreakModeCharacterWrap];
    return size.height + 37.f;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    static CGFloat singleLineHeight = 0;
    if (singleLineHeight == 0) {
        CGSize size = [@"0" sizeWithFont:[UIFont systemFontOfSize:CONTENT_FONT_SIZE]
                       constrainedToSize:CGSizeMake(CONTENT_WIDTH, 9999.f)
                           lineBreakMode:mFeedbackContentLabel.lineBreakMode];
        singleLineHeight = size.height;
    }
    
    CGSize size = [mFeedbackContentLabel.text sizeWithFont:[UIFont systemFontOfSize:CONTENT_FONT_SIZE] 
                                         constrainedToSize:CGSizeMake(CONTENT_WIDTH, 9999.f)
                                             lineBreakMode:mFeedbackContentLabel.lineBreakMode];
    if (singleLineHeight == size.height) {
        CGRect frame = mFeedbackContentLabel.frame;
        frame.origin.x = DEFAULT_X;
        frame.origin.y = DEFAULT_Y;
        frame.size.width = CONTENT_WIDTH;
        mFeedbackContentLabel.frame = frame;
        
        [mFeedbackContentLabel sizeToFit];
    }
    else {
        mFeedbackContentLabel.frame = CGRectMake(DEFAULT_X, DEFAULT_Y, CONTENT_WIDTH, size.height);
    }
    
    [mFeedbackTimeLabel sizeToFit];
    CGRect frame = mFeedbackTimeLabel.frame;
    frame.origin.x = DEFAULT_X;
    frame.origin.y = CGRectGetMaxY(mFeedbackContentLabel.frame) + 3.f;
    mFeedbackTimeLabel.frame = frame;
    
    CGFloat width = MAX(CGRectGetWidth(mFeedbackContentLabel.frame), CGRectGetWidth(mFeedbackTimeLabel.frame)) + 20;
    
    if (mLeft) {
        mBackgroundView.frame = CGRectMake(5, 5, width, CGRectGetMaxY(mFeedbackTimeLabel.frame) + 5);
        mBackgroundView.image = [UIImage imageNamed:@"feedbackbg1.png"];
    }
    else {
        mBackgroundView.frame = CGRectMake(310 - width, 5, width, CGRectGetMaxY(mFeedbackTimeLabel.frame) + 5);
        mBackgroundView.image = [UIImage imageNamed:@"feedbackbg.png"];
    }
}

- (void)dealloc
{
    [mBackgroundView release];
    [mFeedbackContentLabel release];
    [mFeedbackTimeLabel release];
    
    [super dealloc];
}

@end
