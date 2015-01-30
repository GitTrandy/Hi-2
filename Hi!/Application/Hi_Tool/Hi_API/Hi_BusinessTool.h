
#import "Hi_API_CLASS.h"
#import "Hi_BusinessModel.h"
#import "Hi_LongMsgModel.h"
@interface Hi_BusinessTool : Hi_API_CLASS

+(void)getBusinessWithWifiMacSuccess:(HttpSuccessBlock)success
                             failure:(HttpFailureBlock)failure;
+(void)getBusinessWithBID:(NSString*)BID
                success:(HttpSuccessBlock)success
                  failure:(HttpFailureBlock)failure;

///0.查询商家列表
+(void)getBusinessSuccess:(HttpSuccessArrayBlock)success
                  failure:(HttpFailureBlock)failure;

///1.喜欢该店家
+(void)loveBusinessWithBID:(NSString*)BID
                   success:(HttpSuccessBlock)success
                   failure:(HttpFailureBlock)failure;

///2.取消喜欢该店家
+(void)cancelLoveBusinessWithBID:(NSString*)BID
                         success:(HttpSuccessBlock)success
                         failure:(HttpFailureBlock)failure;

///3.不喜欢该店家
+(void)unloveBusinessWithBID:(NSString*)BID
                     success:(HttpSuccessBlock)success
                     failure:(HttpFailureBlock)failure;

//4.取消不喜欢该店家
+(void)cancelUnloveBusinessWithBID:(NSString*)BID
                           success:(HttpSuccessBlock)success
                           failure:(HttpFailureBlock)failure;


#pragma mark -留言接口

///1.获取当前留言墙列表
+(void)getAllLongMessagesWithBID:(NSString*)BID
                           Start:(NSInteger)start
                             limit:(NSInteger)limit
                            Success:(HttpSuccessArrayBlock)success
                            failure:(HttpFailureBlock)failure;




/**
 *  对当前留言点赞
 *
 *  @param isPraise 是否赞
 *  @param msgID    message_id
 */
+(void)postLongMessagesPraise:(BOOL)isPraise
                       msgID:(NSInteger)msgID
                       Success:(HttpSuccessBlock)success
                       failure:(HttpFailureBlock)failure;


/**
 *  发布留言
 *
 *  @param content 内容
 *  @param imgData 数据(可以是数组,或者单个 data/img)
 */
+(void)postLongMessagesContent:(NSString*)content
                           imgData:(id)imgData
                           Success:(HttpSuccessBlock)success
                           failure:(HttpFailureBlock)failure;








@end
