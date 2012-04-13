//
//  SegmentedControl.h
//  UIViewDemo
//
//  Created by Mengke WANG on 3/3/10.
//  Copyright 2010 Abvent R&D. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIViewDemoViewController.h"

@interface SegmentedControl : UISegmentedControl {
	IBOutlet UIView *view1;
	IBOutlet UIView *view2;
	IBOutlet UIView *view3;
	IBOutlet UIViewDemoViewController* viewController;
}

@end
