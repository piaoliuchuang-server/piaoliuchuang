//
//  LazyImageView.h
//  BaseGallery
//
//  Created by Tianhang Yu on 11-12-3.
//  Copyright (c) 2011年 99fang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ASIHTTPRequest.h"

@protocol LazyImageViewDelegate;


@interface LazyImageView : UIImageView {
    
    ASIHTTPRequest *_request;     //could be canceled
    NSString *_imageURL;    //unused!
}

@property (nonatomic, assign) id<LazyImageViewDelegate> delegate;
@property (nonatomic, retain) UIView *defaultView;

- (void)setImageURL:(NSString *)imageURL;
- (void)setImageURL:(NSString *)imageURL withDefaultView:(UIView *)defaultView;
- (void)imageRequestCancel;
- (void)removeDefaultView;

@end


@protocol LazyImageViewDelegate <NSObject>

@optional
- (void)lazyImageView:(LazyImageView *)lazyImageView didLoadImage:(UIImage *)image;
- (void)lazyImageView:(LazyImageView *)lazyImageView didFailLoadWithError:(NSError *)error;

@end