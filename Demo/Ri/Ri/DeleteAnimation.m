//
//  DeleteAnimation.m
//  Ri
//
//  Created by haizi on 11-9-20.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "DeleteAnimation.h"


@implementation DeleteAnimation

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    width=102;
    height=77;
    isAnimationing=NO;
    
    
    _scrollView =[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    
//    _scrollView.delegate=self;
    _scrollView.showsVerticalScrollIndicator=NO;
    
    [self.view addSubview:_scrollView];
    
    int contentHeight;
    for (int i = 0; i < 30; i ++) {
        
        UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        imageView.image=[UIImage imageNamed:@"xiaocangyouzi.png"];
        
        UIView *view=[[UIView alloc] initWithFrame:CGRectMake((width+50)*(i%2)+20, (height+30)*(i/2), width, height)];
        [view addSubview:imageView];
        [imageView release];

        view.tag=i;
        [_scrollView addSubview:view];
        
        contentHeight=(height+30)*(i/2);
        
        UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
        longPressRecognizer.allowableMovement = 30;
        [view addGestureRecognizer:longPressRecognizer];        
        [longPressRecognizer release];  
        
        [view release];
    }
    _scrollView.contentSize=CGSizeMake(320, contentHeight+height*2);
  
    UIButton *button=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame=CGRectMake(0, 0, 50, 50);
    [button addTarget:self action:@selector(addRemoveButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [super viewDidLoad];
}


-(void)deleteView:(UIButton *)button
{
    
    
    CGPoint centerPoint=button.superview.center;
    CGPoint newCenter;
    float animationTime=0.0f;
    
    for (UIView *view in _scrollView.subviews) {
        if ([view isKindOfClass:[UIView class]]) {
            if (view.tag > button.tag) {
                animationTime+=0.03;
                
                newCenter=view.center;
                
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
                [UIView setAnimationDuration:animationTime+0.2];
                view.center=centerPoint;
                [UIView commitAnimations];
                
                centerPoint=newCenter;
            }
        }
    }
   
    [button.superview removeFromSuperview];
}


-(void)addRemoveButton
{
    isAnimationing=!isAnimationing;
    [self animationStop];
    
    for (UIView *view in _scrollView.subviews) {
        if (isAnimationing) {
            UIButton *button=[UIButton buttonWithType:UIButtonTypeRoundedRect];
            button.frame=CGRectMake(0, 0, 20, 20);
            button.tag=view.tag;
            [button setTitle:[NSString stringWithFormat:@"%d",button.tag] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(deleteView:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:button];            
        }else{
//            for (UIButton *button in view.subviews) {
//                [button removeFromSuperview];
//            }
            for (UIButton *button in view.subviews) {
                if ([button isKindOfClass:[UIButton class]]) {
                    [button removeFromSuperview];
                }
                
            }
//            for (UIView *view in view.subviews) {
//            if ([view isKindOfClass:[UIButton class]]) {
//                [view removeFromSuperview];
//            }
//            }
        }
    }
    
    
}


- (void)handleLongPress:(UILongPressGestureRecognizer*)longPressRecognizer {
	if (longPressRecognizer.state == UIGestureRecognizerStateBegan) {
        [self addRemoveButton];
	}
}


-(void)animationUpdate
{
    dir=dir>0?-0.05:0.05;
    CGAffineTransform wobbleLeft = CGAffineTransformMakeRotation(dir);
  
    for (UIView *imageView  in _scrollView.subviews) {
        if ([imageView isKindOfClass:[UIView class]]) {
            imageView.transform=wobbleLeft;
        }
    }
}

-(void)animationStop
{
    
    if (!isAnimationing) {
        
        [_updatetime invalidate];
       
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3f];
        for (UIView *tempView in [_scrollView subviews]) {
            tempView.transform = CGAffineTransformIdentity;
        }
        [UIView commitAnimations];
        
        
    }else{
        _updatetime=[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(animationUpdate) userInfo:nil repeats:YES];       
    }
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
