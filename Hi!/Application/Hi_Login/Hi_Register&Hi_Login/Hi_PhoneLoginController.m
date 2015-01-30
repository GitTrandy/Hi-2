//
//  Hi_PhoneLoginController.m
//  Hi!
//
//  Created by 伍松和 on 14/12/6.
//  Copyright (c) 2014年 伍松和. All rights reserved.
//

#import "Hi_PhoneLoginController.h"

@interface Hi_PhoneLoginController ()
@end

@implementation Hi_PhoneLoginController
-(instancetype)init{
    
    if (self=[super init]) {
        self.input_controllerType=BaseInputControllerTypeLogin;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //1,
    self.navigationItem.leftBarButtonItem=[UIBarButtonItem itemWithTitle:@"返回" themeColor:[UIColor whiteColor] target:self action:@selector(dismiss)];
    self.title=@"手机登录";
    
    //2
    [self setupGroupA];
   
    
    
}
-(void)setupGroupA{
    BaseSettingGroup *group = [BaseSettingGroup group];
    
  
    BaseSettingItem * itemA = [BaseSettingItem itemWithIcon:@"person_mobile" title:nil keyboardType:UIKeyboardTypeNumberPad placeholder:@"请输入手机" isSecure:NO isFirstResponser:YES option:^(UITextField *textField) {
        self.phoneNum=textField.text;
    }];
    BaseSettingItem * itemB = [BaseSettingItem itemWithIcon:@"person_password" title:nil keyboardType:UIKeyboardTypeDefault placeholder:@"请输入6位以上密码" isSecure:YES isFirstResponser:NO option:^(UITextField *textField) {
        
        self.passwordNum=textField.text;
        if (self.phoneNum.length==11&&self.passwordNum.length>=6) {
            self.bottomButton.enabled=YES;
        }else{
            self.bottomButton.enabled=NO;
        }
    }];
    
    group.items=@[itemA,itemB];
    group.footerView=[self get_bottomViewButton:YES buttonTitle:@"登录" isText:YES footerBlock:^(id sender) {
        [self nextAction:sender];
    }];
    self.tableView.rowHeight=48;
    self.groups[0]=group;
    
}
#define LOGIN_ACCOUNT_ERROR @"帐号没注册或者帐号密码错误"
#define LOGIN_NETWORKING_ERROR @"网络错误,请联系:peter@wisdomeng.com"
-(void)nextAction:(UIButton*)button{

    
    [self button_start_animation_text:@"正在登录" btn:button];

    [Hi_AccountTool loginWithUserName:self.phoneNum password:self.passwordNum Success:^(id result) {
        if (!result) {
            UIWINDOW_FAILURE(LOGIN_ACCOUNT_ERROR)
            
        }else{
            UIWINDOW_SUCCESS(@"登录成功");
        }
        [self button_stop_animation_text:@"登录" btn:button];
        //        [UIWindow dismissWithHUD];
        
    } failure:^(NSError *error) {
        UIWINDOW_FAILURE(LOGIN_NETWORKING_ERROR)
        [self button_stop_animation_text:@"登录" btn:button];
        
        
    }];
}

@end
