//
//  BaseSettingTableController.h
//  易商
//
//  Created by namebryant on 14-10-6.
//  Copyright (c) 2014年 Ruifeng. All rights reserved.
//

#import "BaseSettingGroup.h"
#import "BaseSettingCheckGroup.h"
#import "BaseSettingCell.h"
#import "BaseSettingItem.h"


@class BaseSettingGroup;
@interface BaseSettingTableController : UIViewController<UITableViewDelegate,UITableViewDataSource>
/**
 *  表格组
 */
@property (strong, nonatomic) NSMutableArray *groups;
@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic,strong)UITableView * tableView;

/**
 *  添加表格组
 */
//- (BaseSettingGroup *)addGroup;
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
@end
