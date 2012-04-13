//
//  MainViewController.h
//  THScreenCaptureViewTest
//
//  Created by wayne li on 11-9-8.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THCapture.h"

@interface MainViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,THCaptureDelegate>{
    THCapture *capture;
    UITableView *aTableView;
}

@end
