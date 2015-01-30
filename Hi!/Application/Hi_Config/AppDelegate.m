//
//  AppDelegate.m
//  Hi!
//
//  Created by 伍松和 on 14/11/27.
//  Copyright (c) 2014年 伍松和. All rights reserved.
//

#import "AppDelegate.h"
#import "Hi_MainViewController.h"
#import "Hi_RootControllerTool.h"
#import "Hi_GlobalMarco.h"
#import "OpenUDID.h"
#import "Hi_AccountTool.h"
#import "Hi_NotificationTool.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WeiboSDK.h"
#import <AVOSCloud/AVOSCloud.h>

@interface AppDelegate ()<AVSessionDelegate>{
    
    AVSession * _seesion;
}
@property(strong,nonatomic)TencentOAuth *tencentAuth;
@property (nonatomic,strong)id lastViewController;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
//    [MLBlackTransition validatePanPackWithMLBlackTransitionGestureRecognizerType:MLBlackTransitionGestureRecognizerTypeScreenEdgePan];
//
    
    [self setNaviAppearance];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] ;
    [self.window makeKeyAndVisible];
    [[Hi_RootControllerTool sharedHi_RootControllerTool]chooseRootControllerFirstState:ROOT_CONTROLLER_STATE_NO_ACCOUNT_HAVE_TUTOUIAL];
    
    
    //2. 第三方
    
#if USE_US
    [AVOSCloud useAVCloudUS];
#endif
    [AVOSCloud setApplicationId:AVOSAppID
                      clientKey:AVOSAppkey];
    [AVAnalytics trackAppOpenedWithLaunchOptions:launchOptions];

    
    
    [WXApi registerApp:WeChatAppkey withDescription:@"demo2.0"];
    _tencentAuth=[[TencentOAuth alloc]initWithAppId:QQAppKey andDelegate:nil];
    _tencentAuth.redirectURI = @"www.qq.com";
    [WeiboSDK registerApp:SinaAppkey];

    
    
    
    
    //3.推送
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else
    {
        
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
        
    }
    
    if (![[NSUserDefaults standardUserDefaults]objectForKey:USER_DRIVER]) {
        [[NSUserDefaults standardUserDefaults]setObject:[OpenUDID value] forKey:USER_DRIVER];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    
 


    
    //5.每次启动需要开启会话
 
    if (MY_UID) {
        Hi_SessionTool *ss=[Hi_SessionTool sharedInstance];
        [ss openSession];
    }
 
   

    return YES;
}

#define kTip @"恭喜您，%@通过了您的关联申请，现在您可以代表%@开展营销了"
#pragma mark -开启推送(以后开启也可以)
- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    NSLog(@"%@",[UIDevice getWifiMacAddress]);
    AVInstallation *currentInstallation = [AVInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
        }  SAVE_MY_AVID(currentInstallation.deviceToken);
    }];
}
#pragma mark -开启推送失败

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    
    
    [JDStatusBarNotification showWithStatus:@"没有开启推送,这会让你错过好多搭讪的信息" dismissAfter:2.0 styleName:JDStatusBarStyleError];
    //当失败
    [[NSUserDefaults standardUserDefaults]setObject:nil forKey:USER_AVID];
    [[NSUserDefaults standardUserDefaults]setObject:nil forKey:USER_DRIVER];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    
}
#pragma mark -当接到推送后,后台
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    
     NSLog(@"userInfo:%@",userInfo);
    [Hi_NotificationTool DEAL_MSG_Notification:userInfo withCurrentController:_lastViewController];
    
    
}


-(void)setNaviAppearance{
    
    
    
    
    [[UINavigationBar appearance] setBarTintColor:kColor(254, 72, 0)];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:18],NSFontAttributeName,nil]];
    
    
    
    
    
}
#pragma mark -角标清零
-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    //点击提示框的打开
    application.applicationIconBadgeNumber = 0;
}
- (void)applicationDidBecomeActive:(UIApplication *)application {
    //当程序还在后天运行
    application.applicationIconBadgeNumber = 0;
    
//    AVInstallation *currentInstallation = [AVInstallation currentInstallation];
//    [currentInstallation setBadge:0];
//    [currentInstallation saveEventually];
    ///重复执行

}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
//    application.applicationIconBadgeNumber = [Hi_SMSModel hi_dealWithUnreadMessageNum:nil];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    application.applicationIconBadgeNumber = [Hi_SMSModel hi_dealWithUnreadMessageNum:nil];

}
- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
#pragma mark -第三方登录打开
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation{
    
    
    NSString *URLString = [url scheme];
    //    NSLog(@"打开应用:%@",URLString);
    //
    //
    if ( [URLString hasPrefix:@"tencent"] || [URLString hasPrefix:@"sinaweibosso"]) {
        return [AVOSCloudSNS handleOpenURL:url];
    }else if ( [URLString hasPrefix:@"sinaweibosso"]){
        return [WeiboSDK handleOpenURL:url delegate:nil];
    }else if([URLString hasPrefix:@"wx"]){
        
        return [WXApi handleOpenURL:url delegate:nil];
    }else{
        
        return NO;
    }
    
    
}
@end
