
typedef NS_ENUM(NSInteger, BaseEditViewControllerStyle) {

    BaseEditViewControllerStyleNormal,
    BaseEditViewControllerStyleDate,
    BaseEditViewControllerStyleState,
};

#import "BaseViewController.h"
#import "BaseSettingCell.h"
#import "Hi_AccountTool.h"

@interface BaseEditViewController : BaseViewController

/**
 *  编写信息类型
 */
@property(nonatomic,assign) BaseEditViewControllerStyle editViewControllerStyle;
/**
 *  都要一个cell
 */
@property (strong, nonatomic)BaseSettingCell * cell;
/**
 *  cell的indexPath
 */
@property (strong, nonatomic) NSIndexPath *indexPath;
/**
 *  个人信息
 */
@property (strong, nonatomic)Hi_Account * account;

@property (assign ,nonatomic)AccountType accountType;




@end
