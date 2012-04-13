//
//  CustomAlertViewDemoAppDelegate.h
//  CustomAlertViewDemo
//
//  Created by apple appale on 11-10-12.
//  Copyright 2011 sfdsfdsfsdfsdfs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomAlertView.h"

@interface CustomAlertViewDemoAppDelegate : NSObject <UIApplicationDelegate,CustomAlertViewDelegate> {
    UIWindow *window;
	IBOutlet UILabel *showTextLabel;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
-(IBAction)alert;
@end

