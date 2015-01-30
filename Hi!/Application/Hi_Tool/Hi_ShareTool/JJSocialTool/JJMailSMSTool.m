//
//  MailSMSTool.m
//  易商
//
//  Created by namebryant on 14-9-29.
//  Copyright (c) 2014年 Ruifeng. All rights reserved.
//

#import "JJMailSMSTool.h"


@interface JJMailSMSTool()<UIAlertViewDelegate>

@end

@implementation JJMailSMSTool

single_implementation(JJMailSMSTool)


-(void)sendSMSMsg:(NSString*)msg
   WithRecipients:(NSArray*)recipients
         WithCtrl:(UIViewController*)ctrl{


    Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
    
    
    if (messageClass != nil) {
        
        // Check whether the current device is configured for sending SMS messages
        
        if ([messageClass canSendText]) {
            
            [self displaySMSMsg:msg WithRecipients:recipients WithCtrl:ctrl];
            
        }
        
        else {
            
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"message" message:@":设备不支持短信功能" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
            
            [alert show];
            
            
            
            
        }
        
    }
    
    else {
        
    }
    
    
}
-(void)sendEmailMsg:(NSString *)msg toRecipients:(NSArray *)toRecipients otherData:(id)otherData WithCtrl:(UIViewController *)ctrl{

    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    if (mailClass !=nil) {
        
        if ([mailClass canSendMail]) {
            
            [self displayEmailMsg:msg toRecipients:toRecipients otherData:otherData WithCtrl:ctrl];
            
        }else{
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@""message:@"设备不支持邮件功能" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            
        }
        
    }else{}

}
#pragma mark -发邮件




-(void)displayEmailMsg:(NSString *)msg toRecipients:(NSArray *)toRecipients otherData:(id)otherData WithCtrl:(UIViewController *)ctrl

{
    
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    
    
    
    picker.mailComposeDelegate =self;
    
    [picker setSubject:@"分享"];
    
    // Set up recipients
    [picker setToRecipients:toRecipients];
    
    
    // Fill out the email body text
    
    NSString *emailBody =[NSString stringWithFormat:@"分享信息:%@",msg] ;
    [picker setMessageBody:emailBody isHTML:NO];
    [ctrl presentViewController:picker animated:YES completion:NULL];
    
    
}

//短信
#pragma mark -发短信


-(void)displaySMSMsg:(NSString*)msg
      WithRecipients:(NSArray*)recipients
            WithCtrl:(UIViewController*)ctrl
{
    
    MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
     picker.recipients = recipients;
    picker.messageComposeDelegate =self;
     NSString *smsBody =[NSString stringWithFormat:@"%@",msg] ;
    picker.body=smsBody;
    [ctrl presentViewController:picker animated:YES completion:NULL];
}
#pragma mark -代理
-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{

    [controller dismissViewControllerAnimated:YES completion:nil];

}
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    
    // Notifies users about errors associated with the interface
    
    switch (result)
    
    {
            
        case MFMailComposeResultCancelled:
            
           // NSLog(@"Result: Mail sending canceled");
             break;
            
        case MFMailComposeResultSaved:
            
           // NSLog(@"Result: Mail saved");
            
            break;
            
        case MFMailComposeResultSent:
            
          //  NSLog(@"Result: Mail sent");
            
            break;
            
        case MFMailComposeResultFailed:
            
           // NSLog(@"Result: Mail sending failed");
            
            break;
            
        default:
            
           // NSLog(@"Result: Mail not sent");
            
            break;
            
    }
    
    [controller dismissViewControllerAnimated:YES completion:nil];

}
//发送图片附件

//NSString *path = [[NSBundle mainBundle] pathForResource:@"rainy" ofType:@"jpg"];

//NSData *myData = [NSData dataWithContentsOfFile:path];

//[picker addAttachmentData:myData mimeType:@"image/jpeg" fileName:@"rainy.jpg"];

//发送txt文本附件

//NSString *path = [[NSBundle mainBundle] pathForResource:@"MyText" ofType:@"txt"];

//NSData *myData = [NSData dataWithContentsOfFile:path];

//[picker addAttachmentData:myData mimeType:@"text/txt" fileName:@"MyText.txt"];

//发送doc文本附件

//NSString *path = [[NSBundle mainBundle] pathForResource:@"MyText" ofType:@"doc"];

//NSData *myData = [NSData dataWithContentsOfFile:path];

//[picker addAttachmentData:myData mimeType:@"text/doc" fileName:@"MyText.doc"];

//发送pdf文档附件

/*
 
 NSString *path = [[NSBundlemainBundle] pathForResource:@"CodeSigningGuide"ofType:@"pdf"];
 
 NSData *myData = [NSDatadataWithContentsOfFile:path];
 
 [pickeraddAttachmentData:myData mimeType:@"file/pdf"fileName:@"rainy.pdf"];
 
 */


@end
