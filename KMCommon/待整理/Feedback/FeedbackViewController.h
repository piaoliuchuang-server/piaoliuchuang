//
//  FeedbackViewController.h
//  Diting
//
//  Created by Jianfeng Tu on 10/28/11.
//  Copyright (c) 2011 Invidel. All rights reserved.
//

#import <UIKit/UIKit.h>

#define KEY_MAX_FEEDBACK_TIME @"key_max_feedback_time"

#define STR_SUCCESS   @"success"
#define STR_MESSAGE   @"message"
#define STR_DATA      @"data"

@class TitleImageView;

// check after seconds
BOOL checkAfterSeconds(NSString * key, NSTimeInterval skip);
void clearCheck(NSString * key);

@interface FeedbackViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIActionSheetDelegate> {
    UITableView * mTableView;
    UILabel * mInfoLabel;
    UIButton * mHideButton;
    UIToolbar * mToolbar;
    UITextField * mInputField;
    NSString * mAppKey;
    TitleImageView * titleImageView;
    NSArray * mItems;
}

@property (nonatomic, retain) NSString * appKey;

+ (BOOL)checkItems:(NSArray *)items update:(BOOL)needUpdate;
+ (void)startLoadComments:(NSString *)appKey;
+ (NSString *)getUniqueIdentifier;

@end
