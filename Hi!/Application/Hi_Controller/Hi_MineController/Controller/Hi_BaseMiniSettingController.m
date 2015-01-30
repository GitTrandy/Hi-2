

#import "Hi_BaseMiniSettingController.h"
#import "DateEditController.h"
#import "EditViewController.h"
#import "Hi_AccountTool.h"
#import "Hi_HtmlViewController.h"
@interface Hi_BaseMiniSettingController ()
@end

@implementation Hi_BaseMiniSettingController
-(instancetype)initWithType:(MiniSettingControllerType)type{
    if (self = [super init]) {
        self.type=type;
    }
    return self;
}
/**
 *  加载 Account
 */
-(void)viewWillAppear:(BOOL)animated{
    
    if(![Hi_AccountTool getCurrentAccount]){
        return;
    }else{
        _account=[Hi_AccountTool getCurrentAccount];
    }
    
    [self setupGroup0];
    
    
}
- (void)viewDidLoad {
    
    
    self.title=@"个人详细信息";
    [super viewDidLoad];
    [self setupGroup0];
    [self setupGroup1];
    
    
    
    
}
#define NICKNAME_KEY @"昵称"
#define SEX_KEY @"性别"
#define PHONE_KEY @"手机"
#define TAG_KEY @"标签"
#define JOB_KEY @"职业"
#define BIRTHDAY_KEY @"生日"


- (void)setupGroup0{
    //  _listArray=[NSMutableArray arrayWithArray:@[@"昵称",@"性别",@"生日",@"手机",@"标签",@"职业",@""]];

    BaseSettingGroup *group = [BaseSettingGroup group];

    BaseSettingItem *item1=   [BaseSettingItem itemWithIcon:nil title:@"昵称" subTitle:_account.NickName settingItemSytle:BaseSettingItemSytleArrow option:nil];
    BaseSettingItem *item2 =  [BaseSettingItem itemWithIcon:nil title:@"性别" subTitle:_account.Sex settingItemSytle:BaseSettingItemSytleArrow option:nil];
    BaseSettingItem *item3 =  [BaseSettingItem itemWithIcon:nil title:@"手机" subTitle:_account.phone settingItemSytle:BaseSettingItemSytleBasic option:nil];
    BaseSettingItem *item4 =  [BaseSettingItem itemWithIcon:nil title:@"标签" subTitle:_account.Note settingItemSytle:BaseSettingItemSytleArrow option:nil];
    BaseSettingItem *item5 =  [BaseSettingItem itemWithIcon:nil title:@"职业" subTitle:_account.Jobs settingItemSytle:BaseSettingItemSytleArrow option:nil];
    BaseSettingItem *item6 =  [BaseSettingItem itemWithIcon:nil title:@"生日" subTitle:_account.Birthday settingItemSytle:BaseSettingItemSytleArrow option:nil];
    
  

    
    group.items=@[item1,item2,item3,item4,item5,item6];
    self.tableView.rowHeight=50;
    self.groups[0]=group;
    [self.tableView reloadData];

    
}
- (void)setupGroup1{

    BaseSettingGroup *group = [BaseSettingGroup group];
    
    BaseSettingItem *item1=[BaseSettingItem itemWithIcon:nil title:nil subTitle:@"关于《开心果》" settingItemSytle:BaseSettingItemSytleArrow option:nil];
    item1.settingItemInfo=@{BaseSettingItemSubTitleFont:[UIFont boldSystemFontOfSize:16],
                            BaseSettingItemSubTitleColor:[UIColor redColor]};
    
    group.items=@[item1];
    self.tableView.rowHeight=50;
    
    self.groups[1]=group;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    _curIndexPath=indexPath;
    BaseSettingGroup *group = self.groups[indexPath.section];
    BaseSettingItem *item = group.items[indexPath.row];
    if ([item.title isEqualToString:SEX_KEY]) {
        [self changeSex];
    }else if ([item.title isEqualToString:BIRTHDAY_KEY]){
        [self changeBrithDay];
    } else if ([item.title isEqualToString:PHONE_KEY]){
    }else if ([item.subtitle isEqualToString:@"关于《开心果》用户协议"]){
        // 创建URL
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"用户协议" withExtension:@"html"];
        Hi_HtmlViewController * htmlVC= [[Hi_HtmlViewController alloc]init];
        htmlVC.htmlPath=url;
        [self.navigationController pushViewController:htmlVC animated:YES];
    }else if ([item.title isEqualToString:@"头像"]) {
        [self changeImgView];
    }
    else{
    
        EditViewController * editCtrl =[[EditViewController alloc]init];
        BaseSettingCell * cell=(BaseSettingCell*)[tableView cellForRowAtIndexPath:indexPath];
        editCtrl.indexPath=indexPath;
        editCtrl.title=[NSString stringWithFormat:@"%@",item.title];
        editCtrl.tipkey=[NSString stringWithFormat:@"%@",item.title];;
        editCtrl.cell=cell;
        
        [self.navigationController pushViewController:editCtrl animated:YES];
    }

}
-(void)changeImgView{}
-(void)rightAction:(UIButton *)button{}
-(void)changeBrithDay{

    
    BaseSettingCell * cell=(BaseSettingCell*)[self.tableView cellForRowAtIndexPath:_curIndexPath];
    DateEditController * dateEdit = [[DateEditController alloc]init];
    dateEdit.cell=cell;
    [self.navigationController pushViewController:dateEdit animated:YES];
}
-(void)changeSex{

    UIActionSheet * actionSheet = [[UIActionSheet alloc]initWithTitle:@"你的性别" delegate:nil cancelButtonTitle:@"男" destructiveButtonTitle:@"女" otherButtonTitles:nil];
    [actionSheet showInView:self.view withCompletionHandler:^(NSInteger buttonIndex) {
        BaseSettingCell * cell=(BaseSettingCell*)[self.tableView cellForRowAtIndexPath:_curIndexPath];
        if (buttonIndex==0) {
            cell.item.subtitle=@"女";
            [self updateAccount:AccountTypeSex content:@"1"];

        }else{
            cell.item.subtitle=@"男";
            [self updateAccount:AccountTypeSex content:@"0"];
        }
        [self.tableView reloadRowsAtIndexPaths:@[_curIndexPath] withRowAnimation:UITableViewRowAnimationFade];
        cell.subtitleLabel.text=cell.item.subtitle;
        _account.Sex=cell.item.subtitle;
        [Hi_AccountTool saveCurrentAccount:_account];

    }];
 
}
-(void)updateAccount:(AccountType)type
             content:(NSString*)content{
    
    [Hi_AccountTool UpdateUserType:type content:content success:^(id result) {
        if (!result) {
            [JDStatusBarNotification showWithStatus:@"服务器暂时休息了,修改失败" dismissAfter:1];
        }
    } failure:^(NSError *error) {
        [JDStatusBarNotification showWithStatus:@"服务器暂时休息了,修改失败" dismissAfter:1];
    }];
     
}
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//
//    BaseSettingGroup *group = self.groups[indexPath.section];
//    BaseSettingItem *item = group.items[indexPath.row];
//    if ([item.title isEqualToString:@"标签"]) {
//        
//        return 100;
//    }else{
//    
//       return  self.tableView.rowHeight;
//    }
//}

@end
