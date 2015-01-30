

#import "Hi_SettingTableController.h"
#import "Hi_AccountTool.h"
typedef NS_ENUM(NSInteger, MiniSettingControllerType) {

    MiniSettingControllerTypeNone,
    MiniSettingControllerTypeAfterRegister,
    MiniSettingControllerTypeSetting
};
@interface Hi_BaseMiniSettingController : BaseSettingTableController

@property (assign ,nonatomic)MiniSettingControllerType type;
-(instancetype)initWithType:(MiniSettingControllerType)type;

@property(nonatomic,strong)Hi_Account * account;
@property(nonatomic,strong)NSIndexPath * curIndexPath;

-(void)rightAction:(UIButton*)button;
@end
