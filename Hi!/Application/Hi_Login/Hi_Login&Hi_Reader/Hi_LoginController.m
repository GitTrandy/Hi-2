
#import "Hi_LoginController.h"
#import "Hi_PhoneLoginController.h"
#import "Hi_PhoneRegisterController.h"
#import "Hi_HtmlViewController.h"

#import "Hi_AccountTool.h"
#import "UIWindow+JJ.h"

@interface Hi_LoginController ()
@property (weak, nonatomic) IBOutlet UIButton *readerStatementBtn;
@property (weak, nonatomic) IBOutlet UIButton *readerSelectBtn;

@end

@implementation Hi_LoginController

-(void)viewWillAppear:(BOOL)animated{

    if (self.navigationController) {
        self.navigationController.navigationBarHidden=YES;
    }
}
-(void)viewWillDisappear:(BOOL)animated{
    
    if (self.navigationController) {
        self.navigationController.navigationBarHidden=NO;
    }
}
#pragma mark -QQ登录接口
- (IBAction)QQLoginAction:(id)sender {
    
    
    [UIWindow showWithHUDStatus:@"正在登录"];
//    [SVProgressHUD showWithStatus:@"正在登录"];

    [Hi_AccountTool loginWithType:LOGINCloudSNSQQ];
    
    
}
#pragma mark -新浪微博登录
- (IBAction)WeiboLoginAction:(id)sender {
    [UIWindow showWithHUDStatus:@"正在登录"];
    [Hi_AccountTool loginWithType:LOGINSinaWeibo];
    
    
    
}
- (IBAction)phoneLogin:(UIButton *)sender {
    
    Hi_PhoneLoginController * phoneLogin = [[Hi_PhoneLoginController alloc]init];
    [self.navigationController pushViewController:phoneLogin animated:YES];
    if (self.navigationController) {
        self.navigationController.navigationBarHidden=NO;
    }
    
}
- (IBAction)phoneRegister:(id)sender {
    
    Hi_PhoneRegisterController*phoneRegister=[[Hi_PhoneRegisterController alloc]init];
    [self.navigationController pushViewController:phoneRegister animated:YES];
    if (self.navigationController) {
        self.navigationController.navigationBarHidden=NO;
    }

    
}
- (IBAction)readerAction:(id)sender {
    
    // 创建URL
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"用户协议" withExtension:@"html"];
    Hi_HtmlViewController * htmlVC= [[Hi_HtmlViewController alloc]init];
    htmlVC.htmlPath=url;
    [self.navigationController pushViewController:htmlVC animated:YES];
    
}
- (IBAction)readerBtn:(id)sender {
    
    UIButton * btn = (UIButton *)sender;
    btn.selected=!btn.selected;
    
    if (btn.selected) {
        [self.readerStatementBtn setTitle:@"已经阅读了《\"开心果\"的用户协议》" forState:UIControlStateNormal];
    }else{
        [self.readerStatementBtn setTitle:@"请确认阅读了《\"开心果\"的用户协议》" forState:UIControlStateNormal];

    }
}

@end
