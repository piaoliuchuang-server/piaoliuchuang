//
//  FontTestAppDelegate.m
//  FontTest
//
//  Created by  Anning on 10-5-2.
//  Copyright Umbrella Inc 2010. All rights reserved.
//

#import "FontTestAppDelegate.h"
#import "RootViewController.h"


@implementation FontTestAppDelegate

@synthesize window;
@synthesize navigationController;


#pragma mark -
#pragma mark Application lifecycle

- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    
    // Override point for customization after app launch    
	
	[window addSubview:[navigationController view]];
    [window makeKeyAndVisible];
}


- (void)applicationWillTerminate:(UIApplication *)application {
	// Save data if appropriate
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[navigationController release];
	[window release];
	[super dealloc];
}


@end

