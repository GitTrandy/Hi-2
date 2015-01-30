#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "Hi_API_CLASS.h"
#import "Hi_AccountTool.h"
#import "Hi_UserTool.h"
#import "Hi_BusinessTool.h"
#import "Hi_CouponsTool.h"
#import "Hi_SmsTool.h"
#import "Hi_ThreadTool.h"


@interface Hi_LoginRegisterTool : NSObject



#pragma mark 网络部分

+(void)bindPhone:(NSString*)phone
         Success:(HttpSuccessBlock)success
         failure:(HttpFailureBlock)failure;
//注册
+(void)registerMember:(Hi_Account*)account
              success:(HttpSuccessBlock)success
              failure:(HttpFailureBlock)failure;

+(void)registerPhoneAccount:(Hi_Account*)account
                    success:(HttpSuccessBlock)success
                    failure:(HttpFailureBlock)failure;

+(void)loginPhone:(Hi_Account*)account
              success:(HttpSuccessBlock)success
              failure:(HttpFailureBlock)failure;

#pragma mark - 更新wifiMac
+(void)updateUserWifiSuccess:(HttpSuccessBlock)success
                        failure:(HttpFailureBlock)failure;




#pragma mark -获取通讯录
+(void)getContact:(NSString*)contacts
                RegisterSuccess:(HttpSuccessBlock)success
                 failure:(HttpFailureBlock)failure;

//

#pragma mark -本地


@end
