

#import "Hi_API_CLASS.h"

@interface Hi_UserTool : Hi_API_CLASS


+(void)postPaperWithReceivedId:(NSString*)ReceivedId
                           Msg:(NSString*)Msg
                       msgType:(NSString*)msgType
                       success:(HttpSuccessBlock)success
                       failure:(HttpFailureBlock)failure;

//1.获取好友列表
+(void)getFriendSuccess:(HttpSuccessArrayBlock)success
                     failure:(HttpFailureBlock)failure;


//2.关注好友
+(void)addFriendWithFID:(NSString*)FID
              success:(HttpSuccessBlock)success
              failure:(HttpFailureBlock)failure;
//3.取消关注好友
+(void)cancelFriendWithFID:(NSString*)FID
                success:(HttpSuccessBlock)success
                failure:(HttpFailureBlock)failure;

//4.屏蔽好友（流放）

+(void)brushFriendWithFID:(NSString*)FID
                success:(HttpSuccessBlock)success
                failure:(HttpFailureBlock)failure;
//5.解开屏蔽

+(void)unbrushFriendWithFID:(NSString*)FID
                  success:(HttpSuccessBlock)success
                  failure:(HttpFailureBlock)failure;


#pragma mark -10.查询指定用户信息

+(void)getMemberWithUID:(NSString*)UID
                success:(HttpSuccessBlock)success
                failure:(HttpFailureBlock)failure;



#pragma mark -11.查看链接同一Wifi的未被屏刷用户列表

+(void)getWifiMembersSuccess:(HttpSuccessArrayBlock)success
                     failure:(HttpFailureBlock)failure;

#pragma mark -12.得到同一个商家 ID 的用户列表
+(void)getBID:(NSString*)BID
      success:(HttpSuccessBlock)success
      failure:(HttpFailureBlock)failure;

@end
