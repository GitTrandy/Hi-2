

#import "Hi_MainViewController.h"
#import "Hi_MessageListViewController.h"
#import "Hi_UserListViewController.h"
#import "Hi_LiveViewController.h"
#import "Hi_ShopViewController.h"
#import "Hi_MineViewController.h"

@interface Hi_MainViewController ()

@end

@implementation Hi_MainViewController
id _notificationObserver;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addAllChildControllers];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];


}

#pragma mark 初始化所有的子控制器
- (void)addAllChildControllers
{
    
    
    
    //消息
    Hi_MessageListViewController*_V1 =[[Hi_MessageListViewController alloc]init];
    _V1.title=@"消息";
    BaseNavigationController * nav1=[[BaseNavigationController alloc]initWithRootViewController:_V1];


    //联系人
    Hi_UserListViewController *_V2 =[[Hi_UserListViewController alloc]init];
    _V2.title=@"联系人";
    BaseNavigationController * nav2=[[BaseNavigationController alloc]initWithRootViewController:_V2];

    
    
    
    //现场
    Hi_LiveViewController *_V3=[[Hi_LiveViewController alloc]init];
    BaseNavigationController * nav3=[[BaseNavigationController alloc]initWithRootViewController:_V3];
    _V3.title=@"现场";

    //商家
    Hi_ShopViewController*_V4 =[[Hi_ShopViewController alloc]init];
    _V4.title=@"商家";
    BaseNavigationController * nav4=[[BaseNavigationController alloc]initWithRootViewController:_V4];
    
    //我
    Hi_MineViewController* _V5=[[Hi_MineViewController alloc]init];
    _V5.title=@"我";
    BaseNavigationController * nav5=[[BaseNavigationController alloc]initWithRootViewController:_V5];
    
    self.viewControllers=@[nav1,nav2,nav3,nav4,nav5];
    [self.viewControllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        BaseNavigationController * nav=obj;
        NSString * imageName = [NSString stringWithFormat:@"icon_%d_n",(int)idx+1];
        NSString * selectImageName = [NSString stringWithFormat:@"icon_%d_d",(int)idx+1];

        nav.tabBarItem.image=[[UIImage imageNamed:imageName]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        nav.tabBarItem.selectedImage=[[UIImage imageNamed:selectImageName]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        nav.tabBarItem.imageInsets=UIEdgeInsetsMake(6, 0, -6, 0);
        nav.tabBarItem.title=nil;
        
    }];
    self.tabBar.tintColor=[UIColor clearColor];
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor clearColor] }
                                             forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor clearColor] }
                                             forState:UIControlStateSelected];
    self.selectedIndex=2;
   // [self loadMsgDataFinishLaunch];
 
//    [self setNotificationDidLaunch];
  //  [self openSessionDidLaunch];
    
    UITabBarItem* tabBarItem =self.tabBar.items[0];
    
    //0.直接取数据库
    NSInteger un_read_num = [Hi_SMSModel hi_dealWithUnreadMessageNum:nil];
    if (un_read_num) {
        tabBarItem.badgeValue=[NSString stringWithFormat:@"%d",(int)un_read_num];
    }else{
        tabBarItem.badgeValue=nil;
    }

    //1.通知
    _notificationObserver=[[NSNotificationCenter defaultCenter]addObserverForName:HI_UN_READ_NUM_NOTIFICATION object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        
        NSLog(@"nnnn:%@",[note object]);
        
        if ([[note object] isEqual:@(0)]||![note object]) {
            tabBarItem.badgeValue=nil;
            return;
        }else{
            tabBarItem.badgeValue=[NSString stringWithFormat:@"%@",[note object]];
            [UIApplication sharedApplication].applicationIconBadgeNumber = [[note object] integerValue];
            
            
        }
        
        
    }];

    
}
//-(void)setSelectedViewController:(UIViewController *)selectedViewController{
//    
//}


#pragma mark - 加载网络数据
-(void)loadMsgDataFinishLaunch{
    
    
    
    NSString * time=[Hi_SMSModel hi_sms_detail_max_time:nil];
    if (time) {
        return;
    }
    
    [SVProgressHUD showWithStatus:@"同步消息数据" maskType:SVProgressHUDMaskTypeBlack];

    [Hi_SmsTool getSMSTimeWith:time WithID:0 success:^(id result) {
        
        if (result) {
            [SVProgressHUD showSuccessWithStatus:@"同步成功"];
            
            UITabBarItem* tabBarItem =self.tabBar.items[0];
            //0.直接取数据库
            NSInteger un_read_num = [Hi_SMSModel hi_dealWithUnreadMessageNum:nil];
            if (un_read_num) {
                tabBarItem.badgeValue=[NSString stringWithFormat:@"%d",(int)un_read_num];
            }else{
                tabBarItem.badgeValue=nil;
            }
        }else{
            [SVProgressHUD showErrorWithStatus:@"网络不好"];

        }
      

        
    } failure:^(NSError *error) {
        
        [SVProgressHUD showErrorWithStatus:@"网络不好"];
    }];
    
   
}

#pragma mark -开启会话
#define INSTALLATION @"installation"

-(void)openSessionDidLaunch{

    //0.
//    [Hi_AccountTool LoginByAvosWithUserID:MY_UID success:nil failure:nil];
    
    //1
    Hi_SessionTool* sessionManager=[Hi_SessionTool sharedInstance];
    [sessionManager openSession];
    AVInstallation* installation=[AVInstallation currentInstallation];
    AVUser* user=[AVUser currentUser];
    [user setObject:installation forKey:INSTALLATION];
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(error){
           
        }else{
            [sessionManager openSession];

        }
    }];
}

-(void)dealloc{

    [[NSNotificationCenter defaultCenter]removeObserver:_notificationObserver];
    _notificationObserver=nil;
}

@end
