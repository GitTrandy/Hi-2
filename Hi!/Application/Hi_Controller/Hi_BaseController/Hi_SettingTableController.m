//
//  Hi_SettingTableController.m
//  Hi!
//
//  Created by 伍松和 on 14/11/27.
//  Copyright (c) 2014年 伍松和. All rights reserved.
//

#import "Hi_SettingTableController.h"
#import "Hi_AccountTool.h"
#import "UIView+JJ.h"
@implementation Hi_SettingTableController
///当离开的时候把首次加载设 NO
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    _isFirstLoading=NO;
}
//设定默认值
-(instancetype)init{
    
    if (self=[super init]) {
        self.isFirstLoading=YES;
    }
    return self;
    
}
@end
