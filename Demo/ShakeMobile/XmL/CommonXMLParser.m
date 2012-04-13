//
//  LoginRegisterParser.m
//  MobleSecurity
//
//  Created by andylee1988 on 11-8-12.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CommonXMLParser.h"
#import "GDataXMLNode.h"
//#import "LocationVO.h"
//#import "EventVO.h"
//#import "MessageVO.h"
//#import "CircleVO.h"
//#import "NSData+Base64.h"
@implementation CommonXMLParser


#pragma mark
#pragma mark 注册流程: (http://mobile.evonsoft.com/mobile/register)

//<?xml version="1.0" encoding="utf-8"?>
//<registerresult>
//<result>ok</result>
//<logintoken>49|0|2365</logintoken>
//</registerresult>
/*
+ (RegisterResultVO*)parseRegisterResult:(NSData*)aData {
    RegisterResultVO *registerVO = [[[RegisterResultVO alloc] init] autorelease];
    GDataXMLDocument *document = [[[GDataXMLDocument alloc] initWithData:aData options:0 error:nil] autorelease];
	GDataXMLElement *rootNode = [document rootElement];
    NSArray *nodesArray = [rootNode nodesForXPath:@"//registerresult/result" error:nil];
    for (GDataXMLNode *node in nodesArray) {
        registerVO.strResult = [node stringValue];
        break;
    }
    if (![registerVO.strResult isEqualToString:kStrOk]) {
        return registerVO;
    }
    NSArray *loginTokenNodesArray = [rootNode nodesForXPath:@"//registerresult/logintoken" error:nil];
    for (GDataXMLNode *node in loginTokenNodesArray) {
        registerVO.strLoginToken = [node stringValue];
        break;
    }
    
    NSArray *array = [rootNode nodesForXPath:@"//registerresult/token" error:nil];
    for (GDataXMLNode *node in array) {
        registerVO.strToken = [node stringValue];
        break;
    }
    
    return registerVO;
}

#pragma mark
#pragma mark 登录流程: (http://mobile.evonsoft.com/mobile/login)

//<?xml version="1.0" encoding="utf-8"?>
//<loginresult>
//<result>ok</result>
//<logintoken>48|0|8943</logintoken>
//</loginresult>

+ (LoginResultVO*)parseLoginResult:(NSData*)aData {
    LoginResultVO *loginVO = [[[LoginResultVO alloc] init] autorelease];
    GDataXMLDocument *document = [[[GDataXMLDocument alloc] initWithData:aData options:0 error:nil] autorelease];
	GDataXMLElement *rootNode = [document rootElement];
    NSArray *nodesArray = [rootNode nodesForXPath:@"//loginresult/result" error:nil];
    
    for (GDataXMLNode *node in nodesArray) {
        loginVO.strResult = [node stringValue];
        break;
    }
    
    if (![loginVO.strResult isEqualToString:kStrOk]) {
        return loginVO;
    }
    NSArray *loginTokenNodesArray = [rootNode nodesForXPath:@"//loginresult/logintoken" error:nil];
    for (GDataXMLNode *node in loginTokenNodesArray) {
        loginVO.strLoginToken = [node stringValue];
        break;
    }
    
    return loginVO;
}

//<?xml version="1.0" encoding="utf-8"?>
//
//<memberlistresult>
//<result>ok</result>
//
//<member>
//<memberid>78</memberid>
//<membertype>web</membertype>
//<firstname></firstname>
//<lastname></lastname>
//<pituremodifytime></pituremodifytime>
//</member>
//
//<member>
//<memberid>79</memberid>
//<membertype>self</membertype>
//<firstname></firstname>
//<lastname></lastname>
//<pituremodifytime></pituremodifytime>
//</member>
//
//</memberlistresult>
+ (MemberListResultVO*)parseLoginMemberListResult:(NSData*)aData {
    MemberListResultVO *memberListVO = [[[MemberListResultVO alloc] init] autorelease];
    GDataXMLDocument *document = [[[GDataXMLDocument alloc] initWithData:aData options:0 error:nil] autorelease];
    GDataXMLElement *rootNode = [document rootElement];
    NSArray *nodesArray = [rootNode nodesForXPath:@"//loginlistmemberresult/result" error:nil];
    for (GDataXMLNode *node in nodesArray) {
        memberListVO.strResult = [node stringValue];
        break;
    }
    
    
    if (![memberListVO.strResult isEqualToString:kStrOk]) {
        return memberListVO;
    }
    
    NSMutableArray *tempMutableArray = [[NSMutableArray alloc] init]; 
    memberListVO.memberMutableArray = tempMutableArray;
    [tempMutableArray release];
    
    NSArray *memberNodesArray = [rootNode nodesForXPath:@"//loginlistmemberresult/member" error:nil];
    for (int i = 0; i < [memberNodesArray count]; i++) {
        MemberVO *memberVO = [[MemberVO alloc] init];
        GDataXMLElement *element = [memberNodesArray objectAtIndex:i];
        
        NSArray *memberIdNodesArray = [element nodesForXPath:@"./memberid" error:nil];
        for (GDataXMLNode *node in memberIdNodesArray) {
            memberVO.strMemberId = [node stringValue];
            break;
        }
        
        NSArray *memberTypeNodesArray = [element nodesForXPath:@"./membertype" error:nil];
        for (GDataXMLNode *node in memberTypeNodesArray) {
            memberVO.strMemberType = [node stringValue];
            break;
        }
        
        NSArray *firstNameNodesArray = [element nodesForXPath:@"./firstname" error:nil];
        
        for (GDataXMLNode *node in firstNameNodesArray) {
            memberVO.strFirstName = [node stringValue];
            break;
        }
        
        NSArray *lastNameNodesArray = [element nodesForXPath:@"./lastname" error:nil];
        for (GDataXMLNode *node in lastNameNodesArray) {
            memberVO.strLastName = [node stringValue];
            break;
        }
        
        NSArray *array5 = [element nodesForXPath:@"./islogin" error:nil];
        for (GDataXMLNode *node in array5) {
            memberVO.strIsLogin = [node stringValue];
            break;
        }
        
        NSArray *pinNodesArray = [element nodesForXPath:@"./pin" error:nil];
        for (GDataXMLNode *node in pinNodesArray) {
            memberVO.strPin = [node stringValue];
            break;
        }
        
        if ([memberVO.strMemberType isEqualToString:@"web"]) {
            [AppVO sharedAppVO].strWebMemberId = memberVO.strMemberId;
            [[NSUserDefaults standardUserDefaults] setObject:memberVO.strMemberId forKey:kStrWebMemberId];
            [[NSUserDefaults standardUserDefaults] synchronize];
        } else {
            [memberListVO.memberMutableArray addObject:memberVO];
        }

        [memberVO release];
    }
    return memberListVO;
}

//<?xml version="1.0" encoding="utf-8"?>
//<addmemberresult>
//<result>ok</result>
//<memberid>84</memberid>
//</addmemberresult>

+ (AddMemberResultVO*)parseLoginAddMemberResult:(NSData*)aData {
    AddMemberResultVO *addMemberResultVO = [[[AddMemberResultVO alloc] init] autorelease];
    GDataXMLDocument *document = [[[GDataXMLDocument alloc] initWithData:aData options:0 error:nil] autorelease];
    GDataXMLElement *rootNode = [document rootElement];
    NSArray *nodesArray = [rootNode nodesForXPath:@"//loginaddmemberresult/result" error:nil];
    for (GDataXMLNode *node in nodesArray) {
        addMemberResultVO.strResult = [node stringValue];
        break;
    }
    
    
    if (![addMemberResultVO.strResult isEqualToString:kStrOk]) {
        return addMemberResultVO;
    }
    
    NSArray *memberIdNodesArray = [rootNode nodesForXPath:@"//loginaddmemberresult/memberid" error:nil];
    for (GDataXMLNode *node in memberIdNodesArray) {
        addMemberResultVO.strMemberId = [node stringValue];
        break;
    }
    
    NSArray *pinNodesArray = [rootNode nodesForXPath:@"//loginaddmemberresult/pin" error:nil];
    for (GDataXMLNode *node in pinNodesArray) {
        addMemberResultVO.strPin = [node stringValue];
        break;
    }
    
    return addMemberResultVO;
}

//<?xml version="1.0" encoding="utf-8"?>
//<membertokenresult>
//<result>ok</result>
//<token>52|112|4759</token>
//</membertokenresult>

+ (MemberTokenResultVO*)parseMemberTokenResult:(NSData*)aData {
    MemberTokenResultVO *memberTokenResultVO = [[[MemberTokenResultVO alloc] init] autorelease];
    
    GDataXMLDocument *document = [[[GDataXMLDocument alloc] initWithData:aData options:0 error:nil] autorelease];
    GDataXMLElement *rootNode = [document rootElement];
    NSArray *nodesArray = [rootNode nodesForXPath:@"//bindmemberresult/result" error:nil];
    
    for (GDataXMLNode *node in nodesArray) {
        memberTokenResultVO.strResult = [node stringValue];
        break;
    }

    if (![memberTokenResultVO.strResult isEqualToString:kStrOk]) {
        return memberTokenResultVO;
    }
    
    NSArray *memberTokenNodesArray = [rootNode nodesForXPath:@"//bindmemberresult/token" error:nil];
    
    for (GDataXMLNode *node in memberTokenNodesArray) {
        memberTokenResultVO.strToken = [node stringValue];
        break;
    }
    return memberTokenResultVO;
}

+ (MemberTokenResultVO*)parseMemberTokenByPinResult:(NSData*)aData {
    MemberTokenResultVO *memberTokenResultVO = [[[MemberTokenResultVO alloc] init] autorelease];
    
    GDataXMLDocument *document = [[[GDataXMLDocument alloc] initWithData:aData options:0 error:nil] autorelease];
    GDataXMLElement *rootNode = [document rootElement];
    NSArray *nodesArray = [rootNode nodesForXPath:@"//bindmemberbypinresult/result" error:nil];
    
    for (GDataXMLNode *node in nodesArray) {
        memberTokenResultVO.strResult = [node stringValue];
        break;
    }
    
    if (![memberTokenResultVO.strResult isEqualToString:kStrOk]) {
        return memberTokenResultVO;
    }
    
    NSArray *memberTokenNodesArray = [rootNode nodesForXPath:@"//bindmemberbypinresult/token" error:nil];
    
    for (GDataXMLNode *node in memberTokenNodesArray) {
        memberTokenResultVO.strToken = [node stringValue];
        break;
    }
    return memberTokenResultVO;
}

+ (AccountResultVO*)parseAcccountResult:(NSData*)aData {
    AccountResultVO *accountResultVO = [[[AccountResultVO alloc] init] autorelease];
    
    GDataXMLDocument *document = [[[GDataXMLDocument alloc] initWithData:aData options:0 error:nil] autorelease];
    GDataXMLElement *rootNode = [document rootElement];
    NSArray *nodesArray = [rootNode nodesForXPath:@"//accountresult/result" error:nil];
    for (GDataXMLNode *node in nodesArray) {
        accountResultVO.strResult = [node stringValue];
        break;
    }
    
    AccountVO *accountVO = [[AccountVO alloc] init];
    accountResultVO.accountVO = accountVO;
    [accountVO release];
    
    NSArray *array1 = [rootNode nodesForXPath:@"//accountresult/email" error:nil];
    for (GDataXMLNode *node in array1) {
        accountResultVO.accountVO.strEmail = [node stringValue];
        break;
    }
    
    NSArray *array2 = [rootNode nodesForXPath:@"//accountresult/license" error:nil];
    for (GDataXMLNode *node in array2) {
        accountResultVO.accountVO.strLicense = [node stringValue];
        break;
    }
    
    NSArray *array3 = [rootNode nodesForXPath:@"//accountresult/type" error:nil];
    for (GDataXMLNode *node in array3) {
        accountResultVO.accountVO.strType = [node stringValue];
        break;
    }
    
    NSArray *array4 = [rootNode nodesForXPath:@"//accountresult/starttime" error:nil];
    for (GDataXMLNode *node in array4) {
        accountResultVO.accountVO.strStartTime = [node stringValue];
        break;
    }
    NSArray *array5 = [rootNode nodesForXPath:@"//accountresult/endtime" error:nil];
    for (GDataXMLNode *node in array5) {
        accountResultVO.accountVO.strEndTime = [node stringValue];
        break;
    }
    return accountResultVO;
}


#pragma mark
#pragma mark 登录后用户操作: (http://mobile.evonsoft.com/mobile/setting)

+ (MemberListResultVO*)parseMemberListResult:(NSData*)aData {
    MemberListResultVO *memberListVO = [[[MemberListResultVO alloc] init] autorelease];
    GDataXMLDocument *document = [[[GDataXMLDocument alloc] initWithData:aData options:0 error:nil] autorelease];
    GDataXMLElement *rootNode = [document rootElement];
    NSArray *nodesArray = [rootNode nodesForXPath:@"//listmemberresult/result" error:nil];

    for(GDataXMLNode *node in nodesArray) {
        memberListVO.strResult = [node stringValue];
        break;
    }
    
    if (![memberListVO.strResult isEqualToString:kStrOk]) {
        return memberListVO;
    }
    
    NSMutableArray *tempMutableArray = [[NSMutableArray alloc] init]; 
    memberListVO.memberMutableArray = tempMutableArray;
    [tempMutableArray release];
    
    NSArray *memberNodesArray = [rootNode nodesForXPath:@"//listmemberresult/member" error:nil];
    for (int i = 0; i < [memberNodesArray count]; i++) {
        MemberVO *memberVO = [[MemberVO alloc] init];
        GDataXMLElement *element = [memberNodesArray objectAtIndex:i];
        
        NSArray *memberIdNodesArray = [element nodesForXPath:@"./memberid" error:nil];
        for(GDataXMLNode *node in memberIdNodesArray) {
            memberVO.strMemberId = [node stringValue];
            break;
        }
        
        NSArray *memberTypeNodesArray = [element nodesForXPath:@"./membertype" error:nil];
        for(GDataXMLNode *node in memberTypeNodesArray) {
            memberVO.strMemberType = [node stringValue];
            break;
        }
        
        NSArray *firstNameNodesArray = [element nodesForXPath:@"./firstname" error:nil];
        for(GDataXMLNode *node in firstNameNodesArray) {
            memberVO.strFirstName = [node stringValue];
            break;
        }
        
        NSArray *lastNameNodesArray = [element nodesForXPath:@"./lastname" error:nil];
        for(GDataXMLNode *node in lastNameNodesArray) {
            memberVO.strLastName = [node stringValue];
            break;
        }
        
        NSArray *array5 = [element nodesForXPath:@"./islogin" error:nil];
        for (GDataXMLNode *node in array5) {
            memberVO.strIsLogin = [node stringValue];
            break;
        }
        
        NSArray *nodesArray6 = [element nodesForXPath:@"./pin" error:nil];
        for(GDataXMLNode *node in nodesArray6) {
            memberVO.strPin = [node stringValue];
            break;
        }
        
        if ([memberVO.strMemberType isEqualToString:@"web"]) {
            [AppVO sharedAppVO].strWebMemberId = memberVO.strMemberId;
            [[NSUserDefaults standardUserDefaults] setObject:memberVO.strMemberId forKey:kStrWebMemberId];
            [[NSUserDefaults standardUserDefaults] synchronize];
        } else {
            [memberListVO.memberMutableArray addObject:memberVO];
        }
        
        [memberVO release];
    }
    return memberListVO;
}

+ (GetMemberResultVO*)parseGetMemberResult:(NSData*)aData {
    GetMemberResultVO *getMemberResultVO = [[[GetMemberResultVO alloc] init] autorelease];
    GDataXMLDocument *document = [[[GDataXMLDocument alloc] initWithData:aData options:0 error:nil] autorelease];
    GDataXMLElement *rootNode = [document rootElement];
    NSArray *nodesArray = [rootNode nodesForXPath:@"//getmemberresult/result" error:nil];
    
    for(GDataXMLNode *node in nodesArray) {
        getMemberResultVO.strResult = [node stringValue];
        break;
    }
    
    if (![getMemberResultVO.strResult isEqualToString:kStrOk]) {
        return getMemberResultVO;
    }
    MemberVO *memberVO = [[MemberVO alloc] init];
    getMemberResultVO.memberVO = memberVO;
    [memberVO release];
    NSArray *nodesArray1 = [rootNode nodesForXPath:@"//getmemberresult/memberid" error:nil];
    for(GDataXMLNode *node in nodesArray1) {
        getMemberResultVO.memberVO.strMemberId = [node stringValue];
        break;
    }
    
    NSArray *nodesArray2 = [rootNode nodesForXPath:@"//getmemberresult/membertype" error:nil];
    for(GDataXMLNode *node in nodesArray2) {
        getMemberResultVO.memberVO.strMemberType = [node stringValue];
        break;
    }
    
    NSArray *nodesArray3 = [rootNode nodesForXPath:@"//getmemberresult/firstname" error:nil];
    for(GDataXMLNode *node in nodesArray3) {
        getMemberResultVO.memberVO.strFirstName = [node stringValue];
        break;
    }
    
    NSArray *nodesArray4 = [rootNode nodesForXPath:@"//getmemberresult/lastname" error:nil];
    for(GDataXMLNode *node in nodesArray4) {
        getMemberResultVO.memberVO.strLastName = [node stringValue];
        break;
    }
    
    NSArray *nodesArray5 = [rootNode nodesForXPath:@"//getmemberresult/islogin" error:nil];
    for(GDataXMLNode *node in nodesArray5) {
        getMemberResultVO.memberVO.strIsLogin = [node stringValue];
        break;
    }
    
    NSArray *nodesArray6 = [rootNode nodesForXPath:@"//getmemberresult/pin" error:nil];
    for(GDataXMLNode *node in nodesArray6) {
        getMemberResultVO.memberVO.strPin = [node stringValue];
        break;
    }
    
    return getMemberResultVO;
}

//+ (NSString*)parseSimpleResult:(NSData*)aData;共用位置相关操作的方法

+ (AddMemberResultVO*)parseAddMemberResult:(NSData*)aData {
    AddMemberResultVO *addMemberResultVO = [[[AddMemberResultVO alloc] init] autorelease];
    GDataXMLDocument *document = [[[GDataXMLDocument alloc] initWithData:aData options:0 error:nil] autorelease];
    GDataXMLElement *rootNode = [document rootElement];
    NSArray *nodesArray = [rootNode nodesForXPath:@"//addmemberresult/result" error:nil];

    for(GDataXMLNode *node in nodesArray) {
        addMemberResultVO.strResult = [node stringValue];
        break;
    }

    if (![addMemberResultVO.strResult isEqualToString:kStrOk]) {
        return addMemberResultVO;
    }
    
    NSArray *memberIdNodesArray = [rootNode nodesForXPath:@"//addmemberresult/memberid" error:nil];
    
    for(GDataXMLNode *node in memberIdNodesArray) {
        addMemberResultVO.strMemberId = [node stringValue];
        break;
    }
    
    NSArray *pinNodesArray = [rootNode nodesForXPath:@"//addmemberresult/pin" error:nil];
    
    for(GDataXMLNode *node in pinNodesArray) {
        addMemberResultVO.strPin = [node stringValue];
        break;
    }
    return addMemberResultVO;
}

+ (GetPictureResultVO*)parseGetPictureResult:(NSData*)aData {
    GetPictureResultVO *getPictureResultVO = [[[GetPictureResultVO alloc] init] autorelease];
    GDataXMLDocument *document = [[[GDataXMLDocument alloc] initWithData:aData options:0 error:nil] autorelease];
    GDataXMLElement *rootNode = [document rootElement];
    NSArray *nodesArray1 = [rootNode nodesForXPath:@"//getavatarresult/result" error:nil];
    for (GDataXMLNode *node in nodesArray1) {
        getPictureResultVO.strResult = [node stringValue];
        break;
    }
    NSArray *nodesArray2 = [rootNode nodesForXPath:@"//getavatarresult/memberid" error:nil];
    for (GDataXMLNode *node in nodesArray2) {
        getPictureResultVO.strMemberId = [node stringValue];
        break;
    }
    NSArray *nodesArray3 = [rootNode nodesForXPath:@"//getavatarresult/avatar" error:nil];
    for (GDataXMLNode *node in nodesArray3) {
        getPictureResultVO.strPicture = [node stringValue];
        break;
    }
    
    return getPictureResultVO;
}

+ (GetProfileResultVO*)parseGetProfileResult:(NSData*)aData {
    GetProfileResultVO *getProfileResultVO = [[[GetProfileResultVO alloc] init] autorelease];
    GDataXMLDocument *document = [[[GDataXMLDocument alloc] initWithData:aData options:0 error:nil] autorelease];
    GDataXMLElement *rootNode = [document rootElement];
    
    NSArray *nodesArray1 = [rootNode nodesForXPath:@"//getprofileresult/result" error:nil];
    for (GDataXMLNode *node in nodesArray1) {
        getProfileResultVO.strResult = [node stringValue];
        break;
    }
    
    ProfileVO *profileVO = [[ProfileVO alloc] init];
    getProfileResultVO.profileVO = profileVO;
    [profileVO release];
    
    NSArray *nodesArray2 = [rootNode nodesForXPath:@"//getprofileresult/phone" error:nil];
    for (GDataXMLNode *node in nodesArray2) {
        getProfileResultVO.profileVO.strPhone = [node stringValue];
        break;
    }
    NSArray *nodesArray3 = [rootNode nodesForXPath:@"//getprofileresult/notifyaircover" error:nil];
    for (GDataXMLNode *node in nodesArray3) {
        getProfileResultVO.profileVO.strNotifyAirCover = [node stringValue];
        break;
    }
    NSArray *nodesArray4 = [rootNode nodesForXPath:@"//getprofileresult/notifyemail" error:nil];
    for (GDataXMLNode *node in nodesArray4) {
        getProfileResultVO.profileVO.strNotifyEmail = [node stringValue];
        break;
    }
    
    NSArray *nodesArray5 = [rootNode nodesForXPath:@"//getprofileresult/notifysms" error:nil];
    for (GDataXMLNode *node in nodesArray5) {
        getProfileResultVO.profileVO.strNotifySms = [node stringValue];
        break;
    }
    
    NSArray *nodesArray6 = [rootNode nodesForXPath:@"//getprofileresult/smscount" error:nil];
    for (GDataXMLNode *node in nodesArray6) {
        getProfileResultVO.profileVO.strSmsCount = [node stringValue];
        break;
    }
    
    NSArray *nodesArray7 = [rootNode nodesForXPath:@"//getprofileresult/smsused" error:nil];
    for (GDataXMLNode *node in nodesArray7) {
        getProfileResultVO.profileVO.strSmsUsed = [node stringValue];
        break;
    }
    
    NSArray *nodesArray8 = [rootNode nodesForXPath:@"//getprofileresult/emailcount" error:nil];
    for (GDataXMLNode *node in nodesArray8) {
        getProfileResultVO.profileVO.strEmailCount = [node stringValue];
        break;
    }
    
    
    NSArray *nodesArray9 = [rootNode nodesForXPath:@"//getprofileresult/emailused" error:nil];
    for (GDataXMLNode *node in nodesArray9) {
        getProfileResultVO.profileVO.strEmailUsed = [node stringValue];
        break;
    }
    
    return getProfileResultVO;
}

#pragma mark
#pragma mark 位置相关操作 (http://mobile.evonsoft.com/mobile/location)

+ (NSString*)parseSimpleResult:(NSData*)aData {
    GDataXMLDocument *document = [[[GDataXMLDocument alloc] initWithData:aData options:0 error:nil] autorelease];
    GDataXMLElement *rootNode = [document rootElement];
    NSArray *nodesArray = [rootNode nodesForXPath:@"//result" error:nil];
    for (GDataXMLNode *node in nodesArray) {
        return [node stringValue];
        break;
    }
    return nil;
}

+ (GetLocationsResultVO*)parseGetLocationsResult:(NSData*)aData {
    GetLocationsResultVO *getLocationsResultVO = [[[GetLocationsResultVO alloc] init] autorelease];
    GDataXMLDocument *document = [[[GDataXMLDocument alloc] initWithData:aData options:0 error:nil] autorelease];
    GDataXMLElement *rootNode = [document rootElement];
    NSArray *nodesArray = [rootNode nodesForXPath:@"//listlocationresult/result" error:nil];
    for (GDataXMLNode *node in nodesArray) {
        getLocationsResultVO.strResult = [node stringValue];
        break;
    }
    NSArray *servertimeNodesArray = [rootNode nodesForXPath:@"//listlocationresult/servertime" error:nil];
    for (GDataXMLNode *node in servertimeNodesArray) {
        getLocationsResultVO.strServerTime = [node stringValue];
        break;
    }
    
    NSMutableArray *tempMutableArray = [[NSMutableArray alloc] init]; 
    getLocationsResultVO.locationVOMutableArray = tempMutableArray;
    [tempMutableArray release];
    
    NSArray *locationNodesArray = [rootNode nodesForXPath:@"//listlocationresult/location" error:nil];
    for (GDataXMLElement *element in locationNodesArray) {
        LocationVO *locationVO = [[LocationVO alloc] init];
        NSArray *memberIdNodesArray = [element nodesForXPath:@"./memberid" error:nil];
        for (GDataXMLNode *node in memberIdNodesArray) {
            locationVO.strMemberId = [node stringValue];
            break;
        }
        
        NSArray *longutudeNodesArray = [element nodesForXPath:@"./longitude" error:nil];
        for (GDataXMLNode *node in longutudeNodesArray) {
            locationVO.strLongitude = [node stringValue];
            break;
        }
        
        NSArray *latitudeNodesArray = [element nodesForXPath:@"./latitude" error:nil];
        for (GDataXMLNode *node in latitudeNodesArray) {
            locationVO.strLatitude = [node stringValue];
            break;
        }
        
        NSArray *timeNodesArray = [element nodesForXPath:@"./time" error:nil];
        for (GDataXMLNode *node in timeNodesArray) {
            locationVO.strTime = [node stringValue];
            break;
        }
        [getLocationsResultVO.locationVOMutableArray addObject:locationVO];
        [locationVO release];
    }
    return getLocationsResultVO;
}

+ (GetLocationResultVO*)parseGetLocationResult:(NSData*)aData {
    GetLocationResultVO *getLocationResultVO = [[[GetLocationResultVO alloc] init] autorelease];
    GDataXMLDocument *document = [[[GDataXMLDocument alloc] initWithData:aData options:0 error:nil] autorelease];
    GDataXMLElement *rootNode = [document rootElement];
    NSArray *nodesArray = [rootNode nodesForXPath:@"//getlocationresult/result" error:nil];
    for (GDataXMLNode *node in nodesArray) {
        getLocationResultVO.strResult = [node stringValue];
        break;
    }
    NSArray *servertimeNodesArray = [rootNode nodesForXPath:@"//getlocationresult/servertime" error:nil];
    for (GDataXMLNode *node in servertimeNodesArray) {
        getLocationResultVO.strServerTime = [node stringValue];
        break;
    }
    
    LocationVO *locationVO = [[LocationVO alloc] init];
    getLocationResultVO.locationVO = locationVO;
    [locationVO release];
    
    NSArray *memberIdNodesArray = [rootNode nodesForXPath:@"//getlocationresult/memberid" error:nil];
    for (GDataXMLNode *node in memberIdNodesArray) {
        getLocationResultVO.locationVO.strMemberId = [node stringValue];
        break;
    }
    
    NSArray *longutudeNodesArray = [rootNode nodesForXPath:@"//getlocationresult/longitude" error:nil];
    for (GDataXMLNode *node in longutudeNodesArray) {
        getLocationResultVO.locationVO.strLongitude = [node stringValue];
        break;
    }
    
    NSArray *latitudeNodesArray = [rootNode nodesForXPath:@"//getlocationresult/latitude" error:nil];
    for (GDataXMLNode *node in latitudeNodesArray) {
        getLocationResultVO.locationVO.strLatitude = [node stringValue];
        break;
    }
    
    NSArray *timeNodesArray = [rootNode nodesForXPath:@"//getlocationresult/time" error:nil];
    for (GDataXMLNode *node in timeNodesArray) {
        getLocationResultVO.locationVO.strTime = [node stringValue];
        break;
    }

    return getLocationResultVO;
}

+ (AddCircleResultVO*)parseAddCircleResult:(NSData*)aData {
    AddCircleResultVO *addCircleResultVO = [[[AddCircleResultVO alloc] init] autorelease];
    GDataXMLDocument *document = [[[GDataXMLDocument alloc] initWithData:aData options:0 error:nil] autorelease];
    GDataXMLElement *rootNode = [document rootElement];
    NSArray *nodesArray1 = [rootNode nodesForXPath:@"//addcircleresult/result" error:nil];
    for (GDataXMLNode *node in nodesArray1) {
        addCircleResultVO.strResult = [node stringValue];
        break;
    }
    NSArray *nodesArray2 = [rootNode nodesForXPath:@"//addcircleresult/circleid" error:nil];
    for (GDataXMLNode *node in nodesArray2) {
        addCircleResultVO.strCircleId = [node stringValue];
        break;
    }
    return addCircleResultVO;
}

+ (GetCirclesResultVO*)parseGetCirclesResult:(NSData*)aData {
    GetCirclesResultVO *getCirclesResultVO = [[[GetCirclesResultVO alloc] init] autorelease];
    GDataXMLDocument *document = [[[GDataXMLDocument alloc] initWithData:aData options:0 error:nil] autorelease];
    GDataXMLElement *rootNode = [document rootElement];
    NSArray *nodesArray1 = [rootNode nodesForXPath:@"//listcircleresult/result" error:nil];
    for (GDataXMLNode *node in nodesArray1) {
        getCirclesResultVO.strResult = [node stringValue];
        break;
    }
    
    NSMutableArray *tempMutableArray = [[NSMutableArray alloc] init]; 
    getCirclesResultVO.circleVOMutableArray = tempMutableArray;
    [tempMutableArray release];
    
    NSArray *nodesArray2 = [rootNode nodesForXPath:@"//listcircleresult/circle" error:nil];
    for (GDataXMLElement *element in nodesArray2) {
        CircleVO *circleVO = [[CircleVO alloc] init];
        NSArray *array1 = [element nodesForXPath:@"./circleid" error:nil];
        for (GDataXMLNode *node in array1) {
            circleVO.strCircleId = [node stringValue];
        }
        NSArray *array2 = [element nodesForXPath:@"./longitude" error:nil];
        for (GDataXMLNode *node in array2) {
            circleVO.strLongitude = [node stringValue];
        }
        
        NSArray *array3 = [element nodesForXPath:@"./latitude" error:nil];
        for (GDataXMLNode *node in array3) {
            circleVO.strLatitude = [node stringValue];
        }
        
        NSArray *array4 = [element nodesForXPath:@"./radius" error:nil];
        for (GDataXMLNode *node in array4) {
            circleVO.strRadius = [node stringValue];
        }
        
        NSArray *array5 = [element nodesForXPath:@"./name" error:nil];
        for (GDataXMLNode *node in array5) {
            circleVO.strName = [node stringValue];
        }
        
        NSArray *array6 = [element nodesForXPath:@"./notifyin" error:nil];
        for (GDataXMLNode *node in array6) {
            circleVO.strNotifyIn = [node stringValue];
        }
        
        NSArray *array7 = [element nodesForXPath:@"./notifyout" error:nil];
        for (GDataXMLNode *node in array7) {
            circleVO.strNotifyOut = [node stringValue];
        }
        
        [getCirclesResultVO.circleVOMutableArray addObject:circleVO];
        [circleVO release];
    }
    
    return getCirclesResultVO;
    
}

+ (GetCircleResultVO*)parseGetCircleResult:(NSData*)aData {
    GetCircleResultVO *getCircleResultVO = [[[GetCircleResultVO alloc] init] autorelease];
    GDataXMLDocument *document = [[[GDataXMLDocument alloc] initWithData:aData options:0 error:nil] autorelease];
    GDataXMLElement *rootNode = [document rootElement];
    NSArray *nodesArray1 = [rootNode nodesForXPath:@"//getcircleresult/result" error:nil];
    for (GDataXMLNode *node in nodesArray1) {
        getCircleResultVO.strResult = [node stringValue];
        break;
    }
    
    CircleVO *circleVO = [[CircleVO alloc] init];
    getCircleResultVO.circleVO = circleVO;
    [circleVO release];
    
    NSArray *array1 = [rootNode nodesForXPath:@"//getcircleresult/circleid" error:nil];
    for (GDataXMLNode *node in array1) {
        getCircleResultVO.circleVO.strCircleId = [node stringValue];
    }
    NSArray *array2 = [rootNode nodesForXPath:@"//getcircleresult/longitude" error:nil];
    for (GDataXMLNode *node in array2) {
        getCircleResultVO.circleVO.strLongitude = [node stringValue];
    }
    
    NSArray *array3 = [rootNode nodesForXPath:@"//getcircleresult/latitude" error:nil];
    for (GDataXMLNode *node in array3) {
        getCircleResultVO.circleVO.strLatitude = [node stringValue];
    }
    
    NSArray *array4 = [rootNode nodesForXPath:@"//getcircleresult/radius" error:nil];
    for (GDataXMLNode *node in array4) {
        getCircleResultVO.circleVO.strRadius = [node stringValue];
    }
    
    NSArray *array5 = [rootNode nodesForXPath:@"//getcircleresult/name" error:nil];
    for (GDataXMLNode *node in array5) {
        getCircleResultVO.circleVO.strName = [node stringValue];
    }
    
    NSArray *array6 = [rootNode nodesForXPath:@"//getcircleresult/notifyin" error:nil];
    for (GDataXMLNode *node in array6) {
        getCircleResultVO.circleVO.strNotifyIn = [node stringValue];
    }
    
    NSArray *array7 = [rootNode nodesForXPath:@"//getcircleresult/notifyout" error:nil];
    for (GDataXMLNode *node in array7) {
        getCircleResultVO.circleVO.strNotifyOut = [node stringValue];
    }
    
    return getCircleResultVO;
}

+ (GetCircleAvatarResultVO*)parseGetCircleAvatarResult:(NSData*)aData {
    GetCircleAvatarResultVO *getCircleAvatarResultVO = [[[GetCircleAvatarResultVO alloc] init] autorelease];
    GDataXMLDocument *document = [[[GDataXMLDocument alloc] initWithData:aData options:0 error:nil] autorelease];
    GDataXMLElement *rootNode = [document rootElement];
    NSArray *nodesArray1 = [rootNode nodesForXPath:@"//getcircleavatarresult/result" error:nil];
    for (GDataXMLNode *node in nodesArray1) {
        getCircleAvatarResultVO.strResult = [node stringValue];
        break;
    }
    
    NSArray *nodesArray2 = [rootNode nodesForXPath:@"//getcircleavatarresult/circleid" error:nil];
    for (GDataXMLNode *node in nodesArray2) {
        getCircleAvatarResultVO.strCircleId = [node stringValue];
        break;
    }
    
    NSArray *nodesArray3 = [rootNode nodesForXPath:@"//getcircleavatarresult/avatar" error:nil];
    for (GDataXMLNode *node in nodesArray3) {
        getCircleAvatarResultVO.strAvatar = [node stringValue];
        break;
    }
    return getCircleAvatarResultVO;
}


#pragma mark
#pragma mark 查询相关操作 (http://mobile.evonsoft.com/mobile/query)
//+ (EventCountResultVO*)parseEventCountResult:(NSData*)aData {
//    EventCountResultVO *eventCountResultVO = [[[EventCountResultVO alloc] init] autorelease];
//    GDataXMLDocument *document = [[[GDataXMLDocument alloc] initWithData:aData options:0 error:nil] autorelease];
//    
//    GDataXMLElement *rootNode = [document rootElement];
//    NSArray *nodesArray = [rootNode nodesForXPath:@"//eventcountresult/result" error:nil];
//    for (GDataXMLNode *node in nodesArray) {
//        eventCountResultVO.strResult = [node stringValue];
//    }
//    
//    NSArray *countArray = [rootNode nodesForXPath:@"//eventcountresult/count" error:nil];
//    for (GDataXMLNode *node in countArray) {
//        eventCountResultVO.strCount = [node stringValue];
//    }
//    return eventCountResultVO;
//}

+ (EventListResultVO*)parseEventListResult:(NSData*)aData {
    EventListResultVO *eventListResultVO = [[[EventListResultVO alloc] init] autorelease];
    GDataXMLDocument *document = [[[GDataXMLDocument alloc] initWithData:aData options:0 error:nil] autorelease];
    
    GDataXMLElement *rootNode = [document rootElement];
    NSArray *nodesArray = [rootNode nodesForXPath:@"//recveventresult/result" error:nil];
    for (GDataXMLNode *node in nodesArray) {
        eventListResultVO.strResult = [node stringValue];
        break;
    }
    
    //NSArray *countNodesArray = [rootNode nodesForXPath:@"//recveventresult/count" error:nil];
//    for (GDataXMLNode *node in countNodesArray) {
//        eventListResultVO.strCount = [node stringValue];
//        break;
//    }
    
    NSArray *serverTimeNodesArray = [rootNode nodesForXPath:@"//recveventresult/servertime" error:nil];
    for (GDataXMLNode *node in serverTimeNodesArray) {
        eventListResultVO.strServerTime = [node stringValue];
        break;
    }
    
    NSMutableArray *tempMutableArray = [[NSMutableArray alloc] init]; 
    eventListResultVO.eventMutableArray = tempMutableArray;
    [tempMutableArray release];
    
    NSArray *eventArray = [rootNode nodesForXPath:@"//recveventresult/event" error:nil];
    for (GDataXMLElement *element in eventArray) {
        EventVO *eventVO = [[EventVO alloc] init];
        NSArray *array1 = [element nodesForXPath:@"./eventid" error:nil];
        for (GDataXMLNode *node in array1) {
            eventVO.strEventId = [node stringValue];
            break;
        }
        
        NSArray *array2 = [element nodesForXPath:@"./smid" error:nil];
        for (GDataXMLNode *node in array2) {
            eventVO.strSendMemberId = [node stringValue];
            break;
        }
        
        NSArray *array3 = [element nodesForXPath:@"./rmid" error:nil];
        for (GDataXMLNode *node in array3) {
            eventVO.strRecvMemberId = [node stringValue];
            break;
        }
        
        NSArray *array4 = [element nodesForXPath:@"./name" error:nil];
        for (GDataXMLNode *node in array4) {
            eventVO.strName = [node stringValue];
            break;
        }
        
        NSArray *array5 = [element nodesForXPath:@"./value" error:nil];
        for (GDataXMLNode *node in array5) {
            eventVO.strValue = [node stringValue];
            break;
        }
        
        NSArray *array6 = [element nodesForXPath:@"./time" error:nil];
        for (GDataXMLNode *node in array6) {
            eventVO.strTime = [node stringValue];
            break;
        }
        [eventListResultVO.eventMutableArray addObject:eventVO];
        [eventVO release];
    }
    return eventListResultVO;
}

#pragma mark
#pragma mark 消息相关操作 (http://mobile.evonsoft.com/mobile/message)

+ (RecvMessageResultVO*)parseRecvMessageResult:(NSData*)aData {
    RecvMessageResultVO *recvMessageResultVO = [[[RecvMessageResultVO alloc] init] autorelease];
    GDataXMLDocument *document = [[[GDataXMLDocument alloc] initWithData:aData options:0 error:nil] autorelease];
    GDataXMLElement *rootNode = [document rootElement];
    NSArray *nodesArray1 = [rootNode nodesForXPath:@"//recvmessageresult/result" error:nil];
    for (GDataXMLNode *node in nodesArray1) {
        recvMessageResultVO.strResult = [node stringValue];
        break;
    }
    NSArray *nodesArray2 = [rootNode nodesForXPath:@"//recvmessageresult/servertime" error:nil];
    for (GDataXMLNode *node in nodesArray2) {
        recvMessageResultVO.strServerTime = [node stringValue];
        break;
    }
    NSMutableArray *tempMutableArray = [[NSMutableArray alloc] init]; 
    recvMessageResultVO.messageMutableArray = tempMutableArray;
    [tempMutableArray release];
    
    NSArray *messageArray = [rootNode nodesForXPath:@"//recvmessageresult/message" error:nil];
    for (GDataXMLElement *element in messageArray) {
        MessageVO *messageVO = [[MessageVO alloc] init];
        
        NSArray *array0 = [element nodesForXPath:@"./smid" error:nil];
        for (GDataXMLNode *node in array0) {
            messageVO.strSendMemberId = [node stringValue];
            break;
        }
        
        NSArray *array1 = [element nodesForXPath:@"./messageid" error:nil];
        for (GDataXMLNode *node in array1) {
            messageVO.strMessageId = [node stringValue];
            break;
        }
        
        NSArray *array2 = [element nodesForXPath:@"./text" error:nil];
        for (GDataXMLNode *node in array2) {
            NSData *data = [NSData dataFromBase64String:[node stringValue]];
            NSString *strText = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            messageVO.strText = strText;
            [strText release];
            break;
        }
        
        NSArray *array3 = [element nodesForXPath:@"./time" error:nil];
        for (GDataXMLNode *node in array3) {
            messageVO.strTime = [node stringValue];
            break;
        }
        
        NSArray *array4 = [element nodesForXPath:@"./type" error:nil];
        for (GDataXMLNode *node in array4) {
            messageVO.strType = [node stringValue];
            break;
        }
        
        [recvMessageResultVO.messageMutableArray addObject:messageVO];
        [messageVO release];
    }
    return recvMessageResultVO;
}

#pragma mark
#pragma mark 手机丢失操作 (http://mobile.evonsoft.com/mobile/device)

+ (GetDeviceTipResultVO*)parseGetDeviceTipResult:(NSData*)aData {
    GetDeviceTipResultVO *getDeviceTipResult = [[[GetDeviceTipResultVO alloc] init] autorelease];
    GDataXMLDocument *document = [[[GDataXMLDocument alloc] initWithData:aData options:0 error:nil] autorelease];
    GDataXMLElement *rootNode = [document rootElement];
    NSArray *nodesArray1 = [rootNode nodesForXPath:@"//getdevicetipresult/result" error:nil];
    for (GDataXMLNode *node in nodesArray1) {
        getDeviceTipResult.strResult = [node stringValue];
        break;
    }
    NSArray *nodesArray2 = [rootNode nodesForXPath:@"//getdevicetipresult/tip" error:nil];
    for (GDataXMLNode *node in nodesArray2) {
        NSData *data = [NSData dataFromBase64String:[node stringValue]];
        NSString *strText = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        getDeviceTipResult.strTip = strText;
        [strText release];
        break;
    }
    return getDeviceTipResult;
}*/


/*
 * other
 */
/*
+ (EventServerVO*)parseEventServerResult:(NSString*)strXML {
    EventServerVO *eventServerVO = [[[EventServerVO alloc] init] autorelease];
    GDataXMLDocument *document = [[[GDataXMLDocument alloc] initWithXMLString:strXML options:0 error:nil] autorelease];
    GDataXMLElement *rootNode = [document rootElement];
    NSArray *nodesArray1 = [rootNode nodesForXPath:@"//event/name" error:nil];
    for (GDataXMLNode *node in nodesArray1) {
        eventServerVO.strName = [node stringValue];
        break;
    }
    NSArray *nodesArray2 = [rootNode nodesForXPath:@"//event/value" error:nil];
    for (GDataXMLNode *node in nodesArray2) {
        eventServerVO.strValue = [node stringValue];
        break;
    }
    return eventServerVO;
}


+ (AirCoverUpdateInfoVO*)parseCheckUpdateResult:(NSData*)aData {
    AirCoverUpdateInfoVO *airCoverUpdateInfoVO = [[[AirCoverUpdateInfoVO alloc] init] autorelease];
    GDataXMLDocument *document = [[[GDataXMLDocument alloc] initWithData:aData options:0 error:nil] autorelease];
    GDataXMLElement *rootNode = [document rootElement];
    NSArray *nodesArray1 = [rootNode nodesForXPath:@"//aircoverupdate/iphone" error:nil];
    for (GDataXMLNode *node in nodesArray1) {
        NSArray *a1 = [node nodesForXPath:@"./mintip" error:nil];
        for (GDataXMLNode *n in a1) {
            airCoverUpdateInfoVO.strMinTip = [n stringValue];
            break;
        }
        
        NSArray *a2 = [node nodesForXPath:@"./minversion" error:nil];
        for (GDataXMLNode *n in a2) {
            airCoverUpdateInfoVO.strMinVersion = [n stringValue];
            break;
        }
        
        NSArray *a3 = [node nodesForXPath:@"./maxtip" error:nil];
        for (GDataXMLNode *n in a3) {
            airCoverUpdateInfoVO.strMaxTip = [n stringValue];
            break;
        }
        
        
        NSArray *a4 = [node nodesForXPath:@"./maxversion" error:nil];
        for (GDataXMLNode *n in a4) {
            airCoverUpdateInfoVO.strMaxVersion = [n stringValue];
            break;
        }
        
        NSArray *a5 = [node nodesForXPath:@"./upgradeurl" error:nil];
        for (GDataXMLNode *n in a5) {
            airCoverUpdateInfoVO.strUpgradeUrl = [n stringValue];
            break;
        }
        
        NSArray *a6 = [node nodesForXPath:@"./rateurl" error:nil];
        for(GDataXMLNode *n in a6) {
            airCoverUpdateInfoVO.strRateUrl = [n stringValue];
            break;
        }
        
        break;
    }
    return airCoverUpdateInfoVO;
}
*/
@end



























































