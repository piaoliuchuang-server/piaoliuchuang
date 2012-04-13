//
//  FeedbackCell.h
//  Diting
//
//  Created by Jianfeng Tu on 11/7/11.
//  Copyright (c) 2011 Invidel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedbackCell : UITableViewCell {
    UILabel * mFeedbackContentLabel;
    UILabel * mFeedbackTimeLabel;
    
    UIImageView * mBackgroundView;
    
    BOOL mLeft;
}

@property (nonatomic, assign) BOOL left;
@property (nonatomic, retain) UILabel * feedbackContentLabel;
@property (nonatomic, retain) UILabel * feedbackTimeLabel;

+ (CGFloat)heightForContent:(NSString *)content;

@end
