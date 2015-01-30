
#import "Hi_MineViewController.h"
#import "Hi_MineSettingController.h"
#import "Hi_MiniPhotoWallController.h"
#import "Hi_AccountTool.h"

@implementation Hi_MineViewController

-(void)setupHeader{
  
    [super setupHeader];
     self.profileView.account=self.account;
    WEAKSELF;
    [self.profileView addActionBlock:^(id objectData, NSInteger buttonTag) {
        Hi_MiniPhotoWallController * photoWall = [[Hi_MiniPhotoWallController alloc]init];
        [weakSelf.navigationController pushViewController:photoWall animated:YES];
    }];
    
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self setupHeader];
    [self setupGroup1];
    
}
-(Hi_Account *)account{
   return [Hi_AccountTool getCurrentAccount];
}
- (void)setupGroup1{
    
    BaseSettingGroup *group = [BaseSettingGroup group];
    
    BaseSettingItem *item1 =  [BaseSettingItem itemWithIcon:@"contact_tag" title:nil  subTitle:self.account.Note settingItemSytle:BaseSettingItemSytleBasic option:nil];
    item1.settingItemInfo=@{BaseSettingItemSubTitleFont:[UIFont boldSystemFontOfSize:15],
                            BaseSettingItemSubTitleColor:[UIColor lightGrayColor]};
    
    BaseSettingItem *item2 =  [BaseSettingItem itemWithIcon:@"contact_list_small" title:nil  subTitle:self.account.CurrentState settingItemSytle:BaseSettingItemSytleBasic option:nil];
    item2.settingItemInfo=@{BaseSettingItemSubTitleFont:[UIFont boldSystemFontOfSize:15],
                            BaseSettingItemSubTitleColor:[UIColor lightGrayColor]};
    
    BaseSettingItem *item3 =  [BaseSettingItem itemWithIcon:nil title:@"设置" subTitle:nil settingItemSytle:BaseSettingItemSytleArrow option:nil];
    
    group.items=@[item1,item2,item3];
    self.tableView.rowHeight=55;
    self.groups[0]=group;
    [self.tableView reloadData];
    
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([indexPath isEqual:[NSIndexPath indexPathForRow:2 inSection:0]]) {
        [self jumpToSetting];
    }
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{return 10;}

#pragma mark -跳转设置
-(void)jumpToSetting{
    
    
    
    
    Hi_MineSettingController * settingCtrl=[[Hi_MineSettingController alloc]init];
    [self.navigationController pushViewController:settingCtrl animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
      return  self.tableView.rowHeight;
}



@end
