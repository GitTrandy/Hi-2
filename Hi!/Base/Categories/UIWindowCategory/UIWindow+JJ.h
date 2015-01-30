
#import <UIKit/UIKit.h>
#pragma mark -方便的宏


//状态栏
#define UIWINDOW_STATE_SHOW(STATE) [UIWindow showWithBarStatus:STATE error:NO success:NO dismissAfter:3];


#define UIWINDOW_SUCCESS(SUCCESS_STATE) [UIWindow showWithBarStatus:SUCCESS_STATE error:NO success:YES dismissAfter:3];
#define UIWINDOW_FAILURE(FAILURE_STATE) [UIWindow showWithBarStatus:FAILURE_STATE error:YES success:NO dismissAfter:3];

#define UIWINDOW_SEND_SUCCESS [UIWindow showWithBarStatus:@"发送成功.." error:NO success:YES dismissAfter:3];
#define UIWINDOW_SEND_FAILURE [UIWindow showWithBarStatus:@"发送失败.." error:YES success:NO dismissAfter:3];

#define UIWINDOW_STATE_SHOW_ACTIVITE(STATE,STYLE,TIME) [UIWindow showWithBarStatus:STATE error:NO success:NO indicator:YES indicatorStyle:STYLE dismissAfter:TIME]
#define UIWINDOW_STATE_DISMISS [UIWindow dismissWithBar]


@interface UIWindow (JJ)
#pragma mark -顶部等待标识
/**
 *  展示在状态栏的通知
 *
 *  @param Status         文字
 *  @param timeInterval   时间,如果0就是无限停留
 */
+(void)showWithBarStatus:(NSString*)Status
            dismissAfter:(NSTimeInterval)timeInterval;
/**
 *  展示在状态栏的通知
 *
 *  @param Status         文字
 *  @param isErrorStyle   是否警告/失败标识
 *  @param isSuccessStyle 是否成功
 *  @param timeInterval   时间如果0就是无限停留
 */
+(void)showWithBarStatus:(NSString*)Status
                   error:(BOOL)isErrorStyle
                 success:(BOOL)isSuccessStyle
            dismissAfter:(NSTimeInterval)timeInterval;

/**
 *  展示在状态栏的通知
 *
 *  @param Status         文字
 *  @param isErrorStyle   是否警告/失败标识
 *  @param isSuccessStyle 是否成功
 *  @param isindicator    是否要等待标识
 *  @param style          标识风格
 *  @param timeInterval   时间-如果0就是无限停留
 */
+(void)showWithBarStatus:(NSString*)Status
                   error:(BOOL)isErrorStyle
                 success:(BOOL)isSuccessStyle
               indicator:(BOOL)isindicator
          indicatorStyle:(UIActivityIndicatorViewStyle)style
            dismissAfter:(NSTimeInterval)timeInterval;
/**
 *  隐藏顶部标识
 */
+(void)dismissWithBar;


#pragma mark - 其他地方
/**
 *  普通等待标识
 *
 *  @param Status       等待文字
 */
+(void)showWithHUDStatus:(NSString*)Status
            detailStatus:(NSString*)detailStatus;
+(void)showWithHUDStatus:(NSString*)Status;

/**
 *  普通等待标识
 *
 *  @param Status       等待文字
 *  @param timeInterval 等待时间,如果传0就是无限等待
 */
+(void)showWithHUDStatus:(NSString*)Status
            detailStatus:(NSString*)detailStatus
            dismissAfter:(NSTimeInterval)timeInterval;
+(void)showWithHUDStatus:(NSString*)Status
            dismissAfter:(NSTimeInterval)timeInterval;


+(void)dismissWithHUDWithStatus:(NSString*)Status
                   dismissAfter:(NSTimeInterval)timeInterval;

+(void)dismissWithHUD;



@end
