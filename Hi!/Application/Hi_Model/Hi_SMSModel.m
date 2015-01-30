#import "Hi_SMSModel.h"
#import "Hi_SMSTool.h"
#import "Hi_UserTool.h"
#import "Hi_AccountTool.h"
@implementation Hi_SMSModel

#pragma mark -发送消息-转换
/*
 {"u_sendID":"发送方UID",
 "u_head":"http://os.blog.163.com/common/ava.s?b=1&host=fei263",
 "u_name":"昵称",
 "m_content":"你会爱我吗",
 "m_type":1,
 "m_formate":1}
 */
-(NSDictionary*)toMessagePayloadDict{
    if(_m_content==nil || _objectId==nil){
        // [NSException raise:@"null pointer exception" format:nil];
    }
   
//    Hi_UserModel * userModel = [self getUserModelFromUID:self.u_uid];
    Hi_Account * account = [Hi_AccountTool getCurrentAccount];
    if (account) {
        NSMutableDictionary * dic =[NSMutableDictionary dictionaryWithDictionary: @{OBJECT_ID:_objectId,
                                                                                    M_TYPE:@(_m_type),
                                                                                    U_SEND_ID:MY_UID,
                                                                                    U_ANIM_ID:_u_uid,
                                                                                    U_HEAD:account.Head,
                                                                                    M_FORMATE:@(_m_type),
                                                                                    U_NAME:account.NickName}];
       
        
        if (_m_type==0) {
           [dic addEntriesFromDictionary:@{ M_CONTENT:_m_content}];
        }
        if (_m_type==1) {
            [dic addEntriesFromDictionary:@{ M_CONTENT:_m_content_img_url}];
        }
        return dic;
    }else{
        return nil;
    }
   
}

#pragma mark -字典->JSON
-(NSString *)toMessagePayload{
    NSDictionary* dict=[self toMessagePayloadDict];
    NSError* error=nil;
    NSData *data=[NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
    NSString *payload=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return payload;
}

#pragma mark -收到消息-转换
+(Hi_SMSModel*)fromAVMessage:(AVMessage *)avMsg{


    NSString *payload=[avMsg payload];
    NSData *data=[payload dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error=nil;
    NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if(error||!dict){
        return nil;
        // [NSException raise:@"json deserialize error" format:nil];
    }
    
    Hi_SMSModel* msg=[[Hi_SMSModel alloc] init];
    msg.fromPeerId=avMsg.fromPeerId;
    msg.toPeerId=avMsg.toPeerId;
    msg.timestamp=avMsg.timestamp;
    msg.m_type=(MsgType)[dict[M_TYPE] intValue];
    if (msg.m_type==MsgTypeText) {
        msg.m_content=dict[M_CONTENT];
    }else{
        msg.m_content_img_url=dict[M_CONTENT];
    }
    msg.objectId=dict[OBJECT_ID];
    msg.u_head=dict[U_HEAD];
    msg.u_name=dict[U_NAME];
    msg.u_uid=avMsg.fromPeerId;

    
    return msg;
}
#pragma mark -构建 Msg
+(Hi_SMSModel*)createMsgWithType:(MsgType)type
                           image:(UIImage*)image
                        objectId:(NSString*)objectId
                         content:(NSString*)content
                        toPeerId:(NSString*)toPeerId
                          toName:(NSString*)toName
                          toHead:(NSString*)toHead
                           group:(AVGroup*)group{
    
    //0.content 是 json 或者字符,先转换
    
    //1.创建 smsModel ID-内容
    Hi_SMSModel * smsModel = [[Hi_SMSModel alloc]init];
    smsModel.objectId=[self msg_custom_id];
    if (content.length>0&&content) {
        smsModel.m_content=content;
        smsModel.m_type=MsgTypeText;
    }else{
        smsModel.m_content_img=image;
        smsModel.m_type=MsgTypeImage;
        
    }
    //2.发送者/自己
    smsModel.u_uid=toPeerId;
    smsModel.toPeerId=toPeerId;
    smsModel.u_name=toName;
    smsModel.u_head=toHead;
    smsModel.fromPeerId=MY_UID;
    //3.
    //4.未读
    smsModel.readStatus= MsgReadStatusHaveRead;
    //5.发送状态
    smsModel.status=MsgStatusSendStart;
    //6.
    smsModel.timestamp = [[NSDate getTimeStampLong:[NSDate date]]longLongValue];
    
    NSLog(@"时间:%@",[smsModel timeRealString]);
    return smsModel;
    
    //6.加密
    //    msg.convid=[CDSessionManager getConvidOfRoomType:msg.roomType otherId:msg.toPeerId groupId:group.groupId];
    //    if(!group){
    //        smsModel.toPeerId=toPeerId;
    //        smsModel.chatType=MsgChatTypeSingle;
    //    }else{
    //        smsModel.chatType=MsgChatTypeGroup;
    //        smsModel.toPeerId=@"";
    //    }
    
}
+(NSString*)msg_custom_id{
    NSString *chars=@"abcdefghijklmnopgrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    assert(chars.length==62);
    int len=(int)chars.length;
    NSMutableString* result=[[NSMutableString alloc] init];
    for(int i=0;i<24;i++){
        int p=arc4random_uniform(len);
        NSRange range=NSMakeRange(p, 1);
        [result appendString:[chars substringWithRange:range]];
    }
    return result;
}
-(NSDate*)getTimestampDate{
    return [NSDate dateWithTimeIntervalSince1970:_timestamp/1000];
}
-(NSString *)timeRealString{
    return [NSDate compareCurrentTime:[self getTimestampDate]];
}
- (Hi_UserModel*)getUserModelFromUID:(NSString*)UID{
    
    NSString * user_single_sql = HI_USER_MODEL_UID_SQL(self.u_uid);
   __block Hi_UserModel * userModel = [[Hi_UserModel queryFormDB:user_single_sql orderBy:nil count:1 success:nil] lastObject];
    if (!userModel) {
        [Hi_UserTool getMemberWithUID:UID success:^(id result) {
            if (result) {
                userModel=result;
            }
        } failure:^(NSError *error) {
           
        }];
    }
    return userModel;
}



#pragma mark -处理未读
+(void)hi_dealWithUnreadMessage{
    
    [Hi_ThreadTool ES_AsyncConcurrentOperationQueueBlock:^{
            NSInteger sum =[Hi_SMSModel hi_dealWithUnreadMessageNum:nil];
        [[NSNotificationCenter defaultCenter]postNotificationName:HI_UN_READ_NUM_NOTIFICATION object:@(sum)];
    }];
}
+(void)hi_clearWithUnreadMessageNum:(NSString*)uid{
    
    [Hi_ThreadTool ES_AsyncConcurrentOperationQueueBlock:^{
        NSString * where = HI_SMS_UID_CONDITION(uid);
        [Hi_SMSModel updatePropertyName:READ_STATUS newProperty:@(MsgReadStatusHaveRead) where:where];
        [self hi_dealWithUnreadMessage];
    }];
    
}
+(NSInteger)hi_dealWithUnreadMessageNum:(NSString*)uid{
    
    
    NSString * sql =nil;
    if (uid) {
        sql=[NSString stringWithFormat:@"select sum(%@) from Hi_SMSModel WHERE %@ ='%@' AND %@ !='%@'",READ_STATUS,U_UID,uid,FROM_PEER_ID,MY_UID];
    }else{
        sql=[NSString stringWithFormat:@"select sum(%@) from Hi_SMSModel WHERE %@ !='%@'",READ_STATUS,FROM_PEER_ID,MY_UID];

    }
    return [Hi_SMSModel querySum:sql LKDBHelper:[Hi_BaseModel getUsingLKDBHelper]];
    
}
+(NSInteger)querySum:(NSString*)sql
          LKDBHelper:(LKDBHelper*)helper{
    
    
    __block NSInteger sum=0;
    [helper executeDB:^(FMDatabase *db) {
        int count=[db intForQuery:sql];
        sum=count;
    }];
    
    return sum;
}

+(NSString*)hi_sms_detail_max_time:(NSString*)uid{
    
    //1.SQL
    NSString * sql =[NSString stringWithFormat:@"select max(%@) from  Hi_SMSModel",TIMESTAMP];
    if (uid) {
        sql = [NSString stringWithFormat:@"select max(%@) from  Hi_SMSModel where %@ = '%@'",TIMESTAMP,U_UID,uid];
    }
    __block NSString* max_time=nil;
    [[Hi_BaseModel getUsingLKDBHelper] executeDB:^(FMDatabase *db) {
        NSString* _max_time=[db stringForQuery:sql];
        max_time=_max_time;
    }];
    
    return max_time;
}
@end
