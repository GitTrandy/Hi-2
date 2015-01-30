//
//  MeimeiTool.m
//  Meimei
//
//  Created by namebryant on 14-7-7.
//  Copyright (c) 2014年 com.kapple. All rights reserved.
//

#import "Hi_LoginRegisterTool.h"

@implementation Hi_LoginRegisterTool






#pragma mark -第三方注册/登录
+(void)registerMember:(Hi_Account*)account
              success:(HttpSuccessBlock)success
              failure:(HttpFailureBlock)failure
{
    
    
    [SVProgressHUD showWithStatus:@"正在登录" maskType:SVProgressHUDMaskTypeClear];

    
    NSDictionary * param = @{@"wifiMac": [UIDevice getWifiMacAddress],
                             @"driviceCode":[UIDevice getDeviceUDID],
                             @"openid":[UIDevice getDeviceUDID],
                             @"avid":[UIDevice getAVOSDeviceID],
                             @"driveType":@"ios",
                             @"type":@(1)};//};
    
    
    [HttpTool postWithPath:@"MM/member/login.action" params:param success:^(id result) {
        
        
        if (!result[@"data"]) {
          //   NSLog(@"XX:%@",result);
           
            [SVProgressHUD dismiss];
            [JDStatusBarNotification showWithStatus:@"登录失败哦,再试试看" dismissAfter:5.0 styleName:JDStatusBarStyleError];
            return;
        }
       
        success(result);
        
    } failure:^(NSError *error) {
        
        failure(error);
    }];
  
    
    

    
}
#pragma mark -手机登录
+(void)loginPhone:(Hi_Account*)account
          success:(HttpSuccessBlock)success
          failure:(HttpFailureBlock)failure{
    
    
 
    NSDictionary * param = @{@"pw":@"",
                             @"driviceCode":[UIDevice getDeviceUDID],
                             @"phone":@"",
                             @"avid":[UIDevice getAVOSDeviceID],
                             @"driveType":@"ios",
                             };
    
    [HttpTool postWithPath:@"MM/member/login.action" params:param success:^(id result) {
        
        
        if (!result[@"data"]) {
            //   NSLog(@"XX:%@",result);
            
            [SVProgressHUD dismiss];
            [JDStatusBarNotification showWithStatus:@"登录失败哦,看看帐号密码有没有错" dismissAfter:5.0 styleName:JDStatusBarStyleError];
            return;
        }
        
        success(result);
        
       
    } failure:^(NSError *error) {
        
        failure(error);
    }];

    

}
#pragma mark -绑定手机
+(void)bindPhone:(NSString*)phone
            Success:(HttpSuccessBlock)success
                failure:(HttpFailureBlock)failure{


    NSDictionary * param=@{@"phone": phone};
    [HttpTool postWithPath:@"/MM/member/sendCode.action" params:param success:^(id result) {
        
        if (!result[@"success"]) {
            return;
        }
        //id isSuccess=result[@"success"];
        success(result);
    } failure:^(NSError *error) {
        failure(error);    
    }];
    
}

#pragma mark -注册手机
+(void)registerPhoneAccount:(Hi_Account*)account
              success:(HttpSuccessBlock)success
              failure:(HttpFailureBlock)failure
{
    
    
    
  
    NSDictionary * param = @{@"wifiMac": [UIDevice getWifiMacAddress],
                             @"driviceCode":[UIDevice getDeviceUDID],
                             @"avid":[UIDevice getAVOSDeviceID],
                             @"driveType":@"ios",
                             @"pw":@"",
                             @"rppw":@"",
                             @"code":@"888888",@"phone":@""};//,};
    
    
    
    
    
        
        [HttpTool postWithPath:@"MM/member/valPhone.action" params:param success:^(id result) {
            
            //2.注册失败
            if (!result[@"data"]) {
                //   NSLog(@"XX:%@",result);
                
                [SVProgressHUD dismiss];
                [JDStatusBarNotification showWithStatus:@"手机注册失败哦,再试试看" dismissAfter:5.0 styleName:JDStatusBarStyleError];
                return;
            }
            //3.注册成功
            success(result);
        } failure:^(NSError *error) {
           
            //注册失败
             failure(error);
            [SVProgressHUD dismiss];
            [JDStatusBarNotification showWithStatus:@"手机注册失败哦,再试试看" dismissAfter:5.0 styleName:JDStatusBarStyleError];
            return;
           

        
            
        }];
        
    
    
    
}
#pragma mark -更新WIFI
+(void)updateUserWifiSuccess:(HttpSuccessBlock)success
                     failure:(HttpFailureBlock)failure{

  //  Account * account=[AccountTool getCurrentAccount];
 

    NSDictionary * param = @{@"wifiMac": [UIDevice getWifiMacAddress],
                             @"driviceCode":[UIDevice getAVOSDeviceID],
                             @"avid":[UIDevice getDeviceUDID],
                             @"driveType":@"ios",
                             @"uid":MY_UID};
    
    [HttpTool postWithPath:@"MM/member/changeWifi.action" params:param success:^(id result) {
        
        if (!result[@"success"]) {
            [JDStatusBarNotification showWithStatus:@"现场WIFI更新失败哦,下拉一下" dismissAfter:5.0 styleName:JDStatusBarStyleError];
            return;
        }
        
        success(result);
    } failure:^(NSError *error) {
        
         failure(error);
        [SVProgressHUD dismiss];
        return;
       
    }];
    
    
    
}

#pragma mark -通讯录
+(void)getContact:(NSString*)contacts
  RegisterSuccess:(HttpSuccessBlock)success
          failure:(HttpFailureBlock)failure{

    NSString * UID =[[NSUserDefaults standardUserDefaults]objectForKey:@"UID"];
    NSDictionary * param =@{@"uid": UID,
                               @"phones":contacts};
    
    
    
    [HttpTool postWithPath:@"MM/member/checkPhone.action" params:param success:^(id result) {
        //
        if (!result[@"success"]) {
            return;
        }
        success(result);
        
    } failure:^(NSError *error) {
        //
        failure(error);

    }];
    
    

}
@end
