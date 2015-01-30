
#import "Hi_AccountTool.h"
#import "Hi_Account.h"
#import "Hi_RootControllerTool.h"
#import "WeiboSDK.h"
#import <TencentOpenAPI/TencentOAuth.h>
@implementation Hi_AccountTool

#pragma mark -本地操作
#pragma mark -得到系统帐号
+(Hi_Account*)getCurrentAccount{
    
    NSData * accountData = [[NSUserDefaults standardUserDefaults]objectForKey:@"account"];
    Hi_Account * account =(Hi_Account*) [NSKeyedUnarchiver unarchiveObjectWithData:accountData];
    
    return account;
}
#pragma mark -保存系统帐号
+(void)saveCurrentAccount:(Hi_Account*)account{
    
    NSData * accountData = [NSKeyedArchiver archivedDataWithRootObject:account];
    [[NSUserDefaults standardUserDefaults]setObject:accountData forKey:@"account"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
}

#pragma mark -登录同步到服务器
+(void)loginWithType:(LOGINType)type{
    
    
    if (type==AVOSCloudSNSQQ){
        
        if (![TencentOAuth iphoneQQInstalled]) {
            [UIWindow dismissWithHUD];

        }
        [AVOSCloudSNS setupPlatform:AVOSCloudSNSQQ withAppKey:QQAppKey andAppSecret:QQAppSecret andRedirectURI:nil];
        
    }else if (type==AVOSCloudSNSSinaWeibo){
        
        if (![WeiboSDK isWeiboAppInstalled]) {
            [UIWindow dismissWithHUD];
        }
        [AVOSCloudSNS setupPlatform:AVOSCloudSNSSinaWeibo withAppKey:SinaAppkey andAppSecret:SinaAppSecret andRedirectURI:SinaRedirectURI];
        
    }else{
        
        return;
    }
    
    //登录AVOS服务器
    [AVOSCloudSNS loginWithCallback:^(id object, NSError *error) {
        if (!object||error) {
            [UIWindow dismissWithHUD];
            return;
        }
        NSLog(@"返回数据:%@",object);
        NSString * accessToken = nil;
        if (type==AVOSCloudSNSSinaWeibo) {
            accessToken=object[@"accessToken"];
        }else{
            accessToken=object[@"access_token"];
        }
        [Hi_AccountTool saveAccount:object accessToken:accessToken type:type];
        
        
        
        
    } toPlatform:(AVOSCloudSNSType)type];
    
    
    
    
    
}

#pragma mark -保存在本地

+(void)saveAccountToSystem:(NSDictionary*)dic
                 SavedType:(AccountSaveType)type{
    
    
    
    SAVE_MY_UID(dic[@"mid"]);
    
    
    
    Hi_Account * account= [[Hi_Account alloc]init];
    account.Head=dic[@"head"];
    account.Note=dic[@"note"];
    account.NickName=dic[@"nickName"];
    account.Phone=dic[@"phone"];
    account.CurrentState=dic[@"currentState"];
    
    if (![account.Head isKindOfClass:[NSNull class]]) {
        account.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:account.Head]]];
    }else{
        account.image=[UIImage imageNamed:@"cantoon_004"];
    }
    NSLog(@"UID:%@",MY_UID);
    [Hi_AccountTool saveCurrentAccount:account];
    
    //
    
    //2.正常
    if ([AVUser currentUser]) {
        //3.远程服务器有数据
        [self jumpToRoot:type];

        
    }else{
        //4.注册
        [self registerByAvosWithUserID:MY_UID success:^(id result) {
            [self jumpToRoot:type];

        } failure:^(NSError *error) {
            UIWINDOW_FAILURE(@"服务器异常");
            
        }];
    }

    
    
}
+(void)jumpToRoot:(AccountSaveType)type{
    [JDStatusBarNotification showWithStatus:@"登录成功" dismissAfter:2.0 styleName:JDStatusBarStyleSuccess];
    
    switch (type) {
        case AccountSaveTypePhoneRegiters:
            [[Hi_RootControllerTool sharedHi_RootControllerTool] chooseRootController:Hi_RootControllerHelperStyleAfterLoginResgiter];
            break;
        case AccountSaveTypeThreeRegiters:
            [[Hi_RootControllerTool sharedHi_RootControllerTool] chooseRootController:Hi_RootControllerHelperStyleAfterLoginResgiter];
            break;
        case AccountSaveTypeThreeLogin:
            [[Hi_RootControllerTool sharedHi_RootControllerTool] chooseRootController:Hi_RootControllerHelperStyleMain];
            break;
        case AccountSaveTypePhoneLogin:
            [[Hi_RootControllerTool sharedHi_RootControllerTool] chooseRootController:Hi_RootControllerHelperStyleMain];
            break;
            
        default:
            break;
    }
    
    Hi_SessionTool *ss=[Hi_SessionTool sharedInstance];
    [ss openSession];
    
}

#pragma mark -保存登录后系统帐号
+(void)saveAccount:(id)data
           accessToken:(NSString*)accessToken
                  type:(LOGINType)type{
    
    
    Hi_Account * account= [[Hi_Account alloc]init];
    
   // [UIWindow showWithHUDStatus:@"正在登录"];

//    [SVProgressHUD showWithStatus:@"正在登录" maskType:SVProgressHUDMaskTypeClear];
    
    
    if (type==AVOSCloudSNSQQ) {
        
        
        NSDictionary *QQUserInfo=(NSDictionary*)data;
//        account.NickName = QQUserInfo[@"username"];
        account.openid =QQUserInfo[@"id"];
        //头像
        NSDictionary * rawDic=QQUserInfo[@"raw-user"];
//        account.Head =QQUserInfo[@"avatar"];//figureurl_qq_2//figureurl_2
        account.sex=rawDic[@"gender"];
        NSData * data =[NSData dataWithContentsOfURL:[NSURL URLWithString:account.Head]];
        account.image=[UIImage imageWithData:data];
        [Hi_AccountTool saveCurrentAccount:account];
        
        //这个不行
        
        
    }else if (type==AVOSCloudSNSSinaWeibo){
        
        NSDictionary *weiboInfo=(NSDictionary*)data;
        account.NickName = weiboInfo[@"username"];
        account.openid=weiboInfo[@"id"];
        //头像
        account.Head =weiboInfo[@"avatar"];//figureurl_qq_2//avatar_hd
        NSData * data =[NSData dataWithContentsOfURL:[NSURL URLWithString:account.Head]];
        account.image=[UIImage imageWithData:data];
        //2.字典
        NSDictionary * rawDic=weiboInfo[@"raw-user"];
        account.Sex =rawDic[@"gender"];
        account.CurrentState=rawDic[@"description"];
         [Hi_AccountTool saveCurrentAccount:account];
        
        
        
        
    }else if (type==0){
        
        NSDictionary *phoneInfo=(NSDictionary*)data;
        account.phone=phoneInfo[@"phone"];
        account.NickName=phoneInfo[@"nickName"];
        [Hi_AccountTool saveCurrentAccount:account];
        
        
     
        
    }
    
    
    [self loginThreePartyAccount:account Success:^(id result) {
        
        if (result) {
            [Hi_AccountTool saveAccountToSystem:result SavedType:AccountSaveTypeThreeRegiters];
            UIWINDOW_SUCCESS(@"登录成功");}

    } failure:^(NSError *error) {
        UIWINDOW_FAILURE(@"登录失败");
    }];
}
#pragma mark -0.AVOS 服务

#pragma mark - 用 AVOS 注册
+(void)registerByAvosWithUserID:(NSString*)UID
             success:(HttpSuccessBlock)success
              failure:(HttpFailureBlock)failure{
    
    AVUser *user = [AVUser user];
    user.username = UID;
    user.password = @"888888";
    [user setFetchWhenSave:YES];
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        [user refreshInBackgroundWithBlock:^(AVObject *object, NSError *error) {
            if (object) {
                //Login success
                success(object);
            } else {
                
                failure(error);
                
            }
            
        }];
    }];

}
#pragma mark - 用 AVOS 登录
+(void)LoginByAvosWithUserID:(NSString*)UID
                        success:(HttpSuccessBlock)success
                     failure:(HttpFailureBlock)failure{

    [AVUser logInWithUsernameInBackground:UID password:@"888888" block:^(AVUser *user, NSError *error) {
        if (user) {
            //Login success
            success(user);
        } else {
            
            failure(error);
         
        }
    }];

}
#pragma mark -1.手动注册用户
+(void)registerPhone:(NSString*)phone
            password:(NSString*)password
                    success:(HttpSuccessBlock)success
                    failure:(HttpFailureBlock)failure
{
    
    NSMutableDictionary * params =[NSMutableDictionary dictionaryWithDictionary:@{@"driviceCode":[UIDevice getDeviceUDID],
                                                                                  @"driveType":@"ios",
                                                                                  @"pw":password,
                                                                                  @"rppw":password,
                                                                                  @"code":@"888888",
                                                                                  @"phone":phone}];
    
    if ([UIDevice getAVOSDeviceID]) {
        [params addEntriesFromDictionary:@{@"avid":[UIDevice getAVOSDeviceID]}];
    }if ([UIDevice getWifiMacAddress]) {
        [params addEntriesFromDictionary:@{@"wifiMac":[UIDevice getWifiMacAddress]}];

    }
    [HttpTool postWithPath:@"MM/member/valPhone.action" params:params success:^(id result) {
        
        //2.注册失败
        if (result[@"data"]) {
            success(result);
        }else{
             success(nil);
        }
        //3.注册成功
    } failure:^(NSError *error) {
        //注册失败
        failure(error);
 
    }];
    
    
    
    
}
#pragma mark -2.手动登录
+(void)loginPhone:(NSString*)phone
            password:(NSString*)password
             success:(HttpSuccessBlock)success
             failure:(HttpSuccessBlock)failure
{
   
    NSMutableDictionary * params =[NSMutableDictionary dictionaryWithDictionary:@{@"driviceCode":[UIDevice getDeviceUDID],
                                                                                  @"driveType":@"ios",
                                                                                  @"pw":password,
                                                                                  @"phone":phone}];
    
    if ([UIDevice getAVOSDeviceID]) {
        [params addEntriesFromDictionary:@{@"avid":[UIDevice getAVOSDeviceID]}];
    }if ([UIDevice getWifiMacAddress]) {
        [params addEntriesFromDictionary:@{@"wifiMac":[UIDevice getWifiMacAddress]}];
        
    }
    
    
    [HttpTool postWithPath:@"MM/member/login.action" params:params success:^(id result) {
        
        //2.注册失败
        if (result[@"data"]) {
            success(result);
        }else{
            success(nil);
        }
        //3.注册成功
    } failure:^(NSError *error) {
        //注册失败
        failure(error);
        
    }];
    
    
    
    
}
#pragma mark -3.第三方注册.登录
+(void)loginThreePartyAccount:(Hi_Account*)account
                     Success:(HttpSuccessBlock)success
                     failure:(HttpFailureBlock)failure{
    
    NSMutableDictionary * params =[NSMutableDictionary dictionaryWithDictionary:@{@"openid":account.openid,
                                                                                  @"driviceCode":[UIDevice getDeviceUDID],
                                                                                  @"driveType":@"ios",
                                                                                  @"type":@"1",
                                                                                  @"nickname":account.NickName?account.NickName:@"请填写",
                                                                                  @"gender":@"1",
                                                                                  @"figureurl":account.Head?account.Head:@""}];
    
    if ([UIDevice getAVOSDeviceID]) {
        [params addEntriesFromDictionary:@{@"avid":[UIDevice getAVOSDeviceID]}];
    }if ([UIDevice getWifiMacAddress]) {
        [params addEntriesFromDictionary:@{@"wifiMac":[UIDevice getWifiMacAddress]}];
        
    }
    
    [HttpTool postWithPath:@"MM/member/login.action" params:params success:^(id result) {
        
       
        if (!result[@"data"]) {
            //1.服务器异常就空
            success(nil);
        }else{
            //2.正常
            success(result[@"data"]);
        }
    } failure:^(NSError *error) {
        failure(error);
    }];


}


#pragma mark -3.登出
+(void)LoginOutSuccess:(HttpSuccessBlock)success
               failure:(HttpFailureBlock)failure{
    
    NSDictionary * param =@{@"uid":MY_UID};
    [HttpTool postWithPath:@"MM/member/loginout.action" params:param success:^(id result) {
        
        NSLog(@"结果:%@",result);
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark -4.用户修改
+(void)UpdateUserType:(AccountType)type
              content:(NSString*)content
              success:(HttpSuccessBlock)success
              failure:(HttpFailureBlock)failure{
    
    if (!content) {
        return;
    }
    NSDictionary * param =@{@"uid":MY_UID,
                            @"t":@(type),
                            @"c":content};
    [HttpTool postWithPath:@"MM/member/modify.action" params:param success:^(id result) {
        
          success(result);
        
    } failure:^(NSError *error) {
          failure(error);
        
    }];
}

#pragma mark -5.更改用户的通用状态/现场状态
+(void)UpdateUserStateType:(NSInteger)stateType
                   content:(NSString*)content
                   success:(HttpSuccessBlock)success
                   failure:(HttpFailureBlock)failure{
    
    
    NSDictionary * param =@{@"uid":MY_UID,
                            @"t":@(stateType),
                            @"c":content};
    [HttpTool postWithPath:@"MM/member/changeState.action" params:param success:^(id result) {
        
        success(result);
        
    } failure:^(NSError *error) {
          failure(error);
        
    }];

}

#pragma mark -6.位置是否可见/是否可被搭讪
+(void)UpdateUserLocation:(BOOL)le //位置是否可见
                       ae:(BOOL)ae   //是否可被搭讪
                  success:(HttpSuccessBlock)success
                  failure:(HttpFailureBlock)failure{
    
    NSDictionary * param =@{@"uid":MY_UID,
                            @"le":@(le),
                            @"ae":@(ae)};
    [HttpTool postWithPath:@"MM/member/changeState.action" params:param success:^(id result) {
        
           success(result);
        
    } failure:^(NSError *error) {
          failure(error);
        
    }];

}

#pragma mark -7.绑定手机号码的第一步操作:发送验证码短信
+(void)BindPhone:(NSString*)phone
         success:(HttpSuccessBlock)success
         failure:(HttpFailureBlock)failure{
    
    NSDictionary * param =@{@"phone":phone};
    [HttpTool postWithPath:@"MM/member/sendCode.action" params:param success:^(id result) {
        
            success(result);
        
    } failure:^(NSError *error) {
          failure(error);
        
    }];

}
#pragma mark -8.用于绑定手机号码的第二步操作:验证短信验证码
+(void)VerifyPhone:(NSString*)phone
              code:(NSString*)code
           success:(HttpSuccessBlock)success
           failure:(HttpFailureBlock)failure{
    
    NSDictionary * param =@{@"uid":MY_UID,
                            @"phone":phone,
                            @"code":code};
    [HttpTool postWithPath:@"MM/member/valPhone.action" params:param success:^(id result) {
        
           success(result);
        
    } failure:^(NSError *error) {
          failure(error);
        
    }];
}


#pragma mark -9.输入推广码,验证推广码,获取对应优惠券

+(void)getPromotionCode:(NSString*)sid
                success:(HttpSuccessBlock)success
                failure:(HttpFailureBlock)failure{
    
    NSDictionary * param =@{@"uid":MY_UID,
                            @"sid":sid};
    [HttpTool postWithPath:@"MM/member/spread.action" params:param success:^(id result) {
        
           success(result);
    } failure:^(NSError *error) {
          failure(error);
        
    }];
}




#pragma mark -上传图片
+(void)upLoadPhoto:(UIImage*)image
          location:(int)location
          imageKey:(NSString*)key
           Success:(HttpSuccessBlock)success
           failure:(HttpFailureBlock)failure;
{

    NSMutableDictionary *params =[NSMutableDictionary dictionaryWithDictionary:@{@"uid": MY_UID}];
    NSString * path=nil;
    if ([key isEqualToString:@"head"]) {
        path=@"MM/member/uploadHead.action";
    }else{
        path=@"MM/member/uploadPhotos.action";
        [params addEntriesFromDictionary:@{@"location":@(location)}];
    }
    
    
    [HttpTool upLoadimage:image path:path param:params
                    imageKey:key
                  success:^(id result) {
        if (!result[@"data"][@"url"]) {
            success(nil);
            return;
        }
        NSString * URL = result[@"data"][@"url"];
        success(URL);
    } failure:^(NSError *error) {
        failure(error);

    }];
   
}

#pragma mark - 更新wifiMac
+(void)updateUserWifiSuccess:(HttpSuccessBlock)success
                     failure:(HttpFailureBlock)failure{


NSMutableDictionary * params =
                        [NSMutableDictionary dictionaryWithDictionary:@{@"driviceCode":[UIDevice getDeviceUDID],
                                                                                   @"driveType":@"ios",
                                                                                   @"uid":MY_UID }];
    if ([UIDevice getAVOSDeviceID]) {
        [params addEntriesFromDictionary:@{@"avid":[UIDevice getAVOSDeviceID]}];
    }
    if ([UIDevice getWifiMacAddress]) {
        [params addEntriesFromDictionary:@{@"wifiMac":[UIDevice getWifiMacAddress]}];
        
    }

    NSDictionary * dic =[NSDictionary dictionaryWithDictionary:params];
    
    [HttpTool postWithPath:@"MM/member/changeWifi.action" params:dic success:^(id result) {
        
        if (!result[@"success"]) {
            [JDStatusBarNotification showWithStatus:@"现场WIFI更新失败哦,下拉一下" dismissAfter:5.0 styleName:JDStatusBarStyleError];
            return;
        }
        
        success(result);
    } failure:^(NSError *error) {
        
        failure(error);
        
    }];

}
#pragma mark -验证注册后

+(void)registerWithUserName:(NSString*)username
                   password:(NSString*)password
                    Success:(HttpSuccessBlock)success
                    failure:(HttpFailureBlock)failure;{
    
    [JDStatusBarNotification showWithStatus:@"正在注册..." dismissAfter:4];

    [Hi_AccountTool registerPhone:username password:password success:^(id result) {
        if (result) {
            success(result);
            [Hi_AccountTool saveAccountToSystem:result[@"data"] SavedType:AccountSaveTypePhoneRegiters];
        }else{
             success(nil);
        }
    } failure:^(NSError *error) {
        failure(error);
    }];

    
}
#pragma mark -登录后
+(void)loginWithUserName:(NSString*)username
                password:(NSString*)password
                 Success:(HttpSuccessBlock)success
                 failure:(HttpFailureBlock)failure;{

   // [JDStatusBarNotification showWithStatus:@"正在登录...." dismissAfter:4];

    [Hi_AccountTool loginPhone:username password:password success:^(id result) {
        if (result) {
            [Hi_AccountTool saveAccountToSystem:result[@"data"] SavedType:AccountSaveTypePhoneLogin];
            success(result);
        }else{
        }
    } failure:^(NSError *error) {
        failure(error);
    }];
}
#pragma mark -更新 AVOS
+(void)updateAVOSSuccess:(HttpSuccessBlock)success
                     failure:(HttpFailureBlock)failure{
    
    if (![UIDevice getAVOSDeviceID]) {
        
        return;
    }
    NSDictionary * param = @{@"driviceCode":[UIDevice getDeviceUDID],
                             @"avid":[UIDevice getAVOSDeviceID],
                             @"driveType":@"ios",
                             @"id":MY_UID};
    
    [HttpTool postWithPath:@"MM/member/updateAVOS.action " params:param success:^(id result) {
        
        if (!result[@"success"]) {
            return;
        }
        
        success(result);
    } failure:^(NSError *error) {
        
        failure(error);
        return;
        
    }];
    
}

@end
