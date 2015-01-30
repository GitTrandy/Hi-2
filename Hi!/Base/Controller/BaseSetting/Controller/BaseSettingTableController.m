
#define BaseSettingCellMargin 10

#import "BaseSettingTableController.h"


@interface BaseSettingTableController ()

@end

@implementation BaseSettingTableController

/**
 *  懒加载表格组
 */
- (NSMutableArray *)groups
{
    if (_groups == nil) {
        _groups = [NSMutableArray array];
    }
    return _groups;
}

- (BaseSettingGroup *)addGroup
{
    BaseSettingGroup *group = [BaseSettingGroup group];
    [self.groups addObject:group];
    return group;
}



-(UITableView *)tableView{

    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundView = nil;
        
       _tableView.sectionHeaderHeight = 0; // 每一组的头部高度
       _tableView.sectionFooterHeight = BaseSettingCellMargin; // 每一组的尾部高度
        
        // 底部控件
        UIView *footer = [[UIView alloc] init];
        footer.frame = CGRectMake(0, 0, 0, 1);
        _tableView.tableFooterView = footer;
    }
    return _tableView;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    
  //  self.tableView.contentInset = UIEdgeInsetsMake(BaseSettingCellMargin - 33, 0, 0, 0);

}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.groups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    BaseSettingGroup *group = self.groups[section];
    return group.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BaseSettingCell *cell = [BaseSettingCell cellWithTableView:tableView];
    cell.indexPath = indexPath;
    BaseSettingGroup *group = self.groups[indexPath.section];
    cell.item = group.items[indexPath.row];
    return cell;
}
#pragma mark Header-Footer
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    BaseSettingGroup *group = self.groups[section];
    return group.footer;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    BaseSettingGroup *group = self.groups[section];
    return group.header;
}

#pragma mark  Header-Footer-View
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    BaseSettingGroup *group = self.groups[section];
    return group.headerView;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    BaseSettingGroup *group = self.groups[section];
    return group.footerView;
    
}
#pragma mark -点击
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    BaseSettingGroup *group = self.groups[indexPath.section];
//    BaseSettingItem* item = group.items[indexPath.row];
    
//    if (item.option) {
//        item.option(item);
//    }
    
    

}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 15;
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    [self.view endEditing:YES];
}
@end
