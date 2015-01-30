//
//  Hi_MineSettingController.m
//  hihi
//
//  Created by 伍松和 on 14/12/28.
//  Copyright (c) 2014年 伍松和. All rights reserved.
//

#import "Hi_MineSettingController.h"
#import "Hi_RootControllerTool.h"
@interface Hi_MineSettingController ()

@end

@implementation Hi_MineSettingController
-(instancetype)initWithType:(MiniSettingControllerType)type{

    if (self = [super initWithType:MiniSettingControllerTypeSetting]) {
        //
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //
    self.navigationItem.rightBarButtonItem =[UIBarButtonItem itemWithTitle:@"退出" themeColor:[UIColor whiteColor] target:self action:@selector(rightAction:)];
    
    
}

-(void)rightAction:(UIButton*)button{
    
    UIAlertView*alert= [[UIAlertView alloc]initWithTitle:@"是否退出" message:@"退出会把你所有聊天跟浏览记录删除" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    [alert showWithCompletionHandler:^(NSInteger buttonIndex) {
        if (buttonIndex==1) {            
            [[Hi_RootControllerTool sharedHi_RootControllerTool]chooseRootController:Hi_RootControllerHelperStyleLoginResgiter];
        }
    }];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
