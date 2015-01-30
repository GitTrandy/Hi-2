///聊天形式
typedef enum : NSUInteger {
    MsgChatTypeSingle = 0, //单聊
    MsgChatTypeGroup=1,//群聊
} MsgChatType;

///信息类型
typedef enum : NSUInteger{
    MsgTypeText=0, //文字
    MsgTypeImage=1,//图片
    MsgTypeAudio=2,//录音
    MsgTypeLocation=3,//位置
}MsgType;
///信息发送状态
typedef enum : NSUInteger{
    MsgStatusSendStart=0, //正在发送
    MsgStatusSendSucceed=1,//发送成功
    MsgStatusSendReceived=2, //接收成功
    MsgStatusSendFailed=3,//发送失败
}MsgStatus;
///未读状态
typedef enum : NSUInteger{
    MsgReadStatusHaveRead=0,
    MsgReadStatusUnread=1, //未读
     //已读
}MsgReadStaus;




typedef NS_ENUM(NSInteger, Hi_SMSDetailSendState) {
    
    Hi_SMSDetailSendStateSuccess,//发送成功
    Hi_SMSDetailSendStateing,//发送中
    Hi_SMSDetailSendStateFailure,//发送失败
};
#define U_UID @"u_uid"
#define FROM_PEER_ID @"fromPeerId"
#define TIMESTAMP @"timestamp"
#define OBJECT_ID @"objectId"
#define STATUS @"status"
#define READ_STATUS @"readStatus"


#define U_SEND_ID @"u_sendID"//发送方
#define U_ANIM_ID @"u_animID"//接收方
#define U_HEAD @"u_head"
#define U_NAME @"u_name"
#define M_TYPE @"m_type"
#define M_CONTENT @"m_content"
#define M_FORMATE @"m_formate"
#import "Hi_BaseModel.h"
@class AVMessage;
@class Hi_UserModel;
@interface Hi_SMSModel : Hi_BaseModel

///消息对应 ID,电脑自动生成
@property(nonatomic,copy) NSString* objectId;
///消息来自的用户 ID
@property(nonatomic,copy) NSString* fromPeerId;
///消息发送的用户 ID
@property(nonatomic,copy) NSString* toPeerId;
///消息时间
@property(nonatomic,assign)int64_t timestamp;
///消息内容
@property(nonatomic,copy) NSString* m_content;
///消息图片内容
@property(nonatomic,copy) NSString* m_content_img_url;
///消息静态图片内容
@property(nonatomic,strong)UIImage* m_content_img;
///对方ID
@property(nonatomic,copy) NSString* u_uid;
///对方头像
@property(nonatomic,copy) NSString* u_head;
///对方昵称
@property(nonatomic,copy) NSString* u_name;


///消息发送状态 0.正在发送 1.发送成功 2.发送失败 3.发送到达
@property(nonatomic,assign) MsgStatus status;
///消息类型 0.文本 1.图片 2.音频
@property(nonatomic,assign) MsgType m_type;
///已经读取/未读取
@property(nonatomic,assign) MsgReadStaus readStatus;
///群聊或者单聊
@property(nonatomic,assign) MsgChatType chatType;
///处理后的时间
@property (nonatomic,strong)NSString * timeRealString;


/**
 *  把字典转化为 JSON
 *
 *  @return JSON
 */
-(NSString *)toMessagePayload;
/**
 *  把 AVOS 远程消息格式转换为 Hi_SMSModel
 */
+(Hi_SMSModel*)fromAVMessage:(AVMessage *)avMsg;

- (Hi_UserModel*)getUserModelFromUID:(NSString*)UID;
#pragma mark -构建 Msg
+(Hi_SMSModel*)createMsgWithType:(MsgType)type
                           image:(UIImage*)image
                        objectId:(NSString*)objectId
                         content:(NSString*)content
                        toPeerId:(NSString*)toPeerId
                          toName:(NSString*)toName
                          toHead:(NSString*)toHead
                           group:(id)group;



#pragma mark - 处理未读
//1.处理未读
+(NSInteger)hi_dealWithUnreadMessageNum:(NSString*)uid;
+(void)hi_clearWithUnreadMessageNum:(NSString*)uid;
+(void)hi_dealWithUnreadMessage;
//2.计算最大 ID/TIME
+(NSString*)hi_sms_detail_max_time:(NSString*)uid;

#define HI_SMS_UID_CONDITION(UID) [NSString stringWithFormat:@"%@='%@'",@"u_uid",UID]
#define HI_SMS_LIST_SQL [NSString stringWithFormat:@"SELECT * FROM (SELECT * FROM  Hi_SMSModel order by timestamp) group by u_uid order by timestamp desc"]
//SELECT * FROM (SELECT * FROM  Hi_SMSModel order by timestamp) group by u_uid order by timestamp desc
//SELECT * FROM Hi_SMSModel group by %@",U_UID
@end
