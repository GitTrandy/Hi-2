#import "Hi_SettingTableController.h"
#import "Hi_ProfileView.h"
#import "Hi_AccountTool.h"
@interface Hi_ProfileController : Hi_SettingTableController
@property (nonatomic,strong)Hi_Account * account;
@property (nonatomic,strong)Hi_ProfileView * profileView;

- (void)setupGroup1;
-(void)setupHeader;
- (void)setupFooter;
@end
