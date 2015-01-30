
#import "Hi_UserTool.h"
#import "Hi_UserModel.h"
#import "Hi_SmsModel.h"
@implementation Hi_UserTool


+(void)postPaperWithReceivedId:(NSString*)ReceivedId
                       Msg:(NSString*)Msg
                          msgType:(NSString*)msgType
                   success:(HttpSuccessBlock)success
                   failure:(HttpFailureBlock)failure{
    

    NSString * fullMsg= [NSString stringWithFormat:@"%@",Msg];
    NSDictionary * param = @{@"uid": MY_UID,
                             @"rid":ReceivedId,
                             @"msg":fullMsg,
                             @"userInfo":@"accost"};
    
    [HttpTool postWithPath:@"MM/sms/accost.action" params:param success:^(id result) {
        if (!result[@"data"][@"id"]||!result) {
            success(nil);
        }else{
            NSString * ID = [NSString stringWithFormat:@"%@",result[@"data"][@"id"]];
            success(ID);
        }
       
        
    } failure:^(NSError *error) {
        failure(error);
    }];
    
}



//2.关注好友
+(void)addFriendWithFID:(NSString*)FID
                success:(HttpSuccessBlock)success
                failure:(HttpFailureBlock)failure{
    
    NSString * UID = MY_UID;
    NSDictionary * param =@{@"uid":UID,
                            @"beUID":FID};
    if ([[Hi_UserModel queryFormDB:HI_USER_MODEL_UID_SQL(FID) orderBy:nil count:1 success:nil]lastObject]) {
        return;
    }
    [HttpTool postWithPath:@"MM/friends/pay.action" params:param success:^(id result) {
        if (result) {
            success(result);
        }
    } failure:^(NSError *error) {
        failure(error);
    }];

}
//3.取消关注好友
+(void)cancelFriendWithFID:(NSString*)FID
                   success:(HttpSuccessBlock)success
                   failure:(HttpFailureBlock)failure{
    
    NSString * UID = MY_UID;
    NSDictionary * param =@{@"uid":UID,
                            @"beUID":FID};
    
    [HttpTool postWithPath:@"MM/friends/repay.action" params:param success:^(id result) {
        
        success(result);
        
    } failure:^(NSError *error) {
        
    }];
}

//4.屏蔽好友（流放）

+(void)brushFriendWithFID:(NSString*)FID
                  success:(HttpSuccessBlock)success
                  failure:(HttpFailureBlock)failure{

    NSString * UID = MY_UID;
    NSDictionary * param =@{@"uid":UID,
                            @"beUID":FID};
    [HttpTool postWithPath:@"MM/friends/brush.action" params:param success:^(id result) {
        
          success(result);
        
    } failure:^(NSError *error) {
        
    }];
}
//5.解开屏蔽

+(void)unbrushFriendWithFID:(NSString*)FID
                    success:(HttpSuccessBlock)success
                    failure:(HttpFailureBlock)failure{

    NSString * UID = MY_UID;
    NSDictionary * param =@{@"uid":UID,
                            @"beUID":FID};
    [HttpTool postWithPath:@"MM/friends/rebrush.action" params:param success:^(id result) {
        
            success(result);
        
    } failure:^(NSError *error) {
        
    }];
}


#pragma mark -10.查询指定用户信息

+(void)getMemberWithUID:(NSString*)UID
                success:(HttpSuccessBlock)success
                failure:(HttpFailureBlock)failure{
    
    //
    NSDictionary * param =@{@"id":UID,@"uid":MY_UID};
    
    [HttpTool postWithPath:@"MM/member/find.action" params:param success:^(id result) {
        if (!result[@"data"]) {
            success(nil);
        }else{
            NSDictionary * userDic = result[@"data"];
            Hi_UserModel * userModel = [[Hi_UserModel alloc]initWithDictionary:userDic];
            userModel.uid=userDic[@"mid"];
            [Hi_UserModel insertModelToDB:userModel condition:HI_USER_MODEL_UID_SQL(userModel.uid) didInsertBlock:^{
            }];
            success(userModel);
        }
       
        
    } failure:^(NSError *error) {
        
        failure(error);
    }];
    
}

#pragma mark -11.查看链接同一Wifi的未被屏刷用户列表

+(void)getWifiMembersSuccess:(HttpSuccessArrayBlock)success
                     failure:(HttpFailureBlock)failure{

    
    NSMutableDictionary * params = [NSMutableDictionary dictionaryWithDictionary:@{@"uid": MY_UID}];
    if ([UIDevice getWifiMacAddress]) {
        [params addEntriesFromDictionary:@{@"wifiMac":[UIDevice getWifiMacAddress]}];
    }
 
    
    [HttpTool getWithPath:@"MM/member/list.action" params:params  success:^(id result) {
        
        if ([result[@"data"] count]<=0) {
            success(nil);
            return;
        }
        NSArray * members = result[@"data"];
        NSMutableArray * userM =[NSMutableArray array];
        for (NSDictionary * userDic in members) {
            
            Hi_UserModel *userModel=[[Hi_UserModel alloc]initWithDictionary:userDic];
            userModel.uid=userDic[@"mid"];
            [userM addObject:userModel];
            
            
            
            success(userM);
            
        }
        

        
        
        
    } failure:^(NSError *error) {
        
        failure(error);
        
    }];
    
}
//1.获取好友列表
+(void)getFriendSuccess:(HttpSuccessArrayBlock)success
                failure:(HttpFailureBlock)failure{
    
    NSDictionary * param =@{@"uid":MY_UID,@"limit":@(20)};
//    NSMutableArray * userM =[NSMutableArray array];
    [HttpTool getWithPath:@"MM/friends/list.action" params:param success:^(id result) {
        NSArray * firendsDics = result[@"data"];
        if ([firendsDics isKindOfClass:[NSNull class]]) {
            success(nil);
            return;
        }
        [Hi_ThreadTool ES_AsyncConcurrentOperationQueueBlock:^{
            for ( NSDictionary * firendDic  in firendsDics) {
                Hi_UserModel *userModel=[[Hi_UserModel alloc]initWithDictionary:firendDic];
                userModel.uid=firendDic[@"fid"];
                
           //     NSString *sql=HI_USER_MODEL_UID_SQL(userModel.uid);
                NSString * objectConditionA = HI_USER_MODEL_UID_SQL(userModel.uid);
                NSString * objectConditionB = [NSString stringWithFormat:@"%@='%@'",U_UID,userModel.uid];
                [Hi_UserModel insertModelToDB:userModel condition:objectConditionA didInsertBlock:^{
                    
                    [Hi_UserModel updatePropertyName:@"head" newProperty:userModel.head where:objectConditionA];
                    [Hi_UserModel updatePropertyName:@"nickName" newProperty:userModel.nickName where:objectConditionA];

                    [Hi_SMSModel updatePropertyName:U_HEAD newProperty:userModel.head where:objectConditionB];
                    [Hi_SMSModel updatePropertyName:U_NAME newProperty:userModel.nickName where:objectConditionB];
                                    }];
                
              
                
                
            }
            //
            success(@[@(YES)]);
        }];
        
    } failure:^(NSError *error) {
        failure(error);
    }];
    
    
    
    //3.返回用户
    
    
    
    
    
}

#pragma mark -获取BID用户
+(void)getBID:(NSString*)BID
      success:(HttpSuccessBlock)success
      failure:(HttpFailureBlock)failure{
    
    
    NSString * UID =MY_UID;
    NSDictionary * params = @{@"uid": UID,
                              @"bid":BID
                              };
    
    [HttpTool getWithPath:@"MM/member/list.action" params:params  success:^(id result) {
        
        if (!result[@"data"]) {
            return;
        }
        NSArray * members = result[@"data"];
        NSMutableArray * userM =[NSMutableArray array];
        for (NSDictionary * userDic in members) {
            
            Hi_UserModel *userModel=[[Hi_UserModel alloc]initWithDictionary:userDic];
            userModel.uid=userDic[@"mid"];
            [userM addObject:userModel];
           
            
            
            success(userM);
            
        }
        
        
        
    } failure:^(NSError *error) {
        
        failure(error);
        
    }];
    
    
    
}
@end
