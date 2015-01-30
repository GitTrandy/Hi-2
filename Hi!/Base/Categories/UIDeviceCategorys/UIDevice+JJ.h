//
//  UIDevice+JJ.h
//  易商
//
//  Created by 伍松和 on 14/10/23.
//  Copyright (c) 2014年 Ruifeng. All rights reserved.
//

#import <UIKit/UIKit.h>

#define Hi_SMS_UNREAD_NOTIFATION @"Hi_SMS_UNREAD_NOTIFATION"
// 1.判断是否为iPhone5的宏
#define iPhone5 ([UIScreen mainScreen].bounds.size.height == 568)
#define IOS7 ([[[UIDevice currentDevice]systemVersion] floatValue] >= 7.0)
#define IOS8 ([[[UIDevice currentDevice]systemVersion] floatValue] >= 8.0)
#define IOS7_1 ([[[UIDevice currentDevice]systemVersion] floatValue] >= 7.1)

//获取设备的物理高度
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
//获取设备的物理宽度
#define ScreenWidth [UIScreen mainScreen].bounds.size.width

// 5.获得RGB颜色
#define kColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
//颜色
#define Color(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

#pragma mark -用户信息-A
/**
 *  用户UID
 */
#define USER_UID @"UID"
#define SAVE_MY_UID(OBJ) [[NSUserDefaults standardUserDefaults]setObject:OBJ forKey:USER_UID];[[NSUserDefaults standardUserDefaults]synchronize]
#define MY_UID [[NSUserDefaults standardUserDefaults]objectForKey:USER_UID]

/**
 *  推送用的AVID
 */
#define USER_AVID @"avid"
#define SAVE_MY_AVID(AVID) [[NSUserDefaults standardUserDefaults]setObject:AVID forKey:USER_AVID];[[NSUserDefaults standardUserDefaults]synchronize]
#define MY_AVID [[NSUserDefaults standardUserDefaults]objectForKey:USER_AVID]
/**
 *  用户设备 ID
 */
#define USER_DRIVER @"USER_DRIVER"
#define MY_USER_DRIVER [[NSUserDefaults standardUserDefaults]objectForKey:USER_DRIVER]
#define SAVE_MY_USER_DRIVER(DRIVER) [[NSUserDefaults standardUserDefaults]objectForKey:DRIVER];[[NSUserDefaults standardUserDefaults]synchronize]

/**
 *  用户的 token
 */
#define USER_TOKEN @"TOKEN"
#define MY_USER_TOKEN [[NSUserDefaults standardUserDefaults]objectForKey:USER_TOKEN]
#define SAVE_MY_USER_TOKEN(TOKEN) [[NSUserDefaults standardUserDefaults]objectForKey:TOKEN];[[NSUserDefaults standardUserDefaults]synchronize]
/**
 *  用户当前控制器
 */
#define USER_CURRENT_CTRL @"USER_CURRENT_CTRL"
#define SAVE_USER_CURRENT_CTRL(OBJ) [[NSUserDefaults standardUserDefaults]setObject:OBJ forKey:USER_CURRENT_CTRL];[[NSUserDefaults standardUserDefaults]synchronize]
#define GET_USER_CURRENT_CTRL [[NSUserDefaults standardUserDefaults]objectForKey:USER_CURRENT_CTRL]


#pragma mark -用户信息-B
/**
 *  用户设置
 */
#define USER_DETAIL_ACCOUNT  @"account"
/////用户有帐号
#define USER_ACCOUNT  @"USER_ACCOUNT"
#define SET_USER_ACCOUNT [[NSUserDefaults standardUserDefaults]setObject:USER_ACCOUNT forKey:USER_ACCOUNT];[[NSUserDefaults standardUserDefaults]synchronize]
#define GET_USER_ACCOUNT [[NSUserDefaults standardUserDefaults]objectForKey:USER_ACCOUNT]
#define DEL_USER_ACCOUNT [[NSUserDefaults standardUserDefaults]setObject:nil forKey:USER_ACCOUNT];[[NSUserDefaults standardUserDefaults]synchronize]
//资料修改过
#define USER_MOFITIED @"USER_MOFITIED"
#define SET_USER_MOFITIED [[NSUserDefaults standardUserDefaults]setObject:USER_MOFITIED forKey:USER_MOFITIED];[[NSUserDefaults standardUserDefaults]synchronize]
#define GET_USER_MOFITIED [[NSUserDefaults standardUserDefaults]objectForKey:USER_MOFITIED]
#define DEL_USER_MOFITIED [[NSUserDefaults standardUserDefaults]setObject:nil forKey:USER_MOFITIED];[[NSUserDefaults standardUserDefaults]synchronize]


///第一次启动,加载消息
#define USER_FIRST_LOAD_MSG_LIST @"USER_FIRST_LOAD_MSG_LIST"
#define MY_USER_FIRST_LOAD_MSG_LIST [[NSUserDefaults standardUserDefaults]objectForKey:USER_FIRST_LOAD_MSG_LIST]
#define SAVE_USER_FIRST_LOAD_MSG_LIST(OBJ) [[NSUserDefaults standardUserDefaults]setObject:OBJ forKey:USER_FIRST_LOAD_MSG_LIST];[[NSUserDefaults standardUserDefaults]synchronize]

///第一次启动,加载优惠卷
#define USER_FIRST_LOAD_COUPONS_LIST @"USER_FIRST_LOAD_COUPONS_LIST"
#define MY_USER_FIRST_LOAD_COUPONS_LIST [[NSUserDefaults standardUserDefaults]objectForKey:USER_FIRST_LOAD_COUPONS_LIST]
#define SAVE_USER_FIRST_LOAD_COUPONS_LIST(OBJ) [[NSUserDefaults standardUserDefaults]setObject:OBJ forKey:USER_FIRST_LOAD_COUPONS_LIST];[[NSUserDefaults standardUserDefaults]synchronize]

///第一次启动,加载店家
#define USER_FIRST_LOAD_SHOP_LIST @"USER_FIRST_LOAD_SHOP_LIST"
#define MY_USER_FIRST_LOAD_SHOP_LIST [[NSUserDefaults standardUserDefaults]objectForKey:USER_FIRST_LOAD_SHOP_LIST]
#define SAVE_USER_FIRST_LOAD_SHOP_LIST(OBJ) [[NSUserDefaults standardUserDefaults]setObject:OBJ forKey:USER_FIRST_LOAD_SHOP_LIST];[[NSUserDefaults standardUserDefaults]synchronize]

///第一次启动,加载人

#define USER_FIRST_LOAD_USER_LIST @"USER_FIRST_LOAD_USER_LIST"
#define MY_USER_FIRST_LOAD_USER_LIST [[NSUserDefaults standardUserDefaults]objectForKey:USER_FIRST_LOAD_USER_LIST]
#define SAVE_USER_FIRST_LOAD_USER_LIST(OBJ) [[NSUserDefaults standardUserDefaults]setObject:OBJ forKey:USER_FIRST_LOAD_USER_LIST];[[NSUserDefaults standardUserDefaults]synchronize]



//#define HI_REMOTE_NOTIFICATION          @"HI_REMOTE_NOTIFICATION"
#define HI_UN_READ_NUM_NOTIFICATION     @"HI_UN_READ_NUM_NOTIFICATION"
#define NOTIFICATION_MESSAGE_UPDATED @"NOTIFICATION_MESSAGE_UPDATED" //消息更新

#pragma mark -设备信息
@interface UIDevice (JJ)
#pragma mark- 是否静音状态
+ (BOOL)isDeviceSilence;
#pragma mark -获取设备 UDID
+ (NSString *)getDeviceUDID;
#pragma mark -得到可爱的WifiMac地址
#define WIFI_MAC_ZERO @"00"
+(NSString*)getWifiMacAddress;
#pragma mark -获取 AVID(推送标识)
+(NSString*)getAVOSDeviceID;
#pragma mark -判断网络是否可行
+ (BOOL)isNetWorkReachable;

/**
 *  colorString=(0,0,0,0)

 */
+(UIColor*)colorExchangeByColorString:(NSString*)colorString;

@end
