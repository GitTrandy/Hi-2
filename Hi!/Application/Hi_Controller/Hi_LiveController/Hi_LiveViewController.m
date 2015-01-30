//
//  Hi_LiveViewController.m
//  Hi!
//
//  Created by 伍松和 on 14/11/27.
//  Copyright (c) 2014年 伍松和. All rights reserved.
//

#import "Hi_LiveViewController.h"
#import "Hi_HomeSettingController.h"
#import "Hi_PhoneRegisterController.h"
#import "Hi_LongMessageController.h"

@interface Hi_LiveViewController ()
@property (nonatomic,strong)Hi_BusinessModel * curBusinessModel;
@end

@implementation Hi_LiveViewController
#pragma mark -BID

-(void)viewbeAcive{

    
//    [[NSNotificationCenter defaultCenter]addObserver:self
//                                            selector:@selector(loadMoreData)
//                                                name:UIApplicationDidBecomeActiveNotification//UIApplicationWillResignActiveNotification
//                                              object:nil];
    
 }
-(void)connectionAndLoadData{

    self.title=@"连接中....";
    //A.更新
    //0.没有的话,就下线
    
    if ([UIDevice getWifiMacAddress]) {
        //1.
        [Hi_AccountTool updateUserWifiSuccess:^(id result) {
        } failure:^(NSError *error) {
        }];
        //2.
        [Hi_BusinessTool getBusinessWithWifiMacSuccess:^(id result) {
            if (result) {
                _curBusinessModel = ( Hi_BusinessModel *)result;
                self.title=[NSString stringWithFormat:@"\"%@\"的现场",_curBusinessModel.name];
            }else{
                _curBusinessModel = nil;
                self.title=@"现场";
            }
        } failure:^(NSError *error) {
           
        }];
    }else{
//        [Hi_AccountTool LoginOutSuccess:^(id result) {
//            //
//        } failure:^(NSError *error) {
//            //
//        }];
    }
   
    
}

-(void)viewWillAppear:(BOOL)animated{

    
    //1.更新
     self.title=@"连接中....";
    
    //2.改变
    [self loadMoreData];

    
    self.navigationItem.leftBarButtonItem =[UIBarButtonItem itemWithTitle:@"留言墙" themeColor:[UIColor whiteColor] target:self action:@selector(liveToLongMessage:)];
    self.leftButton=self.navigationItem.leftBarButtonItem.barButton;
}
-(void)viewDidAppear:(BOOL)animated{

    [self loadMoreData];
}
-(void)reloadTableData{
    
    [super reloadTableData];
}
#define NOTIFICATION_SESSION_UPDATED @"NOTIFICATION_SESSION_UPDATED" //状态更新

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self viewbeAcive];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTitle:@"设置" themeColor:[UIColor whiteColor] target:self action:@selector(liveToSetting:)];
    
    
    
}
-(void)connectionSession:(NSNotification*)nofi{
    
    NSString * titleDetail =self.title;
    NSString * isLive = [nofi.object boolValue]?@"(在线)":@"(断开)";
    self.title =[NSString stringWithFormat:@"%@%@",titleDetail,isLive];
}
-(void)loadMoreData{

    //1.链接
    [self connectionAndLoadData];

    //2.加载数据
    [Hi_UserTool getWifiMembersSuccess:^(NSArray *results) {
        if (results) {
            self.dataSource=[NSMutableArray arrayWithArray:results];
        }else{
            self.dataSource=nil;
            self.title= _curBusinessModel?self.title:@"现场";
        }
        [self reloadTableData];
    } failure:^(NSError *error) {
        self.title=@"现场";
      //  UIWINDOW_FAILURE(@"没有WIFI/WIFI信号好弱");
        [self reloadTableData];
    }];
    
    

}
-(void)refreshData:(UIBarButtonItem *)item{}

#pragma mark -留言
-(void)liveToLongMessage:(UIBarButtonItem *)item{

    Hi_LongMessageController * longMsgCtrl = [[Hi_LongMessageController alloc]init];

    if (![UIDevice getWifiMacAddress]) {
        UIWINDOW_FAILURE(@"当前不是WIFI环境");
        return;
    }
    longMsgCtrl.title=[NSString stringWithFormat:@"%@留言",_curBusinessModel?_curBusinessModel.name:[UIDevice getWifiMacAddress]];
    [self.navigationController pushViewController:longMsgCtrl animated:YES];
}
#pragma mark -设置
-(void)liveToSetting:(UIBarButtonItem *)item{

  //  Hi_PhoneRegisterController * phoneRegisterController = [[Hi_PhoneRegisterController alloc]init];
  
   Hi_HomeSettingController * homeSetting = [[Hi_HomeSettingController alloc]init];
   [self.navigationController pushViewController:homeSetting animated:YES];
    
}
//-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{return 20;}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    
    static NSString * cellID= @"live_cell";
    Hi_TableViewCell * cell = [Hi_TableViewCell configureCellWithClass:[Hi_TableViewCell class] WithCellID:cellID WithTableView:tableView];
    cell.rightLab.hidden=YES;
    cell.rightButtons=[self createRightButtons];
    cell.userModel=self.dataSource[indexPath.row];
    cell.tag=indexPath.row;
    
    
    return cell;
}

-(NSArray *) createRightButtons
{
    NSMutableArray * result = [NSMutableArray array];
    NSArray * titleArray=@[@"  查看资料  "];
    NSArray *colorArray=@[[UIColor lightGrayColor]];
    for (int i = 0; i < titleArray.count; ++i)
    {
        
        MGSwipeButton * button=nil;
        button.tag=i;
        button = [MGSwipeButton buttonWithTitle:titleArray[i] backgroundColor:colorArray[i] callback:^BOOL(MGSwipeTableCell *sender) {
            
            Hi_UserModel *userModel=self.dataSource[sender.tag];
            Hi_UserDetailController * userDetail = [[Hi_UserDetailController alloc]init];
            userDetail.userModel=userModel;
            [self.navigationController pushViewController:userDetail animated:YES];
            return YES;
        }];
    
        [result addObject:button];
    }
    return result;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Hi_MessageDetailController * detailCtrl = [[Hi_MessageDetailController alloc]init];
    Hi_UserModel*userModel=self.dataSource[indexPath.row];
    detailCtrl.userModel=userModel;
    detailCtrl.title=userModel.nickName;
    [self.navigationController pushViewController:detailCtrl animated:YES];
    
}
-(NSArray *) createRightButtons: (int) number
{
    NSMutableArray * result = [NSMutableArray array];
    NSString* titles[2] = {@"搭讪", @"查看资料"};
    UIColor * colors[2] = {kColor(105, 174, 64),[UIColor redColor]};
    for (int i = 0; i < number; ++i)
    {
        
        MGSwipeButton * button=nil;
        if (i==0) {
            button = [MGSwipeButton buttonWithTitle:titles[i] backgroundColor:colors[i] callback:^BOOL(MGSwipeTableCell * sender){
                
             //   [self talkFriend:sender];
                return YES;
            }];
            
        }else{
            
            
            button = [MGSwipeButton buttonWithTitle:titles[i] backgroundColor:colors[i] callback:^BOOL(MGSwipeTableCell * sender){
               // [self addFriend:sender];
                return YES;
            }];
            
        }
        
        [result addObject:button];
    }
    return result;
}

#pragma mark -警告
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    
    
    NSDictionary *attributes= @{NSFontAttributeName:[UIFont boldSystemFontOfSize:17.0],NSForegroundColorAttributeName:[UIColor lightGrayColor]};
    NSString * tip = [UIDevice getWifiMacAddress]?@"当前WIFI现场没有用户哦":@"当前不是WIFI环境,请连上附近WIFI";
    NSAttributedString * string =[[NSAttributedString alloc]initWithString:tip attributes:attributes];
    return string;
}
-(NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView{
    NSDictionary *attributes= @{NSFontAttributeName:[UIFont boldSystemFontOfSize:13.0],NSForegroundColorAttributeName:[UIColor redColor]};
    NSAttributedString * string =[[NSAttributedString alloc]initWithString:@"要不要到处走走?" attributes:attributes];
    return string;
}
-(UIImage*)imageForEmptyDataSet:(UIScrollView *)scrollView{return [UIImage imageNamed:@"em_3"];}
@end
