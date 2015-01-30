
/*
 userInfo:{
 aps =     {
 alert = "\U79fb\U52a8\U4e92\U8054\U7f51,\U79fb\U52a8\U4e92\U8054\U7f51,\U79fb\U52a8\U4e92\U8054\U7f51,\U79fb\U52a8\U4e92\U8054\U7f51,\U79fb\U52a8\U4e92\U8054\U7f51";
 sound = default;
 };
 sendId = 8a211dcc47e9e5280147edb10ce60007;
 }
 */

#import "Hi_NotificationTool.h"
#import "HI_SMSModel.h"
#import "NSDate+JJ.h"
#import "UIDevice+JJ.h"
#import "FMDatabaseAdditions.h"
#import "PlaySoundClass.h"
#import "Hi_SmsTool.h"
#import "Hi_UserTool.h"
@implementation Hi_NotificationTool

+(void)DEAL_MSG_Notification:(NSDictionary *)Info
       withCurrentController:(id)controller;
{

//    //   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleCurrentViewController:) name:@"CurrentViewController" object:nil];
//  //  [[NSUserDefaults standardUserDefaults]synchronize];
//    
//    NSDictionary * userInfo=Info;
//    //1.aps
//    NSDictionary * apsDic=userInfo[@"aps"];
//    if (!userInfo[@"sendId"]||!userInfo[@"id"]) {
//        return;
//    }
//    
//    Hi_SMSModel * smsModel = [[Hi_SMSModel alloc]init];
//    smsModel.msg=apsDic[@"alert"];
//    smsModel.uid=userInfo[@"sendId"];
//    smsModel.time=[NSDate getTimeStampLong:[NSDate date]];
//    smsModel.self_id=MY_UID;
//    smsModel.sendID=userInfo[@"sendId"];
//    smsModel.ID=[userInfo[@"id"] integerValue];
//    smsModel.sendState=Hi_SMSDetailSendStateSuccess;
//    smsModel.un_read_num=YES;
//
//    [Hi_NotificationTool insertUserModel:smsModel];
    //ID
    //NSDictionary * otherInfo =userInfo[@"userInfo"];
    
    
    //0.振动
     PlaySoundClass * soundClass=[[PlaySoundClass alloc]initForPlayingSoundEffectWith:@"ms_send.caf"];
    if (soundClass) {
        [soundClass play];
    }

    

}

+ (void)insertUserModel:(Hi_SMSModel*)smsModel{
//
//    NSString * sql =[NSString stringWithFormat:@"SELECT * FROM Hi_SMSModel  WHERE head !=  '' AND nickname !=  '' AND uid =  '%@' limit 1",smsModel.uid];
//    Hi_SMSModel * tempSmsModel =[[Hi_SMSModel querySMSFormDBComplexSQL:sql] lastObject];
//    if (tempSmsModel) {
//        smsModel.nickname=tempSmsModel.nickname;
//        smsModel.head=tempSmsModel.head;
//        smsModel.his_head=tempSmsModel.head;
//        [Hi_SMSModel insertSMSToDB:smsModel];
//        [self push_notification];
//
//
//    }else{
//    
//        [Hi_UserTool getMemberWithUID:smsModel.uid success:^(id result) {
//            if (result) {
//                Hi_UserModel * userModel = result;
//                smsModel.nickname=userModel.nickName;
//                smsModel.head=userModel.head;
//                smsModel.his_head=userModel.head;
//                smsModel.time=[NSDate getTimeStampLong:[NSDate date]];
//                [Hi_SMSModel insertSMSToDB:smsModel];
//                [self push_notification];
//
//            }
//        } failure:^(NSError *error) {
//            //
//        }];
//    }
  
    

    
    
}
+(void)push_notification{

    //1.搭讪信息
    //    BOOL un_read=![controller isKindOfClass:NSClassFromString(@"Hi_MessageDetailController")];

    NSInteger un_read_num = [Hi_SMSModel hi_dealWithUnreadMessageNum:nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:HI_UN_READ_NUM_NOTIFICATION object:@(un_read_num) userInfo:@{@"user_type":@"accost"}];
    
    
    //2.推送未读数字
//
//    [[NSNotificationCenter defaultCenter]postNotificationName:HI_UN_READ_NUM_NOTIFICATION object:@(un_read_num) userInfo:nil];

}
@end

