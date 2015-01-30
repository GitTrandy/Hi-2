
/*
userInfo:{
    aps =     {
        alert = "\U79fb\U52a8\U4e92\U8054\U7f51,\U79fb\U52a8\U4e92\U8054\U7f51,\U79fb\U52a8\U4e92\U8054\U7f51,\U79fb\U52a8\U4e92\U8054\U7f51,\U79fb\U52a8\U4e92\U8054\U7f51";
        sound = default;
    };
    sendId = 8a211dcc47e9e5280147edb10ce60007;
}
*/
#import <Foundation/Foundation.h>
///用来处理远程通知
///用了处理系统通知中心的通知
@interface Hi_NotificationTool : NSObject

+(void)DEAL_MSG_Notification:(NSDictionary *)Info
       withCurrentController:(id)controller;

@end
