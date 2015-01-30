//
//  BaseTableSectionController.m
//  易商
//
//  Created by 伍松和 on 14/10/25.
//  Copyright (c) 2014年 Ruifeng. All rights reserved.
//

#import "BaseTableSectionController.h"

@implementation BaseTableSectionController
//-(void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    if (self.isFirstLoading) {
//        [self.tableView showActivityOverView:self.view.bounds];
//    }
//}
#pragma mark -数据
#pragma mark -数据
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    
    if (![tableView isEqual:self.tableView]) {
        return 1;
    }else{
        
        if (self.sectionDictionary.count<=0) {
            return 0;
        }
        return self.sectionDictionary.count;
        
        
    }
    
    
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (![tableView isEqual:self.tableView]) {
        return self.searchResult.count;
    }else{
        
        NSArray * arrayM=self.sectionDictionary.allValues;
        if ([arrayM[section] count]>0&&arrayM[section]) {
            return [arrayM[section] count];
        }
        return 0;
        
    }
    
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    if (![tableView isEqual:self.tableView]) {
        return @"搜索结果";
    }else{
        
        NSArray * arrayM=self.sectionDictionary.allKeys;
        if ([arrayM[section] length]>1) {
            return [(NSString*)arrayM[section] substringFromIndex:1];
        }
        return @"";
        
    }
    
    
}




#pragma mark -搜索
#pragma mark -搜索
#pragma mark - searchbar delegate


@end
