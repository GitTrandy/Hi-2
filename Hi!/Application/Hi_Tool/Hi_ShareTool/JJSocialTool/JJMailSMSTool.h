//
//  MailSMSTool.h
//  易商
//
//  Created by namebryant on 14-9-29.
//  Copyright (c) 2014年 Ruifeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "Singleton.h"




@interface JJMailSMSTool : NSObject<MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate>

single_interface(JJMailSMSTool)


-(void)sendSMSMsg:(NSString*)msg
   WithRecipients:(NSArray*)recipients
         WithCtrl:(UIViewController*)ctrl;

-(void)sendEmailMsg:(NSString*)msg
  toRecipients:(NSArray*)toRecipients
         otherData:(id)otherData
      WithCtrl:(UIViewController*)ctrl;



@end
