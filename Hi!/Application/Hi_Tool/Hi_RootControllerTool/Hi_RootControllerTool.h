typedef NS_ENUM(NSInteger, Hi_RootControllerHelperStyle) {
    
    //0.新手教程
    //1.登录注册界面
    //2.注册后界面,设置界面
    //3.主界面
    
    Hi_RootControllerHelperStyleFirstOpen,
    Hi_RootControllerHelperStyleLoginResgiter,
    Hi_RootControllerHelperStyleAfterLoginResgiter,
    Hi_RootControllerHelperStyleMain,
};

typedef NS_ENUM(NSInteger, ROOT_CONTROLLER_STATE_TYPE) {
    
    /*
     
     1.无帐号,无新手教程
     2.无帐号
     3.有帐号,UID,没有完善资料
     4.有帐号,有资料
     */
    
    ROOT_CONTROLLER_STATE_NO_ACCOUNT_NO_TUTOUIAL,
    ROOT_CONTROLLER_STATE_NO_ACCOUNT_HAVE_TUTOUIAL,
    ROOT_CONTROLLER_STATE_HAVE_ACCOUNT_NO_ALTER,
    ROOT_CONTROLLER_STATE_HAVE_ACCOUNT_HAVE_ALTER,
};

#import <Foundation/Foundation.h>

#import "Hi_RegisterSettingController.h"
#import "Hi_LoginController.h"
#import "Hi_MainViewController.h"

#import "Singleton.h"

///根视图的状态,4种
#define ROOT_CONTROLLER_STATE @"ROOT_CONTROLLER_STATE"
#define SET_ROOT_CONTROLLER_STATE(OBJ) [[NSUserDefaults standardUserDefaults]setObject:OBJ forKey:ROOT_CONTROLLER_STATE];[[NSUserDefaults standardUserDefaults]synchronize]
#define GET_ROOT_CONTROLLER_STATE [[NSUserDefaults standardUserDefaults]objectForKey:ROOT_CONTROLLER_STATE]
#define DEL_ROOT_CONTROLLER_STATE [[NSUserDefaults standardUserDefaults]setObject:nil forKey:ROOT_CONTROLLER_STATE];[[NSUserDefaults standardUserDefaults]synchronize]


@interface Hi_RootControllerTool : NSObject
single_interface(Hi_RootControllerTool)

- (void)chooseRootController:(Hi_RootControllerHelperStyle)rootControllerHelperStyle;
/**
 *  初次选择根控制器
 */
- (void)chooseRootControllerFirstState:(ROOT_CONTROLLER_STATE_TYPE)state;


@end
