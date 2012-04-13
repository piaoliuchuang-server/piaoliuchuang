//
//  Created by David Alpha Fox on 3/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


/**
 * @file NetworkUtilites
 * @author David<gaotianpo@songshulin.net>
 *
 * @brief 网络辅助工具
 * 
 * @details 网络辅助工具
 * 
 */

/**
 * @brief 当前网络是否联通的
 */
BOOL SSNetworkConnected(void);

/**
 * @brief 是否是通过wifi链接的
 */
BOOL SSNetworkWifiConnected(void);

/**
 * @brief 是否是通过蜂窝网链接的
 */
BOOL SSNetowrkCellPehoneConnected(void);

/**
 *@brief 两个特殊函数，这个将有queue使用
 *       注意回调函数要线程安全处理。
 */
void SSNetworkStartNotifier(void);
void SSNetworkStopNotifier(void);
