//
//  CustomFontTestAppDelegate.h
//  CustomFontTest
//
//  Created by  mac on 11-8-31.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CustomFontTestViewController;

@interface CustomFontTestAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    CustomFontTestViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet CustomFontTestViewController *viewController;

@end

