//
//  CustomFontTestViewController.m
//  CustomFontTest
//
//  Created by  mac on 11-8-31.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CustomFontTestViewController.h"

@implementation CustomFontTestViewController

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, 320, 40)];
	lb.text = @"哈哈，自定义字体 how about letters?";
	lb.font = [UIFont fontWithName:@"DFPShaoNvW5-GB" size:20.0f];
	[self.view addSubview:lb];
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

@end
