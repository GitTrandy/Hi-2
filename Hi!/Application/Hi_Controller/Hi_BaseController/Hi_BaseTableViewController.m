//
//  Hi_BaseViewController.m
//  Hi!
//
//  Created by 伍松和 on 14/11/27.
//  Copyright (c) 2014年 伍松和. All rights reserved.
//

#import "Hi_BaseTableViewController.h"
#import "PhotoPickerTool.h"

@interface Hi_BaseTableViewController ()

@end

@implementation Hi_BaseTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.navigationController) {
        //kColor(254, 72, 0)
        self.navigationController.navigationBar.barTintColor=Color(254, 72, 0, 0.92);//
        self.navigationController.navigationBar.translucent=YES;
        
    }
    
    WEAKSELF;
    [self.tableView addHeaderWithCallback:^{
        [weakSelf loadMoreData];
    }];
    
    if (!self.tableView.emptyDataSetDelegate) {
        self.tableView.emptyDataSetDelegate=self;
        self.tableView.emptyDataSetSource=self;
    }

}
-(void)viewDidAppear:(BOOL)animated{

    
    [super viewDidAppear:animated];
    
 
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{return 75;}
- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView
{
    return YES;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView
{
    return YES;
}

//
//
@end
