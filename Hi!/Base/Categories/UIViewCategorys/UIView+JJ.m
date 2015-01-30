//
//  UIView+JJ.m
//  易商
//
//  Created by 伍松和 on 14/10/24.
//  Copyright (c) 2014年 Ruifeng. All rights reserved.
//

#import "UIView+JJ.h"
#import <objc/runtime.h>
#import "NSObject+AssociatedObjects.h"

@implementation UIView (JJ)

const char oldDelegateKey;
const char completionHandlerKey;



#pragma -mark UIAlerView

-(void)showWithCompletionHandler:(void (^)(NSInteger buttonIndex))completionHandler
{
    UIAlertView *alert = (UIAlertView *)self;
    if(completionHandler != nil)
    {
        id oldDelegate = objc_getAssociatedObject(self, &oldDelegateKey);
        if(oldDelegate == nil)
        {
            objc_setAssociatedObject(self, &oldDelegateKey, oldDelegate, OBJC_ASSOCIATION_ASSIGN);
        }
        
        oldDelegate = alert.delegate;
        alert.delegate = self;
        objc_setAssociatedObject(self, &completionHandlerKey, completionHandler, OBJC_ASSOCIATION_COPY);
    }
    
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIAlertView *alert = (UIAlertView *)self;
    void (^theCompletionHandler)(NSInteger buttonIndex) = objc_getAssociatedObject(self, &completionHandlerKey);
    
    if(theCompletionHandler == nil)
        return;
    
    theCompletionHandler(buttonIndex);
    alert.delegate = objc_getAssociatedObject(self, &oldDelegateKey);
}
#pragma -mark UIActionSheet
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    void (^theCompletionHandler)(NSInteger buttonIndex) = objc_getAssociatedObject(self, &completionHandlerKey);
    
    if(theCompletionHandler == nil)
        return;
    
    theCompletionHandler(buttonIndex);
    UIActionSheet *sheet = (UIActionSheet *)self;
    
    sheet.delegate = objc_getAssociatedObject(self, &oldDelegateKey);
}


-(void)config:(void(^)(NSInteger buttonIndex))completionHandler
{
    if(completionHandler != nil)
    {
        
        id oldDelegate = objc_getAssociatedObject(self, &oldDelegateKey);
        if(oldDelegate == nil)
        {
            objc_setAssociatedObject(self, &oldDelegateKey, oldDelegate, OBJC_ASSOCIATION_ASSIGN);
        }
        
        UIActionSheet *sheet = (UIActionSheet *)self;
        oldDelegate = sheet.delegate;
        sheet.delegate = self;
        objc_setAssociatedObject(self, &completionHandlerKey, completionHandler, OBJC_ASSOCIATION_COPY);
    }
}
-(void)showInView:(UIView *)view
withCompletionHandler:(void (^)(NSInteger buttonIndex))completionHandler
{
    UIActionSheet *sheet = (UIActionSheet *)self;
    [self config:completionHandler];
    [sheet showInView:view];
}
-(void)showFromBarButtonItem:(UIBarButtonItem *)item
                    animated:(BOOL)animated
       withCompletionHandler:(void (^)(NSInteger buttonIndex))completionHandler
{
    UIActionSheet *sheet = (UIActionSheet *)self;
    [self config:completionHandler];
    [sheet showFromBarButtonItem:item animated:animated];
}
#pragma mark -封装等待标志
//+(void)showWaitMsg:(NSString*)msg{
//    
//    [SVProgressHUD showWithStatus:msg];
//    
//}
//+(void)showFailure:(NSString*)msg{
//    
//    [JDStatusBarNotification showWithStatus:msg dismissAfter:4 styleName:JDStatusBarStyleError];
//    [SVProgressHUD dismiss];
//}
//+(void)showDone:(NSString*)msg{
//    
//    [SVProgressHUD showSuccessWithStatus:msg];
//}



#pragma mark -显示警告


+(void)showSIAlert:(NSString *)alertTitle
               msg:(NSString *)msg{
    
    UIAlertView * alertView=[[UIAlertView alloc]initWithTitle:@"信息" message:msg delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
    [alertView show];
}


+(void)showAlert:(NSString*)msg{
    
    UIAlertView * alertView=[[UIAlertView alloc]initWithTitle:@"信息" message:msg delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
    [alertView show];
}



static char KBtnActionBlock;

-(void)setBtnActionBlock:(BtnActionBlock)btnActionBlock{
    [self associateCopyOfValue:btnActionBlock withKey:&KBtnActionBlock];
}
-(BtnActionBlock)btnActionBlock{
    return [self associatedValueForKey:&KBtnActionBlock];
    
}
-(void)addActionBlock:(BtnActionBlock)btnActionBlock{
    
    self.btnActionBlock=btnActionBlock;
}
//-(void)dealloc{self.btnActionBlock=nil;}

@end