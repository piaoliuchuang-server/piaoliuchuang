//
//  THScreenCaptureViewTestAppDelegate.h
//  THScreenCaptureViewTest
//
//  Created by wayne li on 11-9-8.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"

@interface THScreenCaptureViewTestAppDelegate : NSObject <UIApplicationDelegate>
{
    MainViewController *mvc;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end
