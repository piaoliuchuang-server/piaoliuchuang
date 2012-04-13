//
//  KMEnrollView.h
//  Drawus
//
//  Created by Tianhang Yu on 12-4-4.
//  Copyright (c) 2012年 99fang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KMEnrollViewDelegate;

@interface KMEnrollView : UIView

@property (nonatomic, assign) id<KMEnrollViewDelegate> kmDelegate;

@property (nonatomic) int minNum;
@property (nonatomic) int maxNum;

// follow methods may have chance to change self's frame, havn't find a better way to go yet!
- (id)initWithFrame:(CGRect)frame title:(NSString *)title placeholder:(NSString *)placeholder rule:(NSString *)rule;

@end

@protocol KMEnrollViewDelegate <NSObject>

- (void)enrollView:(KMEnrollView *)enrollView textFieldDidEndEditing:(UITextField *)textField;

@end
