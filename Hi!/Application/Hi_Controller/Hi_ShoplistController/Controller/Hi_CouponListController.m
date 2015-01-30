//
//  Hi_CouponViewController.m
//  hihi
//
//  Created by 伍松和 on 14/12/10.
//  Copyright (c) 2014年 伍松和. All rights reserved.
//

#import "Hi_CouponListController.h"
#import "Hi_CouponDetailController.h"
#import "Hi_CouponCell.h"
@interface Hi_CouponListController ()

@end

@implementation Hi_CouponListController

- (void)viewDidLoad {
    [super viewDidLoad];

     self.tableView.backgroundView.backgroundColor=kColor(239, 239, 239);
    self.tableView.tableHeaderView.backgroundColor=kColor(239, 239, 239);
     self.tableView.backgroundColor=kColor(239, 239, 239);
    self.title=@"优惠卷";
    WEAKSELF;
    [self.tableView addHeaderWithCallback:^{
        [weakSelf loadMoreData];
    }];
   
}
-(void)viewWillAppear:(BOOL)animated{
    if (self.isFirstLoading) {
        [self.tableView showActivityOverView:self.view.bounds WithStyle:UIActivityIndicatorViewStyleGray];
    }
     [self loadFirstData];
}

-(void)loadFirstData{
    
    if (!MY_USER_FIRST_LOAD_COUPONS_LIST||[[Hi_CouponsModel queryFormDB:nil orderBy:nil count:5 success:nil] count]<=0) {
        [self loadMoreData];
    }else{
        [self loadLocalData];
    }
}
-(void)loadLocalData{
    
    [Hi_ThreadTool ES_AsyncConcurrentOperationQueueBlock:^{
        
        NSString * where = [NSString string];
        if (self.BID) {
            where=[NSString stringWithFormat:@"isUse='0' AND bid = '%@'",self.BID];
        }else{
            where=[NSString stringWithFormat:@"isUse='0'"];

        }
        self.dataSource=[Hi_CouponsModel queryFormDB:where orderBy:@"use_time desc" count:20 success:nil];

    } MainThreadBlock:^{
        
        [self reloadTableData];
    }];
    
}
-(void)loadMoreData{

    [Hi_CouponsTool getAllCouponsbegin:0 limit:20 success:^(id result) {
     
        SAVE_USER_FIRST_LOAD_COUPONS_LIST(USER_FIRST_LOAD_COUPONS_LIST);
        [self loadLocalData];
        
    } failure:^(NSError *error) {
        [self loadLocalData];
    }];
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    static NSString * cellID= @"con_cell";
    [UITableViewCell configureCellWithClass:[Hi_CouponCell class] WithCellID:cellID WithTableView:tableView];
    Hi_CouponCell * cell = (Hi_CouponCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
    cell.couponsModel=self.dataSource[indexPath.row];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{return 80;};

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Hi_CouponsModel * couponsModel = self.dataSource[indexPath.row];
    Hi_CouponDetailController * couponCtrl = [[Hi_CouponDetailController alloc]init];
    couponCtrl.couponModel=couponsModel;
    couponCtrl.title=couponsModel.title;
    [self.navigationController pushViewController:couponCtrl animated:YES];
}
@end
