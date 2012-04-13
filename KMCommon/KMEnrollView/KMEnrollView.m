//
//  KMEnrollView.m
//  Drawus
//
//  Created by Tianhang Yu on 12-4-4.
//  Copyright (c) 2012年 99fang. All rights reserved.
//

#import "KMEnrollView.h"

#define PADDING 10.f
#define INPUT_VIEW_WIDTH 200.f
#define INPUT_VIEW_HEIGHT 32.f

@interface KMEnrollView () <UITextFieldDelegate>

@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UITextField *inputField;
@property (nonatomic, retain) UILabel *ruleLabel;

@end

@implementation KMEnrollView

@synthesize kmDelegate =_kmDelegate;
@synthesize minNum     =_minNum;
@synthesize maxNum     =_maxNum;

@synthesize titleLabel =_titleLabel;
@synthesize inputField =_inputField;
@synthesize ruleLabel  =_ruleLabel;

- (id)initWithFrame:(CGRect)frame title:(NSString *)title placeholder:(NSString *)placeholder rule:(NSString *)rule
{
    self = [super initWithFrame:frame];
    if (self) {
        
		self.titleLabel = [[[UILabel alloc] init] autorelease];
		_titleLabel.text = title;
        _titleLabel.textColor = [UIColor whiteColor];
		_titleLabel.font = FONT_CHINESE(15.f);
		_titleLabel.backgroundColor = [UIColor clearColor];
    	
    	[_titleLabel sizeToFit];
		CGRect tFrame     = _titleLabel.frame;
		tFrame.origin.x   = PADDING;
		tFrame.origin.y   = PADDING;
		_titleLabel.frame = tFrame;

    	[self addSubview:_titleLabel];
    	
		CGRect iFrame      = _titleLabel.frame;
		iFrame.origin.x    = (self.frame.size.width - INPUT_VIEW_WIDTH) / 2;
		iFrame.origin.y    = CGRectGetMaxY(_titleLabel.frame) + PADDING;
		iFrame.size.width  = INPUT_VIEW_WIDTH;
		iFrame.size.height = INPUT_VIEW_HEIGHT;
    	
    	self.inputField = [[UITextField alloc] initWithFrame:iFrame];
    	_inputField.delegate = self;
    	_inputField.borderStyle = UITextBorderStyleRoundedRect;
    	_inputField.backgroundColor = [UIColor colorWithRed:238 / 255. green:238 / 255. blue:238 / 255. alpha:1];
    	_inputField.font = FONT_DEFAULT(20.f);
    	_inputField.placeholder = placeholder;
    	_inputField.returnKeyType = UIReturnKeyDone;

    	[self addSubview:_inputField];
    	
		self.ruleLabel = [[[UILabel alloc] init] autorelease];
		_ruleLabel.text = rule;
		_ruleLabel.font = FONT_DEFAULT(13.f);
		_ruleLabel.textColor = [UIColor lightGrayColor];
		_ruleLabel.backgroundColor = [UIColor clearColor];

		[_ruleLabel sizeToFit];
		CGRect rFrame    = _ruleLabel.frame;
		rFrame.origin.x  = _inputField.frame.origin.x;
		rFrame.origin.y  = _inputField.frame.origin.y + _inputField.frame.size.height + PADDING;
		_ruleLabel.frame = rFrame;

    	[self addSubview:_ruleLabel];
        
        CGRect vFrame = self.frame;
        vFrame.size.height = vFrame.size.height < CGRectGetMaxY(_ruleLabel.frame) ? CGRectGetMaxY(_ruleLabel.frame) : vFrame.size.height;
        self.frame = vFrame;
    }
    return self;
}

- (void)dealloc
{
	self.titleLabel = nil;
	self.inputField = nil;
	self.ruleLabel = nil;

	[super dealloc];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField
{
	if (_kmDelegate != nil)
	{
		if ([_kmDelegate respondsToSelector:@selector(enrollView:textFieldDidEndEditing:)])
		{
			[_kmDelegate enrollView:self textFieldDidEndEditing:textField];
		}
	}
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (range.location > _maxNum) 
    {
        return NO;
    }
    else 
    {
        return YES;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	if ([textField.text length] < _minNum)
	{
		return NO;
	}
	else 
	{
		[textField resignFirstResponder];
		
		return YES;	
	}
}

@end
