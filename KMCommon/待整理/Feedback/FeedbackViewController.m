//
//  FeedbackViewController.m
//  Diting
//
//  Created by Jianfeng Tu on 10/28/11.
//  Copyright (c) 2011 Invidel. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>


#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

#import "TitleImageView.h"
#import "BaseUtillities.h"
#import "FeedbackViewController.h"
#import "LoadCommentOperation.h"
#import "CJSONDeserializer.h"
#import "FeedbackCell.h"
#import "FeedbackConstants.h"
#import "UIColorAdditions.h"
#import "Constans.h"

#define STR_MESSAGE @"message"
#define STR_DATA    @"data"
#define STR_SUCCESS @"success"

#define KEY_FOR_CHECK_AFTER_DICT    @"key_for_check_after_dict"

#define TAG_FOR_VISIT_URL   100083
#define TAG_FOR_CALL        100084


BOOL checkAfterSeconds(NSString * key, NSTimeInterval skip) 
{
    if (key && [key respondsToSelector:@selector(length)] 
        && [key length] == 0) 
        return NO;
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary * dict = [defaults dictionaryForKey:KEY_FOR_CHECK_AFTER_DICT];
    NSTimeInterval last = [[dict objectForKey:key] doubleValue];
    if (last + skip <= [[NSDate date] timeIntervalSince1970]) {
        last = [[NSDate date] timeIntervalSince1970];
        
        NSMutableDictionary * mutableDict = [[NSMutableDictionary alloc] initWithDictionary:dict];
        [mutableDict setValue:[NSNumber numberWithDouble:last] forKey:key];
        [defaults setValue:mutableDict forKey:KEY_FOR_CHECK_AFTER_DICT];
        [defaults synchronize];
        [mutableDict release];
        return YES;
    }
    
    return NO;
}

void clearCheck(NSString * key)
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] initWithDictionary:[defaults objectForKey:KEY_FOR_CHECK_AFTER_DICT]];
    [dict removeObjectForKey:key];
    [defaults setValue:dict forKey:KEY_FOR_CHECK_AFTER_DICT];
    [defaults synchronize];
    [dict release];
}

@implementation FeedbackViewController

@synthesize appKey = mAppKey;

#pragma mark - default


+ (NSString *)getMacAddress
{
    int                 mgmtInfoBase[6];
    char                *msgBuffer = NULL;
    size_t              length;
    unsigned char       macAddress[6];
    struct if_msghdr    *interfaceMsgStruct;
    struct sockaddr_dl  *socketStruct;
    NSString            *errorFlag = NULL;
    
    // Setup the management Information Base (mib)
    mgmtInfoBase[0] = CTL_NET;        // Request network subsystem
    mgmtInfoBase[1] = AF_ROUTE;       // Routing table info
    mgmtInfoBase[2] = 0;              
    mgmtInfoBase[3] = AF_LINK;        // Request link layer information
    mgmtInfoBase[4] = NET_RT_IFLIST;  // Request all configured interfaces
    
    // With all configured interfaces requested, get handle index
    if ((mgmtInfoBase[5] = if_nametoindex("en0")) == 0) 
        errorFlag = @"if_nametoindex failure";
    else
    {
        // Get the size of the data available (store in len)
        if (sysctl(mgmtInfoBase, 6, NULL, &length, NULL, 0) < 0) 
            errorFlag = @"sysctl mgmtInfoBase failure";
        else
        {
            // Alloc memory based on above call
            if ((msgBuffer = malloc(length)) == NULL)
                errorFlag = @"buffer allocation failure";
            else
            {
                // Get system information, store in buffer
                if (sysctl(mgmtInfoBase, 6, msgBuffer, &length, NULL, 0) < 0)
                    errorFlag = @"sysctl msgBuffer failure";
            }
        }
    }
    
    // Befor going any further...
    if (errorFlag != NULL)
    {
        NSLog(@"Error: %@", errorFlag);
        return errorFlag;
    }
    
    // Map msgbuffer to interface message structure
    interfaceMsgStruct = (struct if_msghdr *) msgBuffer;
    
    // Map to link-level socket structure
    socketStruct = (struct sockaddr_dl *) (interfaceMsgStruct + 1);
    
    // Read from char array into a string object, into traditional Mac address format
    NSString *macAddressString = @"00:00:00:00:00:00";
    
    if (socketStruct != nil) {
        memcpy(&macAddress, socketStruct->sdl_data + socketStruct->sdl_nlen, 6);
        macAddressString = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X", 
                                      macAddress[0], macAddress[1], macAddress[2], 
                                      macAddress[3], macAddress[4], macAddress[5]];
        NSLog(@"Mac Address: %@", macAddressString);
    }
    
    // Release the buffer memory
    free(msgBuffer);
    
    return macAddressString;
}


+ (NSString *)getUniqueIdentifier
{
    UIDevice * device = [UIDevice currentDevice];
    if ([device respondsToSelector:@selector(uniqueIdentifier)]) {
        return [device uniqueIdentifier];
    }
    
    return [FeedbackViewController getMacAddress];
}

+ (NSString *)simpleTimeStr:(NSDate *)date
{
    double timeStamp = [date timeIntervalSince1970];
    double nowStamp = [[NSDate date] timeIntervalSince1970];
    double value = nowStamp - timeStamp;
    if (value >=0 && value <= 60.f) {
        return [NSString stringWithFormat:@"%d %@", (int)value, NSLocalizedString(@"秒前", @"")];
    }
    else if (value > 60.f && value <= 60 * 60.f) {
        return [NSString stringWithFormat:@"%d %@", (int)(value / 60.f), NSLocalizedString(@"分钟前", @"")];
    }
    else if (value <=0) {
        return [NSString stringWithFormat:@"0 %@", NSLocalizedString(@"秒前", @"")];
    }
    
    static NSCalendar * calendar = nil;
    if (calendar == nil) {
        calendar = [[NSCalendar alloc]
                    initWithCalendarIdentifier:NSChineseCalendar];
    }
    
    static NSDateFormatter * formatter = nil;
    if (formatter == nil) {
        formatter = [[NSDateFormatter alloc] init];
    }
    
    NSString * formatString = @"MM-dd HH:mm";
    if (floor(nowStamp / (24 * 60 * 60)) == floor(timeStamp / (24 * 60 * 60))) {
        formatString = [NSString stringWithFormat:@"'%@' HH:mm", NSLocalizedString(@"今天", @"")];
    }
    else if (floor(nowStamp / (24 * 60 * 60)) - 1 == floor(timeStamp / (24 * 60 * 60))) {
        formatString = [NSString stringWithFormat:@"'%@' HH:mm", NSLocalizedString(@"昨天", @"")];
    }
    [formatter setDateFormat:formatString];
    
    return [formatter stringFromDate:date];
}


- (BOOL)isUrl:(NSString *)str 
{
    if ([str length] > 0 && ([str hasPrefix:@"http://"] || [str hasPrefix:@"https://"])) {
        return YES;
    }
    
    return NO;
}

- (BOOL)isNumber:(NSString *)str
{
    for (int i=0; i < [str length]; i++) {
        unichar c = [str characterAtIndex:i];
        if (c > '9' || c < '0') return NO;
    }
    
    return YES;
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)scrollToBottom
{
    [mTableView scrollRectToVisible:CGRectMake(0., mTableView.contentSize.height - 10, mTableView.contentSize.width, 10)
                           animated:YES];
}

+ (void)startLoadComments:(NSString *)appKey
{
    NSOperationQueue * queue = [[NSOperationQueue alloc] init];
    LoadCommentOperation * operation = [[LoadCommentOperation alloc] initWithAppKey:appKey];
    [queue addOperation:operation];
    [operation release];
    [queue release];
}

+ (BOOL)checkItems:(NSArray *)items update:(BOOL)needUpdate
{    
    double maxTime = [[NSUserDefaults standardUserDefaults] doubleForKey:KEY_MAX_FEEDBACK_TIME];
    double nowTime = 0;
    for (NSDictionary * item in items) {
        double getTime = [[item objectForKey:@"pub_date"] doubleValue];
        if (nowTime < getTime) {
            nowTime = getTime;
        }
    }

    if (maxTime == 0 || (nowTime > 0 && needUpdate)) {

        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        [defaults setDouble:nowTime forKey:KEY_MAX_FEEDBACK_TIME];
        [defaults synchronize];
    }
    
    if (maxTime > 0 && nowTime > maxTime) {
        return YES;
    }
    
    return NO;
}

- (void)resultRecived:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KEY_FEEDBACK_RESULT object:nil];
    
    NSDictionary * root = notification.object;
    
    if ([STR_SUCCESS isEqualToString:[root objectForKey:STR_MESSAGE]]) {
        NSArray * data = [root objectForKey:STR_DATA];
        
        if ([data count] > 0) {
            [mItems release];
            mItems = [data retain];
            [FeedbackViewController checkItems:mItems update:YES];
            
            [mInfoLabel performSelectorOnMainThread:@selector(setText:) withObject:@"" waitUntilDone:NO];
            [mTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
            [self performSelectorOnMainThread:@selector(scrollToBottom) withObject:nil waitUntilDone:NO];
        }
        else {
            [mInfoLabel performSelectorOnMainThread:@selector(setText:)
                                         withObject:NSLocalizedString(@"暂无反馈", @"") 
                                      waitUntilDone:NO];
        }
    }
    else {
        [mInfoLabel performSelectorOnMainThread:@selector(setText:) 
                                     withObject:NSLocalizedString(@"暂无反馈", @"")
                                  waitUntilDone:NO];
    }
}

- (void)refresh
{
    mInfoLabel.text = NSLocalizedString(@"加载中...", @"");

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(resultRecived:) 
                                                 name:KEY_FEEDBACK_RESULT
                                               object:nil];
    [FeedbackViewController startLoadComments:mAppKey];
}

- (void)send
{
    if ([mInputField.text length] > 0) {
        NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@post_message/", APP_PREFIX]]];
        [request setHTTPMethod:@"POST"];
        
        NSString * requestString = [NSString stringWithFormat:@"content=%@&appkey=%@&uuid=%@&os_version=%@&device=%@&app_version=%@", mInputField.text, mAppKey, [FeedbackViewController getUniqueIdentifier], [[UIDevice currentDevice] model], [[UIDevice currentDevice] systemVersion], [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"]];
        NSLog(@"requestString: %@", requestString);
        NSData * requestData = [requestString dataUsingEncoding:NSUTF8StringEncoding 
                                           allowLossyConversion:YES];
        [request setHTTPBody:requestData];
        
        NSData * data = [NSURLConnection sendSynchronousRequest:request returningResponse: nil error: nil];
        [request release];
        
        CJSONDeserializer * jsonparser = [[CJSONDeserializer alloc] init];
        NSError * error = nil;
        NSDictionary * root = [jsonparser deserialize:data error:&error];
        [jsonparser release];
        
        if ([STR_SUCCESS isEqualToString:[root objectForKey:STR_MESSAGE]]) {
            [mInputField performSelectorOnMainThread:@selector(setText:) withObject:@"" waitUntilDone:NO];
            [self performSelectorOnMainThread:@selector(refresh) withObject:nil waitUntilDone:NO];
         }
     }
}
             
 - (void)saveAction:(id)sender
{
    NSOperationQueue * queue = [[NSOperationQueue alloc] init];
    
    NSInvocationOperation * operation = [[NSInvocationOperation alloc] initWithTarget:self 
                                                                             selector:@selector(send) 
                                                                               object:nil];
    [queue addOperation:operation];
    [operation release];
    [queue release];
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.contentSizeForViewInPopover = CGSizeMake(320.f, 480.f);
    }
    return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - UITableView

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary * item = [mItems objectAtIndex:indexPath.row];
    NSString * content = [[item objectForKey:@"content"] lowercaseString];
    if ([self isUrl:content]) {
        UIActionSheet * sheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"确定访问?", @"") 
                                                            delegate:self
                                                   cancelButtonTitle:NSLocalizedString(@"取消", @"") 
                                              destructiveButtonTitle:nil 
                                                   otherButtonTitles:content, nil];
        sheet.tag = TAG_FOR_VISIT_URL;
        [sheet showInView:self.view];
        [sheet release];
    }
    else if ([self isNumber:content]) {
        UIActionSheet * sheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"确定拨打?", @"") 
                                                            delegate:self
                                                   cancelButtonTitle:NSLocalizedString(@"取消", @"") 
                                              destructiveButtonTitle:nil 
                                                   otherButtonTitles:content, nil];
        sheet.tag = TAG_FOR_CALL;
        [sheet showInView:self.view];
        [sheet release];        
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * item = [mItems objectAtIndex:indexPath.row];
    
    return [FeedbackCell heightForContent:[item objectForKey:@"content"]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [mItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * indentifier = @"SimpleCell";
    
    FeedbackCell * cell = (FeedbackCell *)[tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell == nil) {
        cell = [[[FeedbackCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:indentifier] autorelease];
    }
    
    NSDictionary * item = [mItems objectAtIndex:indexPath.row];
    cell.feedbackContentLabel.text =  [item objectForKey:@"content"];
        
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:[[item objectForKey:@"pub_date"] intValue]];
    cell.feedbackTimeLabel.text = [FeedbackViewController simpleTimeStr:date];
    
    NSNumber * type = [item objectForKey:@"type"];
    cell.left = ([type intValue] > 0);
    
    [cell setNeedsLayout];
    
    return cell;
}
         
#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != actionSheet.cancelButtonIndex) {
        NSString * title = [actionSheet buttonTitleAtIndex:buttonIndex];
        if (TAG_FOR_VISIT_URL == actionSheet.tag && [self isUrl:title]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:title]];
        }
        else if (TAG_FOR_CALL == actionSheet.tag && [self isNumber:title]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", title]]];            
        }
    }
}

#pragma mark - UITextFieldDelegate

- (void)hideInputToolBar:(id)sender
{
    [mInputField resignFirstResponder];
}

- (void)showEndInputButton
{
    if (mHideButton == nil) {
        mHideButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        [mHideButton addTarget:self action:@selector(hideInputToolBar:) forControlEvents:UIControlEventTouchUpInside];
        mHideButton.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    }
    
    mHideButton.frame = CGRectMake(0.f, 0.f, mTableView.frame.size.width, mTableView.frame.size.height);
    if ([mHideButton superview] != self.view) {
        [mHideButton removeFromSuperview];
        mHideButton.alpha = 0;
        [self.view addSubview:mHideButton];
        [self.view sendSubviewToBack:mHideButton];
        [self.view sendSubviewToBack:mTableView];
    }
    
    [UIView beginAnimations:nil context:nil];
    mHideButton.alpha = 1;
    [UIView commitAnimations];
}

- (void)hideEndInputButton
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:mHideButton];
    [UIView setAnimationDidStopSelector:@selector(removeFromSuperview)];
    mHideButton.alpha = 0;
    [UIView commitAnimations];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self showEndInputButton];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        
        [UIView beginAnimations:nil context:nil];
        CGRect frame = mToolbar.frame;
        frame.origin.y -= 216.f;
        mToolbar.frame = frame;
        [UIView commitAnimations];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self hideEndInputButton];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        
        [UIView beginAnimations:nil context:nil];
        CGRect frame = mToolbar.frame;
        
        frame.origin.y += 216.f;
        mToolbar.frame = frame;
        [UIView commitAnimations];
    }
}

- (void)keyBoardChange:(NSNotification *)aNotification
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        
        NSDictionary * info = [aNotification userInfo];
        CGPoint keyBoardOrigin = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].origin;
        CGPoint keyBoardStart = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].origin;
        
        [UIView beginAnimations:nil context:nil];
        
        CGRect frame = mToolbar.frame;
        frame.origin.y = keyBoardOrigin.y - frame.size.height - 20.f;
        mToolbar.frame = frame;
        
        [UIView commitAnimations];
        
        if (keyBoardStart.y + mToolbar.frame.size.height < keyBoardOrigin.y) {
            [self hideEndInputButton];
        }
        else {
            [self showEndInputButton];
        }
    }
}

#pragma mark - View lifecycle

#define KEY_LAST_CONTENT @"keyLastFeedbackContent__"

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    mInputField.text = [defaults objectForKey:KEY_LAST_CONTENT];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:mInputField.text forKey:KEY_LAST_CONTENT];
    [defaults synchronize];
}

- (NSString *)allocDictKey:(NSString *) dictKey andObjectKey:(NSString *)objectkey
{
    NSString * finalPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"ConstantsPlist.plist"];
    if (finalPath == nil) return  nil;
    NSDictionary * allDictionary = [[NSDictionary dictionaryWithContentsOfFile:finalPath] retain];
    if (allDictionary == nil) return nil;
    NSDictionary * s = [allDictionary objectForKey:dictKey];
    [allDictionary release];
    if (s == nil) return nil;
    NSString * color = [[s objectForKey:objectkey] retain];
    return color;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController setNavigationBarHidden:YES];
    
    if (titleImageView == nil) {
        titleImageView = [[TitleImageView alloc] initWithImage:[UIImage imageNamed:@"titlebar_bg.png"]];
        titleImageView.userInteractionEnabled = YES;
        [self.view addSubview:titleImageView];
        
        [titleImageView setButtonStyle:BUTTON_TYPE_BACK withButton:titleImageView.leftButton];
        titleImageView.titleLabel.textColor = (TITLE_TEXT_COLOR != nil) ? [UIColor colorWithHexString:TITLE_TEXT_COLOR] : [UIColor whiteColor];        
        [titleImageView.leftButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        titleImageView.leftButton.hidden = NO;
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            //do nothing
        } 
        else {
            [titleImageView.titleLabel setText:@"用户反馈"];    
        }
        
        if ([BACK_BUTTON_TITLE_STR length] > 0) {
            [titleImageView.leftButton setTitle:BACK_BUTTON_TITLE_STR forState:UIControlStateNormal];
            [titleImageView.leftButton setTitleColor:BACK_BUTTON_TITLE_COLOR forState:UIControlStateNormal];
        }
//        [titleImageView showBottomShadow];
    }
        
    if (mTableView == nil) {
        
        CGRect frame = CGRectZero;
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            frame.size.width = self.contentSizeForViewInPopover.width;
            frame.size.height = self.contentSizeForViewInPopover.height + 45.f;
        } else {
            frame = self.view.frame;
        }
        
        frame.origin.y = titleImageView.frame.size.height;
        frame.size.height -= titleImageView.frame.size.height;
        
        mTableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        mTableView.contentInset = UIEdgeInsetsMake(5, 0, 0, 0);
        mTableView.delegate = self;
        mTableView.dataSource = self;
        mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        mTableView.backgroundColor = [UIColor colorWithRed:238.f / 255.f green:238.f / 255.f blue:238.f / 255.f alpha:1];
        
        mInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, 320, 40)];
        mInfoLabel.textColor = [UIColor darkGrayColor];
        mInfoLabel.backgroundColor = [UIColor clearColor];
        mInfoLabel.textAlignment = UITextAlignmentCenter;
        [mTableView addSubview:mInfoLabel];
        
        [self.view addSubview:mTableView];
    }
        
    if (mToolbar == nil) {
        mToolbar = [[UIToolbar alloc] initWithFrame:CGRectZero];
        mToolbar.barStyle = UIBarStyleDefault;
        mToolbar.tintColor = [UIColor colorWithHexString:@"#F3F3F3"];
        [mToolbar sizeToFit];
        
        CGRect frame = mTableView.frame;
        frame.size.height -= mToolbar.frame.size.height;
        mTableView.frame = frame;
        
        frame = mToolbar.frame;
        frame.origin.y = CGRectGetMaxY(mTableView.frame);
        mToolbar.frame = frame;
        
        [mInputField release];
        mInputField = [[UITextField alloc] initWithFrame:CGRectMake(5.f, 5.f, 300.f, 30.f)];
        mInputField.backgroundColor = [UIColor clearColor];
        mInputField.borderStyle = UITextBorderStyleRoundedRect;
        mInputField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        mInputField.placeholder = NSLocalizedString(@"请在这里输入", @"");
        mInputField.returnKeyType = UIReturnKeySend;
        mInputField.delegate = self;
        mInputField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [mInputField addTarget:self
                        action:@selector(saveAction:) 
              forControlEvents:UIControlEventEditingDidEndOnExit];
        
        UIBarButtonItem * inputItem = [[UIBarButtonItem alloc] initWithCustomView:mInputField];
        [mToolbar setItems:[NSArray arrayWithObjects:inputItem, nil]];
        [inputItem release];
        
        [self.view addSubview:mToolbar];
    }
    
    
    //the sheadow
    CGColorRef darkColor = [[UIColor blackColor] colorWithAlphaComponent:0.3f].CGColor;
    CGColorRef lightColor = [UIColor clearColor].CGColor;  
    CAGradientLayer * newShadow = [[CAGradientLayer alloc] init];
    newShadow.frame = CGRectMake(0, titleImageView.frame.size.height, self.navigationController.navigationBar.frame.size.width, 4);
    newShadow.colors = [NSArray arrayWithObjects:(id)darkColor, (id)lightColor, nil];
    [self.view.layer addSublayer:newShadow];
    [newShadow release];

        
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyBoardChange:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyBoardChange:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
    
    [self refresh];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [mTableView removeFromSuperview];
    [mTableView release];
    mTableView = nil;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [mTableView release];
    [mInfoLabel release];
    [mToolbar release];
    [mInputField release];
    [mHideButton release];
    [mItems release];
    
    [super dealloc];
}


@end
