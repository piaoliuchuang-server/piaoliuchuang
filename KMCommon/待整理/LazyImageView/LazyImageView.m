//
//  LazyImageView.m
//  BaseGallery
//
//  Created by Tianhang Yu on 11-12-3.
//  Copyright (c) 2011年 99fang. All rights reserved.
//

#import "LazyImageView.h"
#import "SimpleCache.h"

@implementation LazyImageView
@synthesize delegate=_delegate;
@synthesize defaultView=_defaultView;

#pragma mark - private
- (void)loadImageFromNetwork:(NSString *)imageURL
{
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];

//    _request = [[SSURLRequest requestWithURL:imageURL delegate:self] retain];
//    _request.response = [[[SSDataResponse alloc] init] autorelease];
//    [_request send];
    
    NSURL *url = [NSURL URLWithString:imageURL];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setDelegate:self];
    [request startAsynchronous];
    
    [pool drain];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
//    [self loadImageFromNetwork:_imageURL];
}


#pragma mark - public
- (void)imageRequestCancel
{
    if (_request != nil) {
        [_request cancel]; 
        
        [_defaultView removeFromSuperview];
        self.defaultView = nil;
    }
}

- (void)removeDefaultView
{
    [_defaultView removeFromSuperview];
    self.defaultView = nil;    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [_defaultView sizeToFit];
    _defaultView.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
}

- (void)setImageURL:(NSString *)imageURL
{
    NSData * imageData = [[SimpleCache sharedCache] dataForKey:imageURL];    
    _imageURL = imageURL;
    
    if (imageData != nil) {
        if (_delegate != nil) {
            if ([_delegate respondsToSelector:@selector(lazyImageView:didLoadImage:)]) {
                NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
                [_delegate lazyImageView:self didLoadImage:[UIImage imageWithData:imageData]];
                [pool drain];
            }
        }
    } else {
        [self loadImageFromNetwork:imageURL];            
    }
}

- (void)setImageURL:(NSString *)imageURL withDefaultView:(UIView *)defaultView
{
    NSData * imageData = [[SimpleCache sharedCache] dataForKey:imageURL];
    _imageURL = imageURL;
    
    if (imageData != nil) {
        if (_delegate != nil) {
            if ([_delegate respondsToSelector:@selector(lazyImageView:didLoadImage:)]) {
                NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
                [_delegate lazyImageView:self didLoadImage:[UIImage imageWithData:imageData]];
                [pool drain];
            }
        }
    } else {
        //add default view
        [_defaultView removeFromSuperview];
        self.defaultView = defaultView;
        [self addSubview:_defaultView];
        
        [self loadImageFromNetwork:imageURL];          
    }
}


- (void)requestFinished:(ASIHTTPRequest *)request
{
    
    // Use when fetching binary data
    NSData *responseData = [request responseData];
    
    if (responseData != nil) {
        [[SimpleCache sharedCache] setData:responseData forKey:request.url.absoluteString];
        
        if (_delegate != nil) {
            if ([_delegate respondsToSelector:@selector(lazyImageView:didLoadImage:)]) {
                NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
                
//                NSLog(@"image:%@, reuqest:%@", _imageURL, request.urlPath);
                
                if ([_imageURL isEqualToString:request.url.absoluteString]) {
                    [_delegate lazyImageView:self didLoadImage:[UIImage imageWithData:responseData]];    
                }
                
                //remove default view
                [_defaultView removeFromSuperview];
                [pool drain];
            }
        }
    }

}


- (void)requestFailed:(ASIHTTPRequest *)request
{
    if (_delegate != nil) {
        if ([_delegate respondsToSelector:@selector(lazyImageView:didFailLoadWithError:)]) {
            [_delegate lazyImageView:self didFailLoadWithError:nil];
        }
    }
}

#pragma mark - SSURLRequestDelegate
//- (void)requestDidFinishLoad:(SSURLRequest *)request
//{
//    SSDataResponse *response = request.response;
//    
//    if (response.data != nil) {
//        [[SimpleCache sharedCache] setData:response.data forKey:request.urlPath];
//        
//        if (_delegate != nil) {
//            if ([_delegate respondsToSelector:@selector(lazyImageView:didLoadImage:)]) {
//                NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
//                
////                NSLog(@"image:%@, reuqest:%@", _imageURL, request.urlPath);
//                
//                if ([_imageURL isEqualToString:request.urlPath]) {
//                    [_delegate lazyImageView:self didLoadImage:[UIImage imageWithData:response.data]];    
//                }
//                
//                //remove default view
//                [_defaultView removeFromSuperview];
//                [pool drain];
//            }
//        }
//    }
//}

//- (void)request:(SSURLRequest *)request didFailLoadWithError:(NSError *)error
//{
//    if (_delegate != nil) {
//        if ([_delegate respondsToSelector:@selector(lazyImageView:didFailLoadWithError:)]) {
//            [_delegate lazyImageView:self didFailLoadWithError:error];
//        }
//    }
//}


#pragma mark - init
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor]; 
    }
    return self;
}

- (void)dealloc
{
    self.defaultView = nil;
    [_request release];
    
    [super dealloc];
}


@end
