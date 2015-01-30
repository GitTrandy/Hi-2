//
//  Hi_SessionTool.m
//  hihi
//
//  Created by 伍松和 on 15/1/8.
//  Copyright (c) 2015年 伍松和. All rights reserved.
//

#import "Hi_SessionTool.h"
#import "UIWindow+JJ.h"
#import "Hi_SmsTool.h"
#import "QiniuSDK.h"

@interface Hi_SessionTool(){

    
}
@property (nonatomic,strong)AVSession *session;
@property (nonatomic,strong)QNUploadManager *upManager;
@property (nonatomic,strong)id lastController;



@end

@implementation Hi_SessionTool

static id instance = nil;
//static BOOL initialized = NO;

#pragma mark -初始化
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
   
    return instance;
}

//- (id)copyWithZone:(NSZone *)zone {
//    return self;
//}

- (instancetype)init {
    if ((self = [super init])) {
        _upManager=[[QNUploadManager alloc] init];
        _session = [[AVSession alloc] init];
        _session.sessionDelegate = self;
        
    }
    return self;
}

#pragma mark - 历史纪录

- (void)getHistoryMessagesForPeerId:(NSString *)peerId callback:(AVArrayResultBlock)callback {
    AVHistoryMessageQuery *query = [AVHistoryMessageQuery queryWithFirstPeerId:_session.peerId secondPeerId:peerId];
    [query findInBackgroundWithCallback:callback];
}

- (void)getHistoryMessagesForGroup:(NSString *)groupId callback:(AVArrayResultBlock)callback {
    AVHistoryMessageQuery *query = [AVHistoryMessageQuery queryWithGroupId:groupId];
    [query findInBackgroundWithCallback:callback];
}

#pragma mark -开启/关闭会话
-(void)openSession{
//    AVUser * curuser = [AVUser currentUser];
    [_session openWithPeerId:MY_UID watchedPeerIds:nil];
  //  [_session openWithPeerId:[AVUser currentUser].username];
    NSLog(@"%@",[AVUser currentUser].username);
    //4.检测控制器
    
  
}

-(AVSession*)getSession{
    return _session;
}


#pragma mark -获取已经 watch 的用户列表
- (void)watchPeerId:(NSString *)peerId {
    NSLog(@"unwatch");
    //[_session watchedPeerIds];
    [_session watchPeerIds:@[peerId] callback:^(BOOL succeeded, NSError *error) {
        
    }];
}
//
-(void)unwatchPeerId:(NSString*)peerId{
    NSLog(@"%s",__PRETTY_FUNCTION__);
    [_session unwatchPeerIds:@[peerId] callback:^(BOOL succeeded, NSError *error) {
       
    }];
}

#pragma mark -发送消息
///发送信息到群组/单聊
- (Hi_SMSModel*)sendMessage:(Hi_SMSModel*)smsModel{

  
        NSString * objectCondition = [NSString stringWithFormat:@"objectId='%@'",smsModel.objectId];
        [Hi_SMSModel insertModelToDB:smsModel condition:objectCondition didInsertBlock:nil];    
#define QINIU_BASE_URL @"http://7u2h3g.com2.z0.glb.clouddn.com"
    
    if (smsModel.m_content_img) {
        UIImage * image=smsModel.m_content_img;
        [self upLoadImageSuccess:^(id result) {
            if (result) {
                NSData * img_data =UIImageJPEGRepresentation(image,1.0);
                NSString * token=result;
                [_upManager putData:img_data
                                key:[NSString stringWithFormat:@"%@.jpg",smsModel.objectId]
                              token:token
                           complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                               if (resp[@"name"]) {
                                   NSString * url = [NSString stringWithFormat:@"%@/%@",QINIU_BASE_URL,resp[@"name"]];
                                   smsModel.m_content_img_url=url;
                                   [self sendMsg:smsModel group:nil];

                               }

                               NSLog(@" --->> Info: %@  ", info);
                               NSLog(@" ---------------------");
                               NSLog(@" --->> Response: %@,  ", resp);
                           } option:nil];

            }
        }];
      
        
        
    }else{
            [self sendMsg:smsModel group:nil];

    }
   
    
    return smsModel;

}
-(void)upLoadImageSuccess:(HttpSuccessBlock)success{
    
    [HttpTool postWithPath:@"MM/member/qnUploadToken.action" params:nil success:^(id result) {
        if (result[@"data"]) {
            success(result[@"data"]);
        }else{
            UIWINDOW_FAILURE(@"上传失败");

        }
    } failure:^(NSError *error) {
        UIWINDOW_FAILURE(@"上传失败");
    }];
}
- (NSString *)getDateTimeString
{
    NSDateFormatter *formatter;
    NSString        *dateString;
    
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd_HH:mm:ss"];
    
    dateString = [formatter stringFromDate:[NSDate date]];
    
    return dateString;
}



-(Hi_SMSModel*)sendMsg:(Hi_SMSModel*)msg group:(AVGroup*)group{
    if([_session isOpen]==NO || [_session isPaused]){
//        [CDUtils alert:@"会话暂停，请检查网络"];
    }
    if(!group){
        AVMessage *avMsg=[AVMessage messageForPeerWithSession:_session toPeerId:msg.toPeerId payload:[msg toMessagePayload]];
        [_session sendMessage:avMsg requestReceipt:YES];
    }else{
        AVMessage *avMsg=[AVMessage messageForGroup:group payload:[msg toMessagePayload]];
        [group sendMessage:avMsg];
    }
    return msg;
}

-(void)postUpdatedMsg:(Hi_SMSModel*)msg{
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_MESSAGE_UPDATED object:msg userInfo:nil];
}

#pragma mark - AVSessionDelegate

- (void)sessionOpened:(AVSession *)session{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    NSLog(@"session:%@", session.peerId);
}

- (void)sessionPaused:(AVSession *)session {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    NSLog(@"session:%@", session.peerId);
}

- (void)sessionResumed:(AVSession *)session {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    NSLog(@"session:%@", session.peerId);
}

- (void)session:(AVSession *)session didReceiveMessage:(AVMessage *)message {
    [self didReceiveAVMessage:message group:nil];
}
#pragma mark -发送成功/失败
- (void)session:(AVSession *)session messageSendFailed:(AVMessage *)message error:(NSError *)error {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    NSLog(@"session:%@ message:%@ toPeerId:%@ error:%@", session.peerId, message.payload, message.toPeerId, error);
    [self didMessageSendFailure:message group:nil];
}

- (void)session:(AVSession *)session messageSendFinished:(AVMessage *)message {
    [self didMessageSendFinish:message group:nil];
    NSLog(@"%s", __PRETTY_FUNCTION__);
    NSLog(@"session:%@ message:%@ toPeerId:%@", session.peerId, message.payload, message.toPeerId);
}

- (void)session:(AVSession *)session didReceiveStatus:(AVPeerStatus)status peerIds:(NSArray *)peerIds {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    NSLog(@"session:%@ peerIds:%@ status:%@", session.peerId, peerIds, status==AVPeerStatusOffline?@"离线":@"在线");
    [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_SESSION_UPDATED object:@(status)];

}

- (void)sessionFailed:(AVSession *)session error:(NSError *)error {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    NSLog(@"session:%@ error:%@", session.peerId, error);
}

- (void)session:(AVSession *)session messageArrived:(AVMessage *)message{
    NSLog(@"%s",__PRETTY_FUNCTION__);
    NSLog(@"%@",message);
    [self didMessageArrived:message];
}

#pragma mark -消息发送接收(自定义函数)
-(void)didMessageSendFinish:(AVMessage*)avMsg group:(AVGroup*)group{
    Hi_SMSModel * smsModel =[Hi_SMSModel fromAVMessage:avMsg];
    smsModel.u_uid=avMsg.toPeerId;
    smsModel.status=MsgStatusSendSucceed;
    NSString * objectCondition = [NSString stringWithFormat:@"objectId='%@'",smsModel.objectId];
//    [Hi_SMSModel updateToDB:smsModel where:objectCondition];

    [Hi_SMSModel updatePropertyName:STATUS newProperty:@(MsgStatusSendSucceed) where:objectCondition];
//    [Hi_SMSModel updatePropertyName:TIMESTAMP newProperty:@(avMsg.timestamp) where:objectCondition];

   [self postUpdatedMsg:smsModel];
    
}


-(void)didMessageSendFailure:(AVMessage*)avMsg group:(AVGroup*)group{
    
    Hi_SMSModel * smsModel =[Hi_SMSModel fromAVMessage:avMsg];
    smsModel.status=MsgStatusSendFailed;
     smsModel.u_uid=avMsg.toPeerId;
    NSString * objectCondition = [NSString stringWithFormat:@"objectId='%@'",smsModel.objectId];
//    [Hi_SMSModel updateToDB:smsModel where:objectCondition];
    [Hi_SMSModel updatePropertyName:STATUS newProperty:@(MsgStatusSendFailed) where:objectCondition];
//    [Hi_SMSModel updatePropertyName:TIMESTAMP newProperty:@(avMsg.timestamp) where:objectCondition];
//    [Hi_SMSModel updatePropertyName:STATUS newProperty:@(MsgStatusSendFailed) where:objectCondition];
    [self postUpdatedMsg:smsModel];

}

-(void)didMessageArrived:(AVMessage*)avMsg{
    [Hi_SmsTool addFriendDidArrived:avMsg.fromPeerId];

//   Hi_SMSModel * smsModel =[Hi_SMSModel fromAVMessage:avMsg];
//    smsModel.status=MsgStatusSendReceived;
//    NSString * objectCondition = [NSString stringWithFormat:@"objectId='%@'",smsModel.objectId];

//    [Hi_SMSModel updatePropertyName:STATUS newProperty:@(MsgStatusSendReceived) where:objectCondition];
//    [Hi_SMSModel updatePropertyName:TIMESTAMP newProperty:@(avMsg.timestamp) where:objectCondition];
//    [Hi_SMSModel updateToDB:smsModel where:objectCondition];
//    [self postUpdatedMsg:smsModel];
    //    [CDDatabaseService updateMsgWithId:msg.objectId status:CDMsgStatusSendFailed];
    //}
}



#pragma mark - 得到当前的控制器
#define LAST_CONTROLLER @"LAST_CONTROLLER"
//#define GET_LAST_CONTROLLER   [[NSUserDefaults standardUserDefaults]objectForKey:LAST_CONTROLLER];



#pragma mark -收到消息
-(void)didReceiveAVMessage:(AVMessage*)avMsg group:(AVGroup*)group{
    NSLog(@"%s",__PRETTY_FUNCTION__);
    NSLog(@"payload=%@",avMsg.payload);
    
/*  
 {"u_sendID":"发送方UID",
 "u_head":"http://os.blog.163.com/common/ava.s?b=1&host=fei263",
 "u_name":"昵称",
 "m_content":"你会爱我吗",
 "m_type":1,
 "m_formate":1}
*/
    if ([avMsg.payload isKindOfClass:[NSNull class]]) {
        return;
    }
    UIWINDOW_FAILURE(@"有新消息");



    
    Hi_SMSModel* smsModel=[Hi_SMSModel fromAVMessage:avMsg];
    smsModel.status=MsgStatusSendReceived;
    NSString * current_ctrl_name =GET_USER_CURRENT_CTRL;
    smsModel.readStatus=[current_ctrl_name isEqualToString:@"Hi_MessageDetailController"]?MsgReadStatusHaveRead:MsgReadStatusUnread;
    NSString * objectConditionA = [NSString stringWithFormat:@"objectId='%@'",smsModel.objectId];
    NSString * objectConditionB = [NSString stringWithFormat:@"uid='%@'",smsModel.u_uid];

    [Hi_SMSModel insertModelToDB:smsModel condition:objectConditionA didInsertBlock:^{
        
        [Hi_SMSModel updatePropertyName:U_HEAD newProperty:smsModel.u_head where:nil];
        [Hi_SMSModel updatePropertyName:U_NAME newProperty:smsModel.u_name where:nil];
        [Hi_UserModel updatePropertyName:@"head" newProperty:smsModel.u_head where:objectConditionB];
        [Hi_UserModel updatePropertyName:@"nickName" newProperty:smsModel.u_name where:objectConditionB];


    }];
    NSInteger  num = [Hi_SMSModel hi_dealWithUnreadMessageNum:nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:HI_UN_READ_NUM_NOTIFICATION object:@(num)];
    [self postUpdatedMsg:smsModel];

    
    
}
-(void)resendMsg:(id)msg
        toPeerId:(NSString*)toPeerId
           group:(AVGroup*)group{}
#pragma mark -路径
+(NSString*)getPathByObjectId:(NSString*)objectId{return nil;}


@end
