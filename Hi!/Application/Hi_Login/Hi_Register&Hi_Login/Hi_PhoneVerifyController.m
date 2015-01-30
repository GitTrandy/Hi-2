

#import "Hi_PhoneVerifyController.h"

@interface Hi_PhoneVerifyController ()
@property (nonatomic,copy)  NSString    * phoneVerifyNum;
@property (nonatomic,strong)NSDate      * hi_fireDate;
@property (nonatomic,strong)NSTimer     * hi_timer;
@end

@implementation Hi_PhoneVerifyController
-(instancetype)init{
    
    if (self=[super init]) {
        self.input_controllerType=BaseInputControllerTypeVerify;
    }
    return self;
}
#define HI_TIME_NUMBER 20
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"输入验证码";
    [self setupGroupA];
//    [self timeAction];
    
  
    
}


-(void)setupGroupA{
    BaseSettingGroup *group = [BaseSettingGroup group];
    
    
  
    BaseSettingItem * itemA = [BaseSettingItem itemWithIcon:@"person_password" title:nil keyboardType:UIKeyboardTypeNumberPad placeholder:@"请输入验证码" isSecure:NO isFirstResponser:YES option:^(UITextField *textField) {
         self.phoneVerifyNum=textField.text;
        self.bottomButton.enabled=(self.phoneVerifyNum.length>=1);
    }];
    
    group.items=@[itemA];
    group.footerView=[self get_bottomViewButton:YES buttonTitle:@"注册" isText:YES footerBlock:^(id sender) {
        [self registerAction:sender];
    }];
    self.tableView.rowHeight=48;
    self.groups[0]=group;
    
}
#define VERIFY_BEGIN @"正在发送验证码.."
#define VERIFY_TIP @"注册成功,请认真填写你的姓名,工作,标签"
#define VERIFY_ERROR @"帐号注册错误,请联系:peter@wisdomeng.com"
#define VERIFY_NETWORK_ERROR @"网络错误,重试还是不行,请联系:peter@wisdomeng.com"
#define VERIFY_BUTTON_TIP @"注册"

-(void)registerAction:(UIButton*)button{


    [self button_start_animation_text:VERIFY_BEGIN btn:button];
    
    
    [Hi_AccountTool registerWithUserName:self.phoneNum password:self.passwordNum Success:^(id result) {
        if (!result) {
            UIWINDOW_FAILURE(VERIFY_ERROR);
        }else{
            UIWINDOW_SUCCESS(VERIFY_TIP);
        }
        [self button_stop_animation_text:VERIFY_BUTTON_TIP btn:button];
    } failure:^(NSError *error) {
        UIWINDOW_FAILURE(VERIFY_NETWORK_ERROR);
        [self button_stop_animation_text:VERIFY_BUTTON_TIP btn:button];
    }];
    
   
}

#pragma mark -定时器

//-(void)timeAction{
//    _hi_timer= [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
//    [[NSRunLoop currentRunLoop] addTimer:_hi_timer forMode:NSDefaultRunLoopMode];
//    _hi_fireDate=[NSDate date];
//}
//-(void)timerFired:(NSTimer*)timer{
//    
//    
//    CGFloat num=[timer.fireDate timeIntervalSinceDate:_hi_fireDate];
//    
//    
//    int timeNum=(int)[timer.fireDate timeIntervalSinceDate:_hi_fireDate];
//    NSString * timeleft=[NSString stringWithFormat:@"重新发送验证码:%d秒",HI_TIME_NUMBER-1-timeNum];
//    [self.actionButton setTitle:timeleft forState:UIControlStateNormal];
//    if (num>(HI_TIME_NUMBER-1)) {
//        self.actionButton.enabled=YES;
//        [self.actionButton setTitle:@"发送验证码" forState:UIControlStateNormal];
//        [timer invalidate];
//        
//    }else{
//        self.actionButton.enabled=NO;
//    }
//}
//-(void)dealloc{
//    [_hi_timer invalidate];
//}

@end
