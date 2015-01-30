//
//  UITableViewCell+JJ.h
//  hihi
//
//  Created by 伍松和 on 14/12/11.
//  Copyright (c) 2014年 伍松和. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImage+JJ.h"
@interface UITableViewCell (JJ)
#pragma mark -构建Cell（根据数据）
+(void)configureCellWithClass:(Class)CellClass
                   WithCellID:(NSString*)CellIdentifier
                WithTableView:(UITableView*)tableView;
@end
