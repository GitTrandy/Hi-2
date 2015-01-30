//
//  UIView+JJ.h
//  易商
//
//  Created by 伍松和 on 14/10/24.
//  Copyright (c) 2014年 Ruifeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIBarButtonItem+MJ.h"
#import "UIImage+JJ.h"
#import "UIControl+JJ.h"
#import "UIView+JJExtension.h"
#import "UIButton+JJ.h"

@interface UIView (JJ)<UIAlertViewDelegate,UIActionSheetDelegate>
-(void)showWithCompletionHandler:(void (^)(NSInteger buttonIndex))completionHandler;

-(void)showInView:(UIView *)view withCompletionHandler:(void (^)(NSInteger buttonIndex))completionHandler;
-(void)showFromBarButtonItem:(UIBarButtonItem *)item
                    animated:(BOOL)animated
       withCompletionHandler:(void (^)(NSInteger buttonIndex))completionHandler;


//#pragma mark -封装等待标志
//+(void)showWaitMsg:(NSString*)msg;
//+(void)showFailure:(NSString*)msg;
//+(void)showDone:(NSString*)msg;

#pragma mark -显示警告

+(void)showSIAlert:(NSString *)alertTitle
               msg:(NSString *)msg;
+(void)showAlert:(NSString*)msg;

#pragma mark -乱来
typedef void(^BtnActionBlock)(id objectData,NSInteger buttonTag);
@property (copy, nonatomic)BtnActionBlock btnActionBlock;
-(void)addActionBlock:(BtnActionBlock)btnActionBlock;
@end
