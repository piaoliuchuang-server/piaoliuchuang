//
//  LoginRegisterParser.h
//  MobleSecurity
//
//  Created by andylee1988 on 11-8-12.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CommonXMLParser : NSObject {

}
/*
#pragma mark
#pragma mark 注册流程: (http://mobile.evonsoft.com/mobile/register)
+ (RegisterResultVO*)parseRegisterResult:(NSData*)aData;


#pragma mark
#pragma mark 登录流程: (http://mobile.evonsoft.com/mobile/login)

+ (LoginResultVO*)parseLoginResult:(NSData*)aData;

+ (MemberListResultVO*)parseLoginMemberListResult:(NSData*)aData;

+ (AddMemberResultVO*)parseLoginAddMemberResult:(NSData*)aData;

+ (MemberTokenResultVO*)parseMemberTokenResult:(NSData*)aData;

+ (MemberTokenResultVO*)parseMemberTokenByPinResult:(NSData*)aData;

+ (AccountResultVO*)parseAcccountResult:(NSData*)aData;


#pragma mark
#pragma mark 登录后用户操作: (http://mobile.evonsoft.com/mobile/setting)

+ (MemberListResultVO*)parseMemberListResult:(NSData*)aData;

+ (GetMemberResultVO*)parseGetMemberResult:(NSData*)aData;

//+ (NSString*)parseSimpleResult:(NSData*)aData;共用位置相关操作的方法

+ (AddMemberResultVO*)parseAddMemberResult:(NSData*)aData;

+ (GetPictureResultVO*)parseGetPictureResult:(NSData*)aData;

+ (GetProfileResultVO*)parseGetProfileResult:(NSData*)aData;

#pragma mark
#pragma mark 位置相关操作 (http://mobile.evonsoft.com/mobile/location)

+ (NSString*)parseSimpleResult:(NSData*)aData;

+ (GetLocationsResultVO*)parseGetLocationsResult:(NSData*)aData;

+ (GetLocationResultVO*)parseGetLocationResult:(NSData*)aData;

+ (AddCircleResultVO*)parseAddCircleResult:(NSData*)aData;

+ (GetCirclesResultVO*)parseGetCirclesResult:(NSData*)aData;

+ (GetCircleResultVO*)parseGetCircleResult:(NSData*)aData;

+ (GetCircleAvatarResultVO*)parseGetCircleAvatarResult:(NSData*)aData;
#pragma mark
#pragma mark 查询相关操作 (http://mobile.evonsoft.com/mobile/query)
//+ (EventCountResultVO*)parseEventCountResult:(NSData*)aData;

+ (EventListResultVO*)parseEventListResult:(NSData*)aData;
*/
/*
 *<eventconfirmresult>
 *<result>
 *</eventconfirmresult>
*/
//+ (NSString*)parseSimpleResult:(NSData*)aData;共用位置相关操作的方法

#pragma mark
#pragma mark 消息相关操作 (http://mobile.evonsoft.com/mobile/message)

/*
 *<sendmessageresult>
 *<result>
 *</sendmessageresult>
 */
//+ (NSString*)parseSimpleResult:(NSData*)aData;共用位置相关操作的方法

//+ (RecvMessageResultVO*)parseRecvMessageResult:(NSData*)aData;

/*
 *<confirmmessageresult>
 *<result>
 *</confirmmessageresult>
 */
//+ (NSString*)parseSimpleResult:(NSData*)aData;共用位置相关操作的方法

#pragma mark
#pragma mark 手机丢失操作 (http://mobile.evonsoft.com/mobile/device)
/*
 *<enabledevicetipresult>
 *<result>
 *</enabledevicetipresult>
 */
//+ (NSString*)parseSimpleResult:(NSData*)aData;共用位置相关操作的方法

//+ (GetDeviceTipResultVO*)parseGetDeviceTipResult:(NSData*)aData;




/*
 * other
 */
/*
+ (EventServerVO*)parseEventServerResult:(NSString*)strXML;


+ (AirCoverUpdateInfoVO*)parseCheckUpdateResult:(NSData*)aData;
*/
@end













