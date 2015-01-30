//
//  Hi_GlobalMarco.h
//  Hi!
//
//  Created by 伍松和 on 14/11/27.
//  Copyright (c) 2014年 伍松和. All rights reserved.
//

#ifndef Hi__Hi_GlobalMarco_h
#define Hi__Hi_GlobalMarco_h

#import "Hi_Account.h"
#import "Hi_BusinessModel.h"
#import "Hi_CouponsModel.h"
#import "Hi_UserModel.h"
#import "Hi_SMSModel.h"


#import "LibMarco.h"
#import "CategoryMarco.h"


#import "Hi_SmsTool.h"
//#import "Hi_AccountTool.h"

/**
 *  AVOS
 *///
#define systemURL [[NSBundle mainBundle]URLForResource:@"Hi_AccountConfig" withExtension:@"plist"]
#define SystemDic [NSDictionary dictionaryWithContentsOfURL:systemURL]
#define AVOSAppID       SystemDic[@"AVOSINFO"][@"AVOSAppID"]
#define AVOSAppkey      SystemDic[@"AVOSINFO"][@"AVOSAppkey"]
#define AVOSMasterkey   SystemDic[@"AVOSINFO"][@"AVOSMasterkey"]

/**
 *  新浪
 */

#define SinaAppkey SystemDic[@"SINAINFO"][@"SinaAppkey"]
#define SinaAppSecret SystemDic[@"SINAINFO"][@"SinaAppSecret"]
#define SinaRedirectURI SystemDic[@"SINAINFO"][@"SinaRedirectURI"]
/**
 *  QQ
 */

#define QQAppKey SystemDic[@"QQINFO"][@"QQAppKey"]
#define QQAppSecret SystemDic[@"QQINFO"][@"QQAppSecret"]


//微信
#define WeChatAppkey SystemDic[@"WECHATINFO"][@"WeChatAppkey"]
#endif
