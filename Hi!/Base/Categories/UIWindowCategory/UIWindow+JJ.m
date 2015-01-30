

#import "UIWindow+JJ.h"
#import "MBProgressHUD.h"
//#import "RKDropdownAlert.h"
#import "SVProgressHUD.h"
#import "JDStatusBarNotification.h"

#import "PlaySoundClass.h"


@implementation UIWindow (JJ)
static MBProgressHUD *_progressHUD;


#pragma mark -顶部等待标识

/**
 *  展示在状态栏的通知
 *
 *  @param Status         文字
 *  @param timeInterval   时间
 */
+(void)showWithBarStatus:(NSString*)Status
            dismissAfter:(NSTimeInterval)timeInterval{
    
    [UIWindow showWithBarStatus:Status error:NO success:NO dismissAfter:timeInterval];
}
/**
 *  展示在状态栏的通知
 *
 *  @param Status         文字
 *  @param isErrorStyle   是否警告/失败标识
 *  @param isSuccessStyle 是否成功
 *  @param timeInterval   时间
 */
+(void)showWithBarStatus:(NSString*)Status
                   error:(BOOL)isErrorStyle
                 success:(BOOL)isSuccessStyle
            dismissAfter:(NSTimeInterval)timeInterval{

    [UIWindow showWithBarStatus:Status error:isErrorStyle success:isSuccessStyle indicator:NO indicatorStyle:0 dismissAfter:timeInterval];
}

/**
 *  展示在状态栏的通知
 *
 *  @param Status         文字
 *  @param isErrorStyle   是否警告/失败标识
 *  @param isSuccessStyle 是否成功
 *  @param isindicator    是否要等待标识
 *  @param style          标识风格
 *  @param timeInterval   时间
 */
+(void)showWithBarStatus:(NSString*)Status
                   error:(BOOL)isErrorStyle
                 success:(BOOL)isSuccessStyle
               indicator:(BOOL)isindicator
          indicatorStyle:(UIActivityIndicatorViewStyle)indicatorStyle
            dismissAfter:(NSTimeInterval)timeInterval{
    
    NSString * barStyle =JDStatusBarStyleDefault;
    PlaySoundClass * soundClass=nil;
    if (!isErrorStyle&&!isSuccessStyle) {
        barStyle=JDStatusBarStyleDefault;//1.默认
    }else if (isErrorStyle){
        barStyle=JDStatusBarStyleError;//2.错误警告
        soundClass=[[PlaySoundClass alloc]initForPlayingSoundEffectWith:@"ms_send.caf"];

    }else if (isSuccessStyle){
        barStyle=JDStatusBarStyleSuccess;//3.成功警告
        soundClass= [[PlaySoundClass alloc]initForPlayingSoundEffectWith:@"roam_final.caf"];

    }else{
        barStyle=JDStatusBarStyleDefault; //默认
    }
    
    //B.是否等待标识
    [JDStatusBarNotification showActivityIndicator:isindicator indicatorStyle:indicatorStyle];
    
    //C
    if (_progressHUD) {
        [_progressHUD hide:YES];
    }
    if (timeInterval==0) {
        [JDStatusBarNotification showWithStatus:Status styleName:barStyle];
    }else{
        [JDStatusBarNotification showWithStatus:Status dismissAfter:timeInterval styleName:barStyle];
        if (soundClass) {
            [soundClass play];
        }
    }
    

}
/**
 *  隐藏顶部标识
 */
+(void)dismissWithBar{[JDStatusBarNotification dismiss];}


#pragma mark - 其他地方
+(void)showWithHUDStatus:(NSString*)Status{
    [UIWindow showWithHUDStatus:Status detailStatus:nil dismissAfter:0 view:nil];
}
+(void)showWithHUDStatus:(NSString*)Status
            detailStatus:(NSString*)detailStatus{
    [UIWindow showWithHUDStatus:Status detailStatus:detailStatus dismissAfter:0 view:nil];

}
+(void)showWithHUDStatus:(NSString*)Status
            detailStatus:(NSString*)detailStatus
        dismissAfter:(NSTimeInterval)timeInterval{

    [UIWindow showWithHUDStatus:Status detailStatus:detailStatus dismissAfter:0 view:nil];

    
}
+(void)showWithHUDStatus:(NSString*)Status
            dismissAfter:(NSTimeInterval)timeInterval
 {
    [UIWindow showWithHUDStatus:Status detailStatus:nil dismissAfter:timeInterval view:nil];
     
}

/**
 *  普通等待标识
 *
 *  @param Status       等待文字
 *  @param detailStatus  详细等待文字
 *  @param timeInterval 等待时间,如果传0就是无限等待
 */
+(void)showWithHUDStatus:(NSString*)Status
            detailStatus:(NSString*)detailStatus
            dismissAfter:(NSTimeInterval)timeInterval
                    view:(UIView*)view;
{

    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    _progressHUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
    _progressHUD.labelText = Status;
    _progressHUD.detailsLabelText = detailStatus;
//    _progressHUD.cornerRadius = 60;
    _progressHUD.square=YES;
    _progressHUD.removeFromSuperViewOnHide = YES;
    [_progressHUD show:YES];
    if (timeInterval>0) {
        _progressHUD.mode=MBProgressHUDModeText;
        [_progressHUD hide:YES afterDelay:timeInterval];
    }else{
        [_progressHUD hide:YES afterDelay:25];

    }
}
/**
 *  单一文字
 */

+(void)dismissWithHUDWithStatus:(NSString*)Status
                   dismissAfter:(NSTimeInterval)timeInterval
{
   // [_progressHUD hide:YES];
    
    
    _progressHUD.labelText = Status;
    _progressHUD.mode=MBProgressHUDModeText;
    _progressHUD.removeFromSuperViewOnHide = YES;
    _progressHUD.square=NO;
    [_progressHUD hide:YES afterDelay:timeInterval];

}
+(void)dismissWithHUD{

    [_progressHUD hide:YES];
}
@end
