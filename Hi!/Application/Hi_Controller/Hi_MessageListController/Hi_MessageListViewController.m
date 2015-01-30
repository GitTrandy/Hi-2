//
//  Hi_MessageListViewController.m
//  Hi!
//
//  Created by 伍松和 on 14/11/27.
//  Copyright (c) 2014年 伍松和. All rights reserved.
//

#import "Hi_MessageListViewController.h"
#import "Hi_MessageDetailController.h"
#import "FMDBTool.h"
#import "Hi_NotificationTool.h"
@implementation Hi_MessageListViewController

-(void)viewDidLoad{
    
    [super viewDidLoad];


}
-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadLocalData) name:NOTIFICATION_MESSAGE_UPDATED object:nil];


//
    //3.加载数据
    [self loadLocalData];


}
-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];

 

}
-(void)viewDidAppear:(BOOL)animated{
   
        
    if (self.isFirstLoading) {
        [self.tableView showActivityOverView:self.view.bounds WithStyle:UIActivityIndicatorViewStyleGray];
    }

      // [self loadMoreData];
    
    
  
}
-(void)loadLocalData{

    [Hi_ThreadTool ES_AsyncConcurrentOperationQueueBlock:^{
        self.dataSource =[Hi_SMSModel queryFormDBComplexSQL:HI_SMS_LIST_SQL];
    } MainThreadBlock:^{
        if (self.dataSource) {
            [self reloadTableData];
        }
    }];

}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString * cellID= @"msg_cell";
    Hi_TableViewCell * cell = [Hi_TableViewCell configureCellWithClass:[Hi_TableViewCell class] WithCellID:cellID WithTableView:tableView];
    cell.smsModel=self.dataSource[indexPath.row];
    [cell addActionBlock:^(id objectData, NSInteger buttonTag) {
        [self jumpToPerson:indexPath];
    }];
    
   MGSwipeButton * b1= [MGSwipeButton buttonWithTitle:@"   删除   " backgroundColor:[UIColor redColor] callback:^BOOL(MGSwipeTableCell *sender) {
       [self deleteToChat:indexPath];
        return YES;
    }];
    cell.rightButtons =@[b1];

    cell.tag=indexPath.row;
    return cell;
}
#pragma mark -删除单一对话
-(void)deleteToChat:(NSIndexPath*)indexPath{
    Hi_SMSModel * smsModel=self.dataSource[indexPath.row];
    [self.dataSource removeObject:smsModel];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
    [Hi_ThreadTool ES_AsyncConcurrentOperationQueueBlock:^{
        [Hi_SMSModel deleteWithWhere:HI_SMS_UID_CONDITION(smsModel.u_uid)];
    }];

    
}

#pragma mark -到个人页面
-(void)jumpToPerson:(NSIndexPath*)indexPath{
    
    Hi_SMSModel *smsModel=self.dataSource[indexPath.row];
    Hi_UserDetailController * userDetail = [[Hi_UserDetailController alloc]init];
    userDetail.user_id=smsModel.u_uid;
    [self.navigationController pushViewController:userDetail animated:YES];
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

   
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Hi_MessageDetailController * detailCtrl = [[Hi_MessageDetailController alloc]init];
    Hi_SMSModel * smsModel = self.dataSource[indexPath.row];
    detailCtrl.title=smsModel.u_name;
    Hi_UserModel* userModel =[smsModel getUserModelFromUID:smsModel.u_uid];
    if (userModel) {
        detailCtrl.userModel=userModel;
        [self.navigationController pushViewController:detailCtrl animated:YES];
    }else{
        return;
    }
  //-  detailCtrl.miniImage=[[Hi_AccountTool getCurrentAccount]image];
    
//    NSData * imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:smsModel.head]];
//    detailCtrl.otherImage=[UIImage imageWithData:imageData];
    
    

    

    
}
-(void)loadFirstData{
    
    if (!MY_USER_FIRST_LOAD_MSG_LIST||[[Hi_SMSModel queryFormDB:nil orderBy:nil count:5 success:nil] count]<=0) {
        [self loadMoreData];
    }else{
        [self loadLocalData];
    }
}
-(void)loadMoreData{
    
    
    
    NSString * time=[Hi_SMSModel hi_sms_detail_max_time:nil];
    [Hi_SmsTool getSMSTimeWith:time WithID:0 success:^(id result) {
        
        SAVE_USER_FIRST_LOAD_MSG_LIST(USER_FIRST_LOAD_MSG_LIST);
        [self loadLocalData];
        
    } failure:^(NSError *error) {
        [self loadLocalData];
    }];
    
}
-(UIImage*)imageForEmptyDataSet:(UIScrollView *)scrollView{return [UIImage imageNamed:@"em_3"];}
-(NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView{
    NSDictionary *attributes= @{NSFontAttributeName:[UIFont boldSystemFontOfSize:14.0],NSForegroundColorAttributeName:[UIColor lightGrayColor]};
    NSAttributedString * string =[[NSAttributedString alloc]initWithString:@"目前没有对话呢" attributes:attributes];
    return string;
}
@end
