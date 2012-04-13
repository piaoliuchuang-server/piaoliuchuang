//
//  CustomAlertView.h
//  CustomAlertViewDemo
//
//  Created by apple appale on 11-10-12.
//  Copyright 2011 sfdsfdsfsdfsdfs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


@protocol CustomAlertViewDelegate

-(void)CustomalertView:(id)customalertview buttonclickedAtindex:(NSInteger)index;

@end


@interface CustomAlertView : UIView {
	UIImageView *backgroundView;
	id<CustomAlertViewDelegate>m_delegate;
	UIView *mysuperView;
	UIView *alertShowView;
}
@property(assign,nonatomic)UIImageView *backgroundView;
- (id)initWithTitle:(NSString*)title Message:(NSString*)message Cancelbutton:(NSString*)cancelname OtherButton:(NSString*)otherbutton Delegate:(id)delegate SuperView:(UIView*)superView;
-(void)setAlertBackgroundImage:(NSString *)imagename;
-(void)alertShow;
@end
