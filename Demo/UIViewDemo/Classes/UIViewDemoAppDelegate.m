//
//  UIViewDemoAppDelegate.m
//  UIViewDemo
//
//  Created by WANG Mengke on 09-12-6.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "UIViewDemoAppDelegate.h"
#import "UIViewDemoViewController.h"

@implementation UIViewDemoAppDelegate

@synthesize window;
@synthesize viewController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    
    // Override point for customization after app launch    
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
