//
//  DeleteAnimation.h
//  Ri
//
//  Created by haizi on 11-9-20.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DeleteAnimation : UIViewController {
    int width;
    int height;
    
    float dir;
    
//    BOOL isPlaying;
    
    NSTimer *_updatetime;
    
    BOOL isAnimationing;
    
    UIScrollView *_scrollView;
}


-(void)addRemoveButton;

-(void)deleteView:(UIButton *)button;

-(void)animationUpdate;
-(void)animationStop;

@end
