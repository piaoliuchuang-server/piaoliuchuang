//
//  FontTestAppDelegate.h
//  FontTest
//
//  Created by  Anning on 10-5-2.
//  Copyright Umbrella Inc 2010. All rights reserved.
//

@interface FontTestAppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
    UINavigationController *navigationController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@end

