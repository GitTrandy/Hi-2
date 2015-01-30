
#define NOTIFICATION_MESSAGE_UPDATED @"NOTIFICATION_MESSAGE_UPDATED" //消息更新
#define NOTIFICATION_SESSION_UPDATED @"NOTIFICATION_SESSION_UPDATED" //状态更新
#define NOTIFICATION_GROUP_UPDATED @"NOTIFICATION_GROUP_UPDATED"//群组更新

#import <Foundation/Foundation.h>
#import <AVOSCloud/AVOSCloud.h>
#import "Hi_SMSModel.h"
@interface Hi_SessionTool : NSObject<AVSessionDelegate, AVSignatureDelegate>


+ (instancetype)sharedInstance;

#pragma mark - session
- (void)watchPeerId:(NSString *)peerId;

-(void)unwatchPeerId:(NSString*)peerId;

-(void)openSession;

//-(void)closeSession;

#pragma mark - operation message

///发送信息到群组/单聊
- (Hi_SMSModel*)sendMessage:(Hi_SMSModel*)smsModel;

//-(NSDictionary*)toDatabaseDict;
///重新发送
-(void)resendMsg:(id)msg
        toPeerId:(NSString*)toPeerId
           group:(AVGroup*)group;

///
//+(NSString*)getConvidOfRoomType:(MsgChatType)roomType
//                        otherId:(NSString*)otherId
//                        groupId:(NSString*)groupId;



//+(NSString*)convidOfSelfId:(NSString*)myId
//                andOtherId:(NSString*)otherId;

//对应 Id的沙盒路径
+(NSString*)getPathByObjectId:(NSString*)objectId;

#pragma mark - 历史纪录
- (void)getHistoryMessagesForPeerId:(NSString *)peerId
                           callback:(AVArrayResultBlock)callback;

- (void)getHistoryMessagesForGroup:(NSString *)groupId
                          callback:(AVArrayResultBlock)callback;

///清除数据
//- (void)clearData;
///拿到Session
-(AVSession*)getSession;
/**
 *  当前控制
 */



@end
