

#import "Hi_PhoneRegisterController.h"
#import "Hi_PhoneVerifyController.h"
@interface Hi_PhoneRegisterController ()


@end

@implementation Hi_PhoneRegisterController
-(instancetype)init{
    
    if (self=[super init]) {
        self.input_controllerType=BaseInputControllerTypeResgister;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //1,
    self.navigationItem.leftBarButtonItem=[UIBarButtonItem itemWithTitle:@"返回" themeColor:[UIColor whiteColor] target:self action:@selector(dismiss)];
    self.title=@"手机注册";
    
    //2
    [self setupGroupA];
    
    
}
-(void)setupGroupA{
    BaseSettingGroup *group = [BaseSettingGroup group];
    
    BaseSettingItem * itemA = [BaseSettingItem itemWithIcon:@"person_activity" title:nil subTitle:@"中国(+86)" settingItemSytle:BaseSettingItemSytleArrow option:^(id result) {
    }];
    BaseSettingItem * itemB = [BaseSettingItem itemWithIcon:@"person_mobile" title:nil keyboardType:UIKeyboardTypeNumberPad placeholder:@"请输入手机" isSecure:NO isFirstResponser:YES option:^(UITextField *textField) {
        self.phoneNum=textField.text;
    }];
    BaseSettingItem * itemC = [BaseSettingItem itemWithIcon:@"person_password" title:nil keyboardType:UIKeyboardTypeDefault placeholder:@"请输入6位以上密码" isSecure:YES isFirstResponser:NO option:^(UITextField *textField) {
        
        self.passwordNum=textField.text;
        if (self.phoneNum.length==11&&self.passwordNum.length>=6) {
            self.bottomButton.enabled=YES;
        }else{
            self.bottomButton.enabled=NO;
        }
    }];
    
    group.items=@[itemA,itemB,itemC];
    group.footerView=[self get_bottomViewButton:YES buttonTitle:@"下一步" isText:YES footerBlock:^(id sender) {
        [self footerAction:sender];
    }];
    self.tableView.rowHeight=48;
    self.groups[0]=group;

}
#define RESGITER_BEGIN_STATE @"验证手机中"
#define RESGITER_RE_ERROR_STATE @"手机重复注册,请返回登录"
#define RESGITER_BING_ERROR_STATE @"手机绑定超时哦,再试试看"
#define RESGITER_BING_SUCCESS_STATE @"绑定成功,注册后,手机不可以更改"
#define RESGITER_NEXT_STEP @"下一步"
-(void)footerAction:(UIButton*)button{

    //1.做检测 ->手机注册了,提示去登录
                //->没有就提示下面那个
    
    [self button_start_animation_text:RESGITER_BEGIN_STATE btn:button];

    [Hi_AccountTool BindPhone:self.phoneNum success:^(id result) {
        if (!result) {
            UIWINDOW_FAILURE(RESGITER_RE_ERROR_STATE);
            [self button_stop_animation_text:RESGITER_NEXT_STEP btn:button];

        }else{
            
            [self send_verify_code:button];
        }
    } failure:^(NSError *error) {
        UIWINDOW_FAILURE(RESGITER_RE_ERROR_STATE);
        [self button_stop_animation_text:RESGITER_NEXT_STEP btn:button];

    }];
    
   
    
    
}
-(void)send_verify_code:(UIButton*)button{

    
    
    
//    [AVOSCloud verifySmsCode:self.hi_phoneVerifyNum callback:^(BOOL succeeded, NSError *error) {
//        if (!succeeded) {
//            [JDStatusBarNotification showWithStatus:@"验证失败,手机可能已经注册过了" dismissAfter:5.0 styleName:JDStatusBarStyleSuccess];
//            [SVProgressHUD dismiss];
//            return;
//            
//        }
//        
//    }];

    
    [AVOSCloud requestSmsCodeWithPhoneNumber:self.phoneNum appName:@"开心果" operation:@"获取验证码" timeToLive:10 callback:^(BOOL succeeded, NSError *error) {
        if (!succeeded) {
            //3.发送失败
            UIWINDOW_FAILURE(RESGITER_RE_ERROR_STATE);
            
        }else{
            //3.发送成功
            UIWINDOW_SUCCESS(RESGITER_BING_SUCCESS_STATE);//(@"正在发送验证码");
            Hi_PhoneVerifyController * phoneVerify =[[Hi_PhoneVerifyController alloc]init];
            phoneVerify.phoneNum=self.phoneNum;
            phoneVerify.passwordNum=self.passwordNum;
            [self.navigationController pushViewController:phoneVerify animated:YES];
            
        }
        [self button_stop_animation_text:RESGITER_NEXT_STEP btn:button];

        
    }];
}
#pragma mark -下一步


@end
