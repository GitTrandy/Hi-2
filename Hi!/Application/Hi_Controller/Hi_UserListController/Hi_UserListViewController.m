//
//  Hi_UserListViewController.m
//  Hi!
//
//  Created by 伍松和 on 14/11/27.
//  Copyright (c) 2014年 伍松和. All rights reserved.
//

#import "Hi_UserListViewController.h"

@interface Hi_UserListViewController ()

@end

@implementation Hi_UserListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
  //  [self.tableView removeHeader];
    if ([[Hi_UserModel queryFormDB:nil orderBy:nil count:2 success:nil] count]>0) {
        [self loadLocalData];

    }else{
     [self.tableView headerBeginRefreshing];
    }

}
-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
//    [self loadMoreData];

}
-(void)viewDidDisappear:(BOOL)animated{

    

}

-(void)loadMoreData{
    
    
    //getFriendSuccess getWifiMembersSuccess
    [Hi_UserTool getFriendSuccess:^(NSArray *results) {
        [self loadLocalData];
        [self reloadTableData];

    } failure:^(NSError *error) {
        [self reloadTableData];
        
    }];
    
    
}
-(void)loadLocalData{

    self.dataSource = [Hi_UserModel queryFormDB:nil orderBy:nil count:20 success:nil];
    [self reloadTableData];

}
//-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{return 20;}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    static NSString * cellID= @"user_cell";
    Hi_TableViewCell * cell = [Hi_TableViewCell configureCellWithClass:[Hi_TableViewCell class] WithCellID:cellID WithTableView:tableView];
    cell.rightLab.hidden=YES;
    Hi_UserModel * curUser=self.dataSource[indexPath.row];
    cell.userModel=curUser;
    cell.rightButtons=[self createRightButtons:curUser indexPath:indexPath];
    cell.tag=indexPath.row;
    return cell;
}



-(NSArray *) createRightButtons:(Hi_UserModel*)userModel
                               indexPath:(NSIndexPath*)indexPath
{
    NSMutableArray * result = [NSMutableArray array];
    NSArray * titleArray =nil;
    NSArray *colorArray=nil;
    switch (userModel.type) {
        case Hi_UserModelRelationTypeFan:
            titleArray=@[@"  对话  ",@"  关注TA  "];
            break;
        case Hi_UserModelRelationTypeFollow:
            titleArray=@[@"  对话  ",@"  取消关注  "];
            break;
        case Hi_UserModelRelationTypeEachOther:
           titleArray=@[@"  对话  ",@"  取消关注  "];
            break;
            
        default:
            break;
    }
    colorArray=@[[UIColor redColor],[UIColor lightGrayColor]];
    for (int i = 0; i < titleArray.count; ++i)
    {
        
        MGSwipeButton * button=nil;
        button.tag=i;
        if (i==0) {
            button = [MGSwipeButton buttonWithTitle:titleArray[i] backgroundColor:colorArray[i] callback:^BOOL(MGSwipeTableCell *sender) {
                [self jumpToChat:indexPath];
                return YES;
            }];
        }else if (i==1){
            button = [MGSwipeButton buttonWithTitle:titleArray[i] backgroundColor:colorArray[i] callback:^BOOL(MGSwipeTableCell *sender) {
               //[self jumpToPerson:indexPath];
                return YES;
            }];
        }
        
        
        [result addObject:button];
    }
    return result;
}
#pragma mark -到个人页面
-(void)jumpToPerson:(NSIndexPath*)indexPath{
    
    Hi_UserModel *userModel=self.dataSource[indexPath.row];
    Hi_UserDetailController * userDetail = [[Hi_UserDetailController alloc]init];
    userDetail.userModel=userModel;
    [self.navigationController pushViewController:userDetail animated:YES];
    
}
#pragma mark -到聊天页面
-(void)jumpToChat:(NSIndexPath*)indexPath{
    
    Hi_MessageDetailController * detailCtrl = [[Hi_MessageDetailController alloc]init];
    Hi_UserModel*userModel=self.dataSource[indexPath.row];
    detailCtrl.userModel=userModel;
    detailCtrl.title=userModel.nickName;
    [self.navigationController pushViewController:detailCtrl animated:YES];
}
#pragma mark -关注接口
-(void)followUser:(Hi_UserModelRelationType)type{
    

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self jumpToPerson:indexPath];
   
}
-(UIImage*)imageForEmptyDataSet:(UIScrollView *)scrollView{return [UIImage imageNamed:@"em_3"];}
-(NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView{
    NSDictionary *attributes= @{NSFontAttributeName:[UIFont boldSystemFontOfSize:14.0],NSForegroundColorAttributeName:[UIColor lightGrayColor]};
    NSAttributedString * string =[[NSAttributedString alloc]initWithString:@"目前没好友呢" attributes:attributes];
    return string;
}

@end
