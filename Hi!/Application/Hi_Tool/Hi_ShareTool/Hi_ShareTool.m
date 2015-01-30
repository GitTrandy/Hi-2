//
//  ES_ShareTool.m
//  易商
//
//  Created by 伍松和 on 14/11/10.
//  Copyright (c) 2014年 Ruifeng. All rights reserved.
//

#import "Hi_ShareTool.h"
#import "JJWeChatTool.h"
#import "JJMailSMSTool.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <AVOSCloudSNS/AVOSCloudSNS.h>
#import "WeiboSDK.h"

#define ___ES_TIP_PLIST_CONFIG_MARCO_h


@implementation Hi_ShareTool

//+(void)shareShortSMS:(NSArray*)sends
//                 url:(NSString*)url
//                ctrl:(UIViewController*)ctrl{
//
//        Account * account  = [AccountTool getCurrentAccount];
//        [[JJMailSMSTool sharedJJMailSMSTool]sendSMSMsg:ES_SHARE_TIP_SMS(account.NickName, url) WithRecipients:sends WithCtrl:ctrl.navigationController.topViewController];
//}
+(void)ShareActionDidClickOnButtonIndex:(NSInteger)buttonIndex
                                      url:(NSString*)aUrl
                                    image:(UIImage*)aImage
                                    title:(NSString*)aTitle
                                 desTitle:(NSString*)aDesTitle
                                     ctrl:(UIViewController*)ctrl{
    
    JJShareActionType shareType=buttonIndex;
    
    NSString * URL=aUrl;
    UIImage * image=aImage;
    NSString * title=aTitle;
    NSString * desTitle=aDesTitle;
    
    
    
    switch (shareType) {
        case JJShareActionTypeWeChat:
        {
            
            
            
            [[JJWeChatTool sharedJJWeChatTool]changeScene:WXSceneSession];
            [[JJWeChatTool sharedJJWeChatTool]sendLinkContentUrl:URL Title:title des:desTitle image:image];
            break;
            
        }
        case JJShareActionTypeWeChatTimeline:{
            
            
            
            
            [[JJWeChatTool sharedJJWeChatTool]changeScene:WXSceneTimeline];
            [[JJWeChatTool sharedJJWeChatTool]sendLinkContentUrl:URL Title:title des:desTitle image:image];
            
        }
            //
            break;
        case JJShareActionTypeSina:
            //
        {
            WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
            authRequest.redirectURI = @"http://www.sina.com";
            authRequest.scope = @"all";
            
            WBMessageObject *message = [WBMessageObject message];
            message.text =desTitle;
            WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message authInfo:authRequest access_token:nil];
            [WeiboSDK sendRequest:request];
            break;
        }
           
        case JJShareActionTypeQQ:
            //
            
            
        {
            QQApiNewsObject *newsObj = [QQApiNewsObject
                                        objectWithURL:[NSURL URLWithString:URL]
                                        title:title
                                        description:desTitle
                                        previewImageData:UIImageJPEGRepresentation(aImage, 0.8)];
            SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
            [QQApiInterface sendReq:req];
            break;
            
        }
        case JJShareActionTypeQQZone:
        {
            
            QQApiNewsObject *newsObj = [QQApiNewsObject
                                        objectWithURL:[NSURL URLWithString:URL]
                                        title:title
                                        description:desTitle
                                        previewImageData:UIImageJPEGRepresentation(aImage, 0.8)];
            SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
            QQApiSendResultCode sent = [QQApiInterface SendReqToQZone:req];
            if (sent!=EQQAPISENDSUCESS) {
                NSLog(@"failure");
            }
            break;
        }
            
        case JJShareActionTypeEmail:
        {
//            Account * account  = [AccountTool getCurrentAccount];
//            NSString * s =ES_SHARE_TIP_EMAIL(account.NickName, URL);
            [[JJMailSMSTool sharedJJMailSMSTool]sendEmailMsg:nil toRecipients:nil otherData:nil WithCtrl:ctrl];
            break;
        }
            
            
            
        case JJShareActionTypeCopy:{
            
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = URL;
//            UIWINDOW_SUCCESS(@"成功复制");
            break;
        }
            
            
        default:
            break;
    }
    
    
}



//+(void)smsAction:(ES_BookModel*)bookModel
//            ctrl:(UIViewController*)ctrl{
//    
//    ES_ContactChooseViewController *vc = [[ES_ContactChooseViewController alloc]init];
//    vc.bookModel=bookModel;
//    UINavigationController *navVC = [[UINavigationController alloc]initWithRootViewController:vc];
//    [ctrl presentViewController:navVC animated:YES completion:nil];
//}

@end
