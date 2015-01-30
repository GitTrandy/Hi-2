
#import <AVOSCloudSNS/AVOSCloudSNS.h>
#import <AVOSCloud/AVOSCloud.h>
#import "SVProgressHUD.h"


#import "JDStatusBarNotification.h"
#import "BaseNavigationController.h"



#import "LibMarco.h"
#import "CategoryMarco.h"
#import "MJPhotoBrowser.h"


/**
 *  封装了若干属性,方法的UIViewController
 */
@interface BaseViewController : UIViewController


//主视图



//左右选项,可以hidden
@property(nonatomic,strong)UIButton * rightBtn;
@property(nonatomic,strong)UIButton * leftButton;

-(void)rightBtnAction:(id)sender;
-(void)leftBtnAction:(UIButton*)leftBtn;
-(void)dismissViewController;
//试图启动

///是否第一次启动
@property (nonatomic ,assign)BOOL isFirstLoading;
///小小技巧:判断是否执行了 viewDidLoad

@property (nonatomic ,assign)BOOL isSetUpViewDidLoad;




@end
