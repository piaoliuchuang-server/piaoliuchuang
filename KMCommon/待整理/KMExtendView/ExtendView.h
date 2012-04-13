//
//  ExtendView.h
//  Rent
//
//  Created by YuTianhang on 11-11-8.
//  Copyright (c) 2011年 Invidel. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ExtendView;

@protocol ExtendViewDelegate <NSObject>

@required

- (void)extendView:(ExtendView *)extendView didClickedExtendBtn:(id)sender;

@optional

- (BOOL)defaultExpended;
- (void)communityDetailStyle:(ExtendView *)extendView;

@end

@interface ExtendView : UIView {
    UIButton * mExtendBtn;
    UILabel * mTitleLabel;
    UILabel * mContentLabel;
    UIImageView * mBgImageView;
    UIImageView * mPartingLine;
}

@property (nonatomic, assign) id<ExtendViewDelegate> delegate;
@property (nonatomic, assign) BOOL extended;
@property (nonatomic, retain) NSNumber * minHeight;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * content;

- (void)updateUI;
- (void)communityDetailStyle;

@end
