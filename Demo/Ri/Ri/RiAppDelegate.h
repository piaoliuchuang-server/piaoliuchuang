//
//  RiAppDelegate.h
//  Ri
//
//  Created by haizi on 11-9-20.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RiViewController;

@interface RiAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet RiViewController *viewController;

@end
