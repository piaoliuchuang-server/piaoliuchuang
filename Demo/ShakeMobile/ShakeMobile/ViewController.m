//
//  ViewController.m
//  ShakeMobile
//
//  Created by he yk on 3/14/12.
//  Copyright (c) 2012 qh. All rights reserved.
//

#import "ViewController.h"
#import "ShakeXMLCreateor.h"
#import "ShakeXMLParser.h"
#import "CurrentLocationSV.h"

@interface ViewController ()

@end

@implementation ViewController


- (void)geShakeDataFinished:(ShakeRequestSever*)shakeRequest recieveData:(NSData*)shakeRecieveData{
    ShakeRecieveDataVO *revieveData ;
    
    if (isAdmin) {
        revieveData = [ShakeXMLParser parseAdminShakeResult:shakeRecieveData];
        if (revieveData.addOK) {
            UIAlertView *alerts = [[UIAlertView alloc]
                                   initWithTitle:@"提示"
                                   message:@""
                                   delegate:nil
                                   cancelButtonTitle:@"OK"
                                   otherButtonTitles:nil];
            [alerts show];
            [alerts release];
        }

    }
    else {
           revieveData = [ShakeXMLParser parseMemberShakeResult:shakeRecieveData];
        if (revieveData.addOK&&revieveData.familyName!=nil&&![revieveData.familyName isEqualToString:@""]) {
            UIAlertView *alerts = [[UIAlertView alloc]
                                   initWithTitle:@"添加成功"
                                   message:[NSString stringWithFormat:@"familyName:%@",revieveData.familyName]
                                   delegate:nil
                                   cancelButtonTitle:@"OK"
                                   otherButtonTitles:nil];
            [alerts show];
            [alerts release];
        }
        else {
            
            UIAlertView *alerts = [[UIAlertView alloc]
                                   initWithTitle:@"提示"
                                   message:@"添加失败"
                                   delegate:nil
                                   cancelButtonTitle:@"OK"
                                   otherButtonTitles:nil];
            [alerts show];
            [alerts release];
        } 
    }
    

    
}

//向服务器发送xml数据
-(void)sendXMLData:(NSString*)XMLData{
    if (!shakeRequest.bIsRequest) {
        [shakeRequest release];
        shakeRequest = [[ShakeRequestSever alloc]init];
        shakeRequest.delegate = self;
        [shakeRequest SendData:XMLData];
    }

//    [shakeRequest release];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
     shake = [[ShakeObject alloc]init];
    shake.delegate = self;
    [CurrentLocationSV sharedCurrentLocationSV];
    
  
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation ==UIInterfaceOrientationPortrait);
}




-(void)dealloc{
    [super dealloc];
    [shake release];
    [shakeRequest release];
}


-(void)shakeCallback{
    CurrentLocationSV *currentLocation = [CurrentLocationSV sharedCurrentLocationSV];
    
    CLLocationCoordinate2D CurrentCoordinate =currentLocation.CurrentCoordinate;
    
    NSString *deviceName=[[UIDevice currentDevice] name];
    
    textLa.alpha = 0.0; 
    textLa.text = deviceName;

    Location.text = [NSString stringWithFormat:@"latitude=%f,longitude=%f",CurrentCoordinate.latitude,CurrentCoordinate.longitude];
    
   
	[UIView beginAnimations:@"testAnimation" context:NULL];
	[UIView setAnimationDuration:2.0f];  
	[UIView setAnimationCurve:UIViewAnimationCurveLinear]; 	
	[UIView setAnimationDelegate:self];  
	[UIView setAnimationRepeatAutoreverses:NO];	 

    textLa.alpha = 1.0; 

    [UIView commitAnimations];
    
    NSString *xml=nil;
    long int latitudes = CurrentCoordinate.latitude*1000000;
    long int longitudes = CurrentCoordinate.longitude*1000000;
    
    if ([deviceName isEqualToString:@"iobit iPod"]) {
        isAdmin = YES;
        xml = [ShakeXMLCreateor adminShakeXMLCreate:deviceName
                                       adminLatitue:[NSString stringWithFormat:@"%d",latitudes]
                                     adminLongitude:[NSString stringWithFormat:@"%d",longitudes]];
    }
    else {
        isAdmin =NO;
        xml = [ShakeXMLCreateor memberShakeXMLCreateLatitue:[NSString stringWithFormat:@"%d",latitudes]
                                            memberLongitude:[NSString stringWithFormat:@"%d",longitudes]];
    }
    [self sendXMLData:xml];
    

}

@end
