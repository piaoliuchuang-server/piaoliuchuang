//
//  CustomAlertViewDemoAppDelegate.m
//  CustomAlertViewDemo
//
//  Created by apple appale on 11-10-12.
//  Copyright 2011 sfdsfdsfsdfsdfs. All rights reserved.
//

#import "CustomAlertViewDemoAppDelegate.h"

@implementation CustomAlertViewDemoAppDelegate

@synthesize window;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after application launch.
    
    [self.window makeKeyAndVisible];
    return YES;
}
-(IBAction)alert{
	CustomAlertView *alert=[[CustomAlertView alloc]initWithTitle:@"警告" 
														 Message:@"这是一个自定义的警告\n\n哈哈哈哈12321kfasfhierfhiakvbadfvdfsvnmkaskldfqlweoropjq4rjiopqjifijerfeqrfqfeqr" 
													Cancelbutton:@"我知道了" 
													 OtherButton:@"好的"
														Delegate:self
													   SuperView:self.window];
//	[alert setAlertBackgroundImage:@"bg"];
	[alert setBackgroundColor:[UIColor orangeColor]];
	[alert alertShow];
	[alert release];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
    [window release];
    [super dealloc];
}

#pragma mark -
#pragma mark CustomAlertViewDelegate
-(void)CustomalertView:(id)customalertview buttonclickedAtindex:(NSInteger)index{
	if (index==0) {
		showTextLabel.text=@"我知道了";
	}else {
		showTextLabel.text=@"好的";
	}

}

@end
