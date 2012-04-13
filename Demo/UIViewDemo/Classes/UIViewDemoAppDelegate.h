//
//  UIViewDemoAppDelegate.h
//  UIViewDemo
//
//  Created by WANG Mengke on 09-12-6.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UIViewDemoViewController;

@interface UIViewDemoAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    UIViewDemoViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UIViewDemoViewController *viewController;

@end

