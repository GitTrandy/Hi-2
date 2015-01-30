//
//  MMBusinessTool.m
//  Meimei
//
//  Created by namebryant on 14-7-14.
//  Copyright (c) 2014年 Meimei. All rights reserved.
//



#import "Hi_BusinessTool.h"

@implementation Hi_BusinessTool
+(void)getBusinessWithWifiMacSuccess:(HttpSuccessBlock)success
                  failure:(HttpFailureBlock)failure{
    
    NSDictionary * param =@{@"wifiMac":[UIDevice getWifiMacAddress]};
    
    [HttpTool getWithPath:@"MM/business/find.action" params:param success:^(id result) {
        
        if (!result[@"success"]) {
            success(nil);
            return;
        }
        NSDictionary * businessDic = result[@"data"];
        Hi_BusinessModel * business = [[Hi_BusinessModel alloc]initWithDictionary:businessDic];
        success(business);
        
    } failure:^(NSError *error) {
        
        failure(error);
        
    }];
    
    
}

+(void)getBusinessWithBID:(NSString*)BID
                  success:(HttpSuccessBlock)success
                  failure:(HttpFailureBlock)failure{
    
     NSDictionary * param =@{@"id":BID};
    
    [HttpTool getWithPath:@"MM/business/find.action" params:param success:^(id result) {
        
        if (!result[@"success"]) {
            success(nil);
            return;
        }
        NSDictionary * businessDic = result[@"data"];
        Hi_BusinessModel * business = [[Hi_BusinessModel alloc]initWithDictionary:businessDic];
        success(business);
        
    } failure:^(NSError *error) {
        
        failure(error);
        
    }];


}

+(void)getBusinessSuccess:(HttpSuccessArrayBlock)success
                  failure:(HttpFailureBlock)failure{

    
    NSDictionary * params = @{@"uid": MY_UID};
    
    [HttpTool getWithPath:@"MM/business/list.action" params:params  success:^(id result) {
        
        
        if (!result[@"data"]) {
            success(nil);
            return;
            
        }
        NSArray * businesses = result[@"data"];
        NSMutableArray * businessM =[NSMutableArray array];
        for (NSDictionary * businessDic in businesses) {
            Hi_BusinessModel * business = [[Hi_BusinessModel alloc]initWithDictionary:businessDic];
            business.bid=businessDic[@"id"];
            [businessM addObject:business];
            
        }
        success(businessM);
        
    } failure:^(NSError *error) {
        
        failure(error);
        
    }];

}

//1.喜欢该店家
+(void)loveBusinessWithBID:(NSString*)BID
                   success:(HttpSuccessBlock)success
                   failure:(HttpFailureBlock)failure{

    NSDictionary * param =@{@"uid":MY_UID,
                            @"bid":BID};
    [HttpTool postWithPath:@"MM/business/love.action" params:param success:^(id result) {
        
          success(result);
        
    } failure:^(NSError *error) {
        
    }];

}

//2.取消喜欢该店家
+(void)cancelLoveBusinessWithBID:(NSString*)BID
                         success:(HttpSuccessBlock)success
                         failure:(HttpFailureBlock)failure{

    NSDictionary * param =@{@"uid":MY_UID,
                            @"bid":BID};
    [HttpTool postWithPath:@"MM/business/cancellove.action" params:param success:^(id result) {
        
         success(result);
        
    } failure:^(NSError *error) {
        
    }];
}

//3.不喜欢该店家
+(void)unloveBusinessWithBID:(NSString*)BID
                     success:(HttpSuccessBlock)success
                     failure:(HttpFailureBlock)failure{

    NSDictionary * param =@{@"uid":MY_UID,
                            @"bid":BID};
    [HttpTool postWithPath:@"MM/business/unlove.action" params:param success:^(id result) {
        
       success(result);
        
    } failure:^(NSError *error) {
        
    }];
}

//4.取消不喜欢该店家
+(void)cancelUnloveBusinessWithBID:(NSString*)BID
                           success:(HttpSuccessBlock)success
                           failure:(HttpFailureBlock)failure{

    NSDictionary * param =@{@"uid":MY_UID,
                            @"bid":BID};
    [HttpTool postWithPath:@"MM/business/cancelUnlove.action" params:param success:^(id result) {
        
          success(result);
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark -留言墙相关
///5.获取当前留言墙列表
+(void)getAllLongMessagesWithBID:(NSString*)BID
                           Start:(NSInteger)start
                             limit:(NSInteger)limit
                           Success:(HttpSuccessArrayBlock)success
                           failure:(HttpFailureBlock)failure{


    NSMutableDictionary * params = [NSMutableDictionary dictionaryWithDictionary:@{@"uid":MY_UID,
                                                                                   @"start":@(start),
                                                                                    @"limit":@(limit)}];

//    if
    if ([UIDevice getWifiMacAddress]) {
        [params addEntriesFromDictionary:@{@"wifiMac":[UIDevice getWifiMacAddress]}];
    }
    if (BID) {
        [params addEntriesFromDictionary:@{@"bid":BID}];

    }
 
    [HttpTool getWithPath:@"MM/business/wmList.action" params:params success:^(id result) {
        if (!result[@"data"]) {
            success(nil);
            return;
            
        }
        NSArray * msgs = result[@"data"];
        NSMutableArray * msgM =[NSMutableArray array];
        for (NSDictionary * msgDic in msgs) {
            Hi_LongMsgModel * longMessage = [[Hi_LongMsgModel alloc]initWithDictionary:msgDic];
            longMessage.ID=[msgDic[@"id"] integerValue];
            longMessage.isLike=[msgDic[@"type"] boolValue];
            [msgM addObject:longMessage];
            
        }
        success(msgM);
    } failure:^(NSError *error) {
        failure(error);
    }];

}
/**
 *  对当前留言点赞
 *
 *  @param isPraise 是否赞
 *  @param msgID    message_id
 */
+(void)postLongMessagesPraise:(BOOL)isPraise
                        msgID:(NSInteger)msgID
                      Success:(HttpSuccessBlock)success
                      failure:(HttpFailureBlock)failure{
    
    NSDictionary * params = nil;
    if (!msgID) {
        return;
    }
    params=@{@"uid":MY_UID,
             @"mwID":@(msgID),
             @"type":@(isPraise)};
    [HttpTool postWithPath:@"MM/business/praise.action" params:params success:^(id result) {
        if (!result[@"success"]) {
            success(nil);
            UIWINDOW_FAILURE(@"点赞失败");
            return;
        }else {
        
            NSString * tip = isPraise?@"点赞成功":@"取消点赞成功";
            UIWINDOW_SUCCESS(tip);

        }
        success(result);
        
    } failure:^(NSError *error) {
        UIWINDOW_FAILURE(@"点赞失败");
        failure(error);
    }];

}


/**
 *  发布留言
 *
 *  @param content 内容
 *  @param imgData 数据(可以是数组,或者单个 data/img)
 */
+(void)postLongMessagesContent:(NSString*)content
                       imgData:(id)imgData
                       Success:(HttpSuccessBlock)success
                       failure:(HttpFailureBlock)failure{
    
    
//    if (![imgData isKindOfClass:[UIImage class]]) {
//        return;
//    }
    if (![UIDevice getWifiMacAddress]) {
        return;
    }
    NSDictionary * parmas = @{@"uid":MY_UID,
                              @"wifiMac":[UIDevice getWifiMacAddress],//@"00:25:86:75:1c:04"
                              @"content":content};
    
    if (!imgData) {
        //1.有图片
        [HttpTool postWithPath:@"MM/business/subWM.action" params:parmas success:^(id result) {
            if (!result[@"success"]) {
                success(nil);
                return;
            }
            success(result);
        } failure:^(NSError *error) {
            failure(error);
            
        }];
    }else{
        //2.没有图片
        [HttpTool upLoadimage:imgData path:@"MM/business/subWM.action" param:parmas imageKey:@"img"  success:^(id result) {
            if (!result[@"success"]) {
                success(nil);
                return;
            }
            success(result);
        } failure:^(NSError *error) {
            failure(error);
            
        }];
    }
    
    
    
  
    
    


}

@end
