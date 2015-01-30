#import "Hi_HomeSettingController.h"
#import "Hi_TextComposeViewController.h"
@interface Hi_HomeSettingController ()
@property (assign,nonatomic)BOOL isLocation;
@property (assign,nonatomic)BOOL isMessage;

@end

@implementation Hi_HomeSettingController

-(void)viewDidLoad{

    [super viewDidLoad];
    self.title =@"现场设置";
    
   
}


-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=NO;
    if ([Hi_AccountTool getCurrentAccount]) {
        self.account=[Hi_AccountTool getCurrentAccount];
        _isLocation=self.account.isLocation;
        _isMessage=self.account.isMessage;
        [self setupHeader];
        [self setupGroup1];
        [self setupFooter];
    }
    
}
-(void)setupHeader{
    
    [super setupHeader];
    self.profileView.account=self.account;
    
}

-(void)setLocationAndMessage{

    [Hi_AccountTool UpdateUserLocation:_isLocation ae:_isMessage success:^(id result) {
        self.account.isLocation=_isLocation;
        self.account.isMessage=_isMessage;
        [Hi_AccountTool saveCurrentAccount:self.account];
    } failure:^(NSError *error) {
        NSLog(@"设置失败");
    }];
}
- (void)setupGroup1{
    
    
//    self.account=[Hi_AccountTool getCurrentAccount];
    BaseSettingGroup *group = [BaseSettingGroup group];
    
    BaseSettingItem *item1 =  [BaseSettingItem itemWithIcon:@"live_list" title:nil  subTitle:self.account.CurrentState settingItemSytle:BaseSettingItemSytleArrow option:nil];
    BaseSettingItem *item2 =  [BaseSettingItem itemWithIcon:nil title:@"允许显示我的位置" subTitle:nil isOption:_isLocation settingItemSytle:BaseSettingItemSytleSwitch option:^(id result) {
        _isLocation =[result boolValue];
        [self setLocationAndMessage];
    }];
    
    BaseSettingItem *item3 =  [BaseSettingItem itemWithIcon:nil title:@"允许向我发送消息" subTitle:nil isOption:_isMessage  settingItemSytle:BaseSettingItemSytleSwitch option:^(id result) {
        _isMessage =[result boolValue];
        [self setLocationAndMessage];
    }];

    group.items=@[item1,item2,item3];
    self.tableView.rowHeight=55;
    
    self.groups[0]=group;
    
    [self.tableView reloadData];
    
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row==0) {
        Hi_TextComposeViewController * textCtrl =[[Hi_TextComposeViewController alloc]initWithState:Hi_TextComposeStateChangeState];
        textCtrl.title = @"更改状态";
        [self.navigationController pushViewController:textCtrl animated:YES];
    }
}
#define TableBorder 5

- (void)setupFooter
{
    // 按钮
    UIButton *logoutButton = [[UIButton alloc] init];
    CGFloat logoutX = TableBorder + 2;
    CGFloat logoutY = 0;
    CGFloat logoutW = self.tableView.frame.size.width - 2 * logoutX;
    CGFloat logoutH = 50;
    logoutButton.frame = CGRectMake(logoutX, logoutY, logoutW, logoutH);
    
    // 背景和文字
    [logoutButton setImage:[UIImage imageNamed:@"live_enter"] forState:UIControlStateNormal];
    [logoutButton addTarget:self action:@selector(pop:) forControlEvents:UIControlEventTouchUpInside];
    logoutButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [logoutButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    // footer
    UIView *footer = [[UIView alloc] init];
    CGFloat footerH = logoutH + TableBorder;
    footer.frame = CGRectMake(0, 0, 0, footerH);
    self.tableView.tableFooterView = footer;
    
    [footer addSubview:logoutButton];
  
    
}

-(void)pop:(id)sender{[self.navigationController popViewControllerAnimated:YES];}
@end
