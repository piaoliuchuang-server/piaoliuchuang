//
//  ViewController.h
//  ShakeMobile
//
//  Created by he yk on 3/14/12.
//  Copyright (c) 2012 qh. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "ShakeObject.h"
#import <CoreLocation/CoreLocation.h>
#import "ShakeRequestSever.h"
#import "ShakeRecieveDataVO.h"


@interface ViewController : UIViewController<ShakeDelegate,ShakeRequestSeverDelegate>{
   
    
    IBOutlet UILabel *textLa;
    IBOutlet UILabel *Location;
    ShakeObject *shake;
    BOOL isAdmin;
    ShakeRequestSever *shakeRequest;


}


@end

