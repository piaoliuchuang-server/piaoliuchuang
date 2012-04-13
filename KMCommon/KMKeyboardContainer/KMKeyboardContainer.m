//
//  KMKeyboardContainer.m
//  Drawus
//
//  Created by Tianhang Yu on 12-4-4.
//  Copyright (c) 2012年 99fang. All rights reserved.
//

#import "KMKeyboardContainer.h"

@interface KMKeyboardContainer () {

    BOOL isKeyboardShow;
    CGFloat upHeightForKeyboard;
}

@end

@implementation KMKeyboardContainer

#pragma mark - KeyboardNotificationAction

- (void)moveSubviewsDependKeyboard:(BOOL)show keyboardHeight:(CGFloat)keyboardHeight
{
    [UIView animateWithDuration:0.3 animations:^{
        
        for (UIView *v in self.subviews) {

            CGRect frame = v.frame;
            
            if (isKeyboardShow) {
                frame.origin.y -= upHeightForKeyboard;
            }
            else {
                frame.origin.y += upHeightForKeyboard;
            }
            
            v.frame = frame;
        }
    }];
}

- (void)keyboardWasShown:(NSNotification *)notification
{
    if (isKeyboardShow == YES) {
        return;
    }
    
    isKeyboardShow = YES;
    
    NSDictionary *info = [notification userInfo];

    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyboardRect = [value CGRectValue];
    keyboardRect = [self convertRect:keyboardRect fromView:nil];
    
    CGFloat keyboardHeight = keyboardRect.size.height;
    
    for (UIView *v in self.subviews) 
    {    
        CGFloat maxY = CGRectGetMaxY(v.frame);
        
        upHeightForKeyboard = (self.bounds.size.height - maxY) > (keyboardHeight + 10) ? 
                                0 : 
                                (keyboardHeight + 10) - (self.bounds.size.height - maxY);
    }
    
    [self moveSubviewsDependKeyboard:YES keyboardHeight:keyboardHeight];
}

- (void)keyboardWasHidden:(NSNotification *)notification
{
    if (isKeyboardShow == NO) {
        return;
    }
    
    isKeyboardShow = NO;
    
    [self moveSubviewsDependKeyboard:NO keyboardHeight:upHeightForKeyboard];
}

#pragma mark - default

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    	[[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(keyboardWasShown:)
                                                     name:UIKeyboardDidShowNotification 
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWasHidden:)
                                                     name:UIKeyboardDidHideNotification 
                                                   object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
    
    [super dealloc];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
