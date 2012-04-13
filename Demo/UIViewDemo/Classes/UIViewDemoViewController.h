//
//  UIViewDemoViewController.h
//  UIViewDemo
//
//  Created by WANG Mengke on 09-12-6.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface UIViewDemoViewController : UIViewController {
	IBOutlet UIView *view1;
	IBOutlet UIView *view2;
	IBOutlet UIView *view3;
	IBOutlet UISlider *slider;
	BOOL isHalfAnimation;
	CATransition *lastAnimation;
}

@property (nonatomic,retain) CATransition *lastAnimation;

- (IBAction)doUIViewAnimation:(id)sender;
- (IBAction)doPrivateCATransition:(id)sender;
- (IBAction)doPublicCATransition:(id)sender;
- (IBAction)switchViews:(id)sender;
@end