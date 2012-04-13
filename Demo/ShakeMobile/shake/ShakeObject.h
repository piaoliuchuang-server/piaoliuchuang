//////////////////////////////////////////////////////////////////////////  
///     COPYRIGHT NOTICE  
///     Copyright (c) 2012 qh  
///     All rights reserved.  
///  
/// @file            ShakeObject.h 
/// @brief           Shaking event capture  
///  
/// @described      Monitor a shaking event by UIAccelerometer delegate.and when judged this event is shaking,call a 
///                 interface which named shakeCallback with current date ,latitude and longitude.you can get current 
///                 date ,latitude and longitude from the interface when your moblie is shaking.
///
/// @author         Created by heyk  
/// @date           on 3/14/12
///   
///  
//////////////////////////////////////////////////////////////////////////

#import <UIKit/UIKit.h>


#define kAccelerometerFrequency 60 

@protocol ShakeDelegate<NSObject>
-(void)shakeCallback;
@end

@interface ShakeObject : NSObject<UIAccelerometerDelegate>{
    
     id<ShakeDelegate>delegate;
}
@property(nonatomic,assign)id<ShakeDelegate>delegate;
@end
