//
//  UITableViewCell+JJ.m
//  hihi
//
//  Created by 伍松和 on 14/12/11.
//  Copyright (c) 2014年 伍松和. All rights reserved.
//

#import "UITableViewCell+JJ.h"

@implementation UITableViewCell (JJ)
#pragma mark -构建Cell（根据数据）
+(void)configureCellWithClass:(Class)CellClass
                 WithCellID:(NSString*)CellIdentifier
              WithTableView:(UITableView*)tableView{
    
    
    //NIB万岁
    BOOL nibsRegistered = NO;
    if (!nibsRegistered) {
        UINib *nib = [UINib nibWithNibName:NSStringFromClass([CellClass class]) bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:CellIdentifier];
        nibsRegistered = YES;
    }
    
    
}

@end
