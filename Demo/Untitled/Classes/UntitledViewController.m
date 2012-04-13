//
//  UntitledViewController.m
//  Untitled
//
//  Created by Think on 11-3-22.
//  Copyright 2011 @Shanghai. All rights reserved.
//

#import "UntitledViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation UntitledViewController



/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	UIGraphicsBeginImageContext(icon.bounds.size);
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	const CGFloat components[4] = {0.0,0.4,0.0,1.0};
	CGContextSetFillColor(ctx, components);
	CGContextFillRect(ctx, CGRectMake(0, 0, icon.bounds.size.width, icon.bounds.size.height));
	UIImage *background = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	UIImage *image = [UIImage imageNamed:@"icon.png"];
	UIImage *mask = [UIImage imageNamed:@"IconBase.png"];
	UIImage *roundCorner = [UIImage imageNamed:@"round-corner.png"];
	icon.image = image;
	
	CALayer* subLayer = [[CALayer layer] retain];
	subLayer.frame = icon.bounds;
	subLayer.contents = (id)[background CGImage];

	CALayer* maskLayer = [[CALayer layer] retain];
	maskLayer.frame = icon.bounds;
	maskLayer.contents = (id)[mask CGImage]; 
	[subLayer setMask:maskLayer];
	[[icon layer] addSublayer:subLayer];
	
	CALayer* roundCornerLayer = [[CALayer layer] retain];
	roundCornerLayer.frame = icon.bounds;
	roundCornerLayer.contents = (id)[roundCorner CGImage];
	[[icon layer] setMask:roundCornerLayer];
	
	[maskLayer release];
	[subLayer release];
	[roundCornerLayer release];
	
	//
//	imgLayer=[[CALayer layer] retain];
//	
//	imgLayer.bounds=CGRectMake(0, 0, 140, 120);
//	
//	imgLayer.position=CGPointMake(mainLayer.bounds.size.width/2,mainLayer.bounds.size.width/2);
//	NSImage *img=[[NSImage imageNamed:@"cover2"] retain];
//	
//	imgLayer.contents=(id)[self nsImageToCGImageRef:img];
//	
//	[mainLayer addSublayer:imgLayer];
//	
//	
//	reflectionLayer=[[CALayer layer]retain];
//	
//	reflectionLayer.contents=imgLayer.contents;
//	
//	reflectionLayer.opacity = 0.5;
//	
//	reflectionLayer.frame=CGRectOffset(imgLayer.frame, 0.5,
//									   
//									   -(imgLayer.bounds.size.height) + 0.5);
//	
//	reflectionLayer.transform = CATransform3DMakeScale(1.0, -1.0, 1.0); 
//	
//	reflectionLayer.sublayerTransform = reflectionLayer.transform;
//	
//	[mainLayer addSublayer:reflectionLayer];
//	
//	
//	shadowLayer = [[CALayer layer] retain];
//	
//	NSImage *shadowMask=[[NSImage imageNamed:@"shadowmask"] retain];
//	
//	shadowLayer.contents=(id)[self nsImageToCGImageRef:shadowMask];
//	
//	shadowLayer.frame=reflectionLayer.bounds;
//	
//	reflectionLayer.mask=shadowLayer;
}



/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

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
