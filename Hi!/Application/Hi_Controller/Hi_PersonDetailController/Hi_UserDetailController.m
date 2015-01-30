//
//  Hi_PersonInfoController.m
//  Hi!
//
//  Created by 伍松和 on 14/12/8.
//  Copyright (c) 2014年 伍松和. All rights reserved.
//

#import "Hi_UserDetailController.h"
#import "Hi_MessageDetailController.h"
#import "Hi_UserTool.h"
#import "MJPhotoBrowser.h"

@interface Hi_UserDetailController ()
@property (nonatomic,strong)UIButton * rightButton;

@end

@implementation Hi_UserDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem =[UIBarButtonItem itemWithTitle:@"照片墙" themeColor:[UIColor whiteColor] target:self action:@selector(moreAction:)];
    self.rightButton=self.navigationItem.rightBarButtonItem.barButton;
    [self.rightButton showActivityOverView:self.rightButton.bounds WithStyle:UIActivityIndicatorViewStyleWhite];
    
    if (self.userModel) {
        self.title=self.userModel.nickName;
        if (self.userModel.uid) {
            self.user_id=self.userModel.uid;

        }
    }

}
-(void)setUser_id:(NSString *)user_id{

    _user_id=user_id;
    [Hi_UserTool getMemberWithUID:user_id success:^(id result) {
        if (result) {
            self.userModel=result;
            [self setupHeader];
            [self setupGroup1];
            [self setupFooter];
            
            

            self.rightButton.enabled=YES;

        }else{
            
           self.rightButton.enabled=NO;
        }
            [self.rightButton hideActivityOverView:[NSString stringWithFormat:@"照片墙"]];
        
        
        self.title=self.userModel.nickName?self.userModel.nickName:@"用户不存在";
    } failure:^(NSError *error) {
        [self.rightButton hideActivityOverView:@"更多"];
         [self.tableView reloadData];
    }];
}
-(void)viewWillAppear:(BOOL)animated{
    
   
    
    
    self.navigationController.navigationBarHidden=NO;
    if (self.userModel) {
      
        [self setupHeader];
        [self setupGroup1];
        [self setupFooter];
    }
    
}
//http://img0.bdstatic.com/img/image/shouye/xinshouye/bizhi1226.jpg
//http://img0.bdstatic.com/img/image/shouye/xinshouye/lvyou1226.jpg
//http://img0.bdstatic.com/img/image/shouye/xinshouye/qiche1226a.jpg
-(NSArray*)user_imgs_array{

    NSMutableArray * array_urls=[NSMutableArray array];
    //1.
    [array_urls addObject:self.userModel.head];
    
    //2.3.4
    if (self.userModel.photos) {
        [self.userModel.photos enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSDictionary * dic = obj;
            [array_urls addObject:dic[@"url"]];
        }];
    }
  
    
    return array_urls;
    

}
-(void)moreAction:(id)bar{
   // UIWINDOW_FAILURE(@"上拉/点击头像可以查看照片墙");
   
    
    NSArray * array =[self user_imgs_array];
    int count = (int)array.count;
    // 1.封装图片数据
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i<count; i++) {
        // 替换为中等尺寸图片
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.srcImageView= self.profileView.imageView;
        photo.url = [NSURL URLWithString:array[i]]; // 图片路径
        [photos addObject:photo];
    }
    
    // 2.显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = 0; // 弹出相册时显示的第一张图片是？
    browser.photos = photos; // 设置所有的图片
    [browser show];
}

-(void)setupHeader{
    
    [super setupHeader];
    self.profileView.userModel=self.userModel;
    
}
-(void)setupGroup1{

    BaseSettingGroup *group = [BaseSettingGroup group];
    
    BaseSettingItem *item1 =  [BaseSettingItem itemWithIcon:@"contact_tag" title:nil  subTitle:self.userModel.note?self.userModel.note:@"无标签" settingItemSytle:BaseSettingItemSytleArrow option:nil];
    
     BaseSettingItem *item2 =  [BaseSettingItem itemWithIcon:@"live_list" title:nil  subTitle:self.userModel.currentState?self.userModel.currentState:@"无状态"  settingItemSytle:BaseSettingItemSytleArrow option:nil];
    group.items=@[item1,item2];
    self.tableView.rowHeight=55;
    self.groups[0]=group;
    [self.tableView reloadData];
}


#define TableBorder 5
- (void)setupFooter{
    
    // footer
    UIView *footer = [[UIView alloc] init];
    CGFloat footerH = 120 + TableBorder;
    footer.frame = CGRectMake(0, 0, self.view.width, footerH);
    // 按钮
    UIButton *logoutButton = [[UIButton alloc] init];
    logoutButton.frame = CGRectMake(0, 10, 80, 100);
    logoutButton.center=footer.center;
    logoutButton.y=10;
    
    [logoutButton setBackgroundImage:[UIImage imageNamed:@"contact_sms"] forState:UIControlStateNormal];
    logoutButton.enabled=!_isNotLiveUserModel;
    [logoutButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        Hi_MessageDetailController * detailCtrl = [[Hi_MessageDetailController alloc]init];
        detailCtrl.userModel=self.userModel;
        detailCtrl.title=self.userModel.nickName;
        
        
        [self.navigationController pushViewController:detailCtrl animated:YES];
    }];
     [footer addSubview:logoutButton];
    
    self.tableView.tableFooterView = footer;

    
}
@end
