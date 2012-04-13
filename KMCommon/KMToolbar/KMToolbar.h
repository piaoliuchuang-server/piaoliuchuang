//
//  SSVerticalToolbar.h
//  BaseGallery
//
//  Created by Tianhang Yu on 11-12-11.
//  Copyright (c) 2011年 99fang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    TOOLBAR_ORDER_VERTICAL_NORMAL,
    TOOLBAR_ORDER_VERTICAL_UPSIDEDOWN,
    TOOLBAR_ORDER_HORIZONTAL_NORMAL,
    TOOLBAR_ORDER_HORIZONTAL_RIGHT_TO_LEFT
} TOOLBAR_ORDER_TYPE;

@interface KMToolbar : UIView

@property (nonatomic, retain) NSArray *items;
@property (nonatomic) TOOLBAR_ORDER_TYPE orderType;

@end
