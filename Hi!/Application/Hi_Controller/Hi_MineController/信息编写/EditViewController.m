

#import "EditViewController.h"
#import "BaseSettingCell.h"
@interface EditViewController ()<UITextFieldDelegate>

@end

@implementation EditViewController
@synthesize messageTextField;

#define SYSTEM_URL [[NSBundle mainBundle]URLForResource:@"Hi_AccountConfig" withExtension:@"plist"]
#define SYSTEM_URL_DIC [NSDictionary dictionaryWithContentsOfURL:SYSTEM_URL]
#define ES_PERSON_Tip SYSTEM_URL_DIC[@"PERSON_TIP_INFO"]
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.account=[Hi_AccountTool getCurrentAccount];
    
    //数据
    self.view.backgroundColor=kColor(239, 239, 239);

    //视图
    [self addTextSubViews];
  
   
}
-(AccountType)GET_ACCOUNT_TYPE_AND_SAVE_ACCOUNT:(NSString*)content{

    
    AccountType accountType=AccountTypeNone;
    if (self.indexPath.section==0) {
        //头像
        switch (self.indexPath.row) {
            case 0:
                self.account.NickName=content;
                accountType= AccountTypeName;
                break;
            case 1:
                self.account.NickName=content;
                accountType= AccountTypeName;
                break;
            case 3:
                self.account.Note=content;
                accountType=AccountTypeNote;
                break;
            case 4:
                self.account.Jobs=content;
                accountType=AccountTypeJob;
                break;
                
                default:
                accountType= AccountTypeNone;
                
        }
        [Hi_AccountTool saveCurrentAccount:self.account];
        return accountType;

    }else{
        return AccountTypeNone;

    }

}
#pragma mark -纯文字
-(void)addTextSubViews{
    

    
    

    
    //1.输入栏
    messageTextField = [[UITextField alloc] initWithFrame:CGRectMake(5, 80, ScreenWidth-10, 50)];
    messageTextField.backgroundColor=[UIColor whiteColor];
//    messageTextField.textColor = ES_SYSTEM_COLOR; //text color
    messageTextField.borderStyle= UITextBorderStyleRoundedRect;
    messageTextField.delegate=self;
    messageTextField.font = [UIFont systemFontOfSize:18.0];  //font size
  //
    messageTextField.clearButtonMode=UITextFieldViewModeAlways;
    

    if ([self.cell.item.subtitle isEqualToString:@"未填写"]) {
         messageTextField.text=@"";
    }else{
        messageTextField.text= self.cell.item.subtitle;
    }
    
    //2.下面加一个label
    self.tipLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, messageTextField.bottom+3, ScreenWidth-20, 40)];
    self.tipLabel.font=[UIFont boldSystemFontOfSize:13];
    self.tipLabel.textColor=[UIColor lightGrayColor];
    self.tipLabel.numberOfLines=0;
    NSLog(@"%@",ES_PERSON_Tip[self.tipkey]);
    self.tipLabel.text=ES_PERSON_Tip[self.tipkey];
    [self.view addSubview:self.tipLabel];

    [self.view addSubview:messageTextField];
    
}



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [messageTextField becomeFirstResponder];

}

-(void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
    [messageTextField resignFirstResponder];
}


#pragma mark -左右


#pragma mark -编写完毕
-(void)rightBtnAction:(UIButton *)rightBtn{
    
    
    self.cell.item.subtitle=messageTextField.text;
    AccountType accountType = [self GET_ACCOUNT_TYPE_AND_SAVE_ACCOUNT:messageTextField.text];
    [self.navigationController popViewControllerAnimated:YES];
    UIWINDOW_STATE_SHOW(@"正在修改");
    [Hi_AccountTool UpdateUserType:accountType content:messageTextField.text success:^(id result) {
        if (!result) { UIWINDOW_FAILURE(@"服务器暂时休息了,修改失败");}
        else{UIWINDOW_SUCCESS(@"修改成功");}

    } failure:^(NSError *error) {
        UIWINDOW_FAILURE(@"服务器暂时休息了,修改失败");
    }];
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;
}






@end
