//
//  MMSmsTool.m
//  Meimei
//
//  Created by namebryant on 14-7-27.
//  Copyright (c) 2014年 Meimei. All rights reserved.
//

#import "Hi_SmsTool.h"
#import "Hi_UserTool.h"

@implementation Hi_SmsTool


+(void)getSMSTimeWith:(NSString*)timestamp
               WithID:(NSInteger)ID
              success:(HttpSuccessBlock)success
              failure:(HttpFailureBlock)failure{

    //0.构建参数
    NSMutableDictionary * params = [NSMutableDictionary dictionaryWithObject:MY_UID forKey:@"uid"];
    if (timestamp) {
        [params addEntriesFromDictionary:@{@"time":timestamp}];
    }
    if (ID!=0) {
        [params addEntriesFromDictionary:@{@"ID":@(ID)}];

    }
    
    [params addEntriesFromDictionary:@{@"limit":@(100)}];
    
    //1.发送请求
    [HttpTool postWithPath:@"MM/sms/list.action" params:params
                   success:^(id result) {
        
                       
     if (!result||!result[@"data"]) {
           success(nil);
           return;
        }
        //2.有数据,解析并且插入数据库
     [Hi_ThreadTool ES_AsyncConcurrentOperationQueueBlock:^{
       for (NSDictionary * dic in result[@"data"]) {
//           Hi_SMSModel * sms=[[Hi_SMSModel alloc]initWithDictionary:dic];
//           sms.ID=[dic[@"id"] integerValue];
//           sms.self_id=MY_UID;
//           sms.his_head=dic[@"head"];
//           [Hi_SMSModel insertSMSToDB:sms];
           
       }
         
         //2.推送未读数字
          NSInteger un_read_num = [Hi_SMSModel hi_dealWithUnreadMessageNum:nil];
         [[NSNotificationCenter defaultCenter]postNotificationName:HI_UN_READ_NUM_NOTIFICATION object:@(un_read_num) userInfo:nil];
         
         success(@(YES));
   }];
  
      
      
    } failure:^(NSError *error) {
        //3.网络异常
        failure(error);
    }];
    


}

#pragma mark -用户间的对话
+(void)getUserSMS:(NSString*)sendID
         TimeWith:(NSString*)timestamp
           WithID:(NSInteger)ID
          success:(HttpSuccessBlock)success
          failure:(HttpFailureBlock)failure{

    //0.构建参数
    NSMutableDictionary * params = [NSMutableDictionary dictionaryWithDictionary:@{@"uid":MY_UID,
                                                                                   @"mid":sendID}];
                                    
    if (timestamp) {
        [params addEntriesFromDictionary:@{@"time":timestamp}];
    }
    if (ID) {
        [params addEntriesFromDictionary:@{@"ID":@(ID)}];
        
    }
    
    [HttpTool postWithPath:@"MM/sms/find.action" params:params
                   success:^(id result) {
             
         //1.没有数据就结束
         if (!result||!result[@"data"]||[result[@"data"] count]==0) {
             success(nil);
             return;
         }
           //2.有数据,解析并且插入数据库
       [Hi_ThreadTool ES_AsyncConcurrentOperationQueueBlock:^{
           for (NSDictionary * dic in result[@"data"]) {
               Hi_SMSModel * smsDetail=[[Hi_SMSModel alloc]initWithDictionary:dic];
               
               //
           }
           success(@(YES));
       }];
           
       
       


                       
     } failure:^(NSError *error) {
              failure(error);
       }];
    

}
+(void)addFriendDidArrived:(NSString*)uid{
    
    [Hi_UserTool addFriendWithFID:uid success:^(id result) {
        [Hi_UserTool getMemberWithUID:uid success:^(id result) {
            //
        } failure:^(NSError *error) {
            UIWINDOW_FAILURE(@"添加好友失败");
            
        }];
    } failure:^(NSError *error) {
        UIWINDOW_FAILURE(@"添加好友失败");
    }];
}
@end
