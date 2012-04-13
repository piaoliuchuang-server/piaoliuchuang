//
//  PageCircleView.m
//  NewHouse
//
//  Created by kimimaro on 11-8-31.
//  Copyright 2011年 99fang.com. All rights reserved.
//

#import "PageCircleView.h"
#import "Constants.h"

@implementation PageCircleView

@synthesize pageNumberLabel=mPageNumberLabel;

- (id)initWithFrame:(CGRect)aFrame andColor:(UIColor *)aColor andText:(NSString *)aString
{

    self = [super initWithFrame:aFrame];

	self.backgroundColor = [UIColor clearColor];
    if (self) {
		currentFrame = aFrame;
		currentColor = aColor;
        currentString = [aString copy];
    }
    return self;
}

-(void)changeColor:(UIColor *)aColor
{
	currentColor = aColor;
	[self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
	CGRect newRect = CGRectMake(rect.origin.x+1 , rect.origin.y+1, rect.size.width-2 , rect.size.height-2);

	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetLineWidth(context, 2.0);
	CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
	CGContextSetFillColorWithColor(context, currentColor.CGColor);
	CGContextAddEllipseInRect(context, newRect);
	CGContextDrawPath(context, kCGPathFillStroke);

    mPageNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(4, 0, 8, 8)];
    mPageNumberLabel.backgroundColor = [UIColor clearColor];
    mPageNumberLabel.text = currentString;
    mPageNumberLabel.textColor = [UIColor whiteColor];
    mPageNumberLabel.font = FONT_DEFAULT(12);
    [mPageNumberLabel sizeToFit];
    [self addSubview:mPageNumberLabel];
}

- (void)dealloc {
    [mPageNumberLabel release];
    [currentString release];

    [super dealloc];
}

@end
