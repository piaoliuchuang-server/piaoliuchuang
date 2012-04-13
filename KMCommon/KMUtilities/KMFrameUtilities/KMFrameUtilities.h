//
//  KMFrameUtilities.h
//  Drawus
//
//  Created by Tianhang Yu on 12-4-3.
//  Copyright (c) 2012年 99fang. All rights reserved.
//

#ifndef Drawus_KMFrameUtilities_h
#define Drawus_KMFrameUtilities_h

static inline CGRect rectWithPadding (CGRect rect, CGFloat padding) {    
    
    return CGRectMake(rect.origin.x + padding,
                      rect.origin.y + padding,
                      rect.size.width - 2*padding,
                      rect.size.height - 2*padding);
}

static inline CGRect rectWithSizePadding (CGRect rect, CGFloat padding_top, CGFloat padding_left) {
    
    return CGRectMake(rect.origin.x + padding_left, 
                      rect.origin.y + padding_top, 
                      rect.size.width - 2*padding_left, 
                      rect.size.height - 2*padding_top);
}

#endif
