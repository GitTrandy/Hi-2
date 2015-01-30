//
//  CommonViewController.m
//  Meimei
//
//  Created by namebryant on 14-8-17.
//  Copyright (c) 2014年 Meimei. All rights reserved.
//

#import "BaseViewController.h"
@interface BaseViewController ()

@end

@implementation BaseViewController
///当离开的时候把首次加载设 NO
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    _isFirstLoading=NO;
}
//设定默认值
-(instancetype)init{
    
    if (self=[super init]) {
        self.isFirstLoading=YES;
        self.isSetUpViewDidLoad=NO;
    }
    return self;

}



- (void)viewDidLoad
{
    [super viewDidLoad];
     self.view.backgroundColor=[UIColor whiteColor];
    
    //4.右边
    
     
    
}
-(void)leftBtnAction:(UIButton *)leftBtn{}
-(void)rightBtnAction:(id)sender{}
-(void)dismissViewController{[self dismissViewControllerAnimated:YES completion:nil];}
@end
