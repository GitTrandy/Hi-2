



#import <UIKit/UIKit.h>
#import "BaseSettingItem.h"
#import "UIImage+JJ.h"
/**
 *  设置Cell
 */
@interface BaseSettingCell : UITableViewCell<UITextFieldDelegate>

/**
 *  对象模型
 */
@property (strong, nonatomic) BaseSettingItem *item;
@property (strong, nonatomic) NSIndexPath *indexPath;

/**
 *  加载cell
 */
@property (weak, nonatomic) UIImageView *bg;
@property (weak, nonatomic) UIImageView *selectedBg;
/**
 *  表视图
 */
@property (weak, nonatomic) UITableView *tableView;

/**
 *  头像
 */
@property (strong, nonatomic) UIImageView *avatarImageView;

/**
 *  子标题
 */
@property (strong, nonatomic) UILabel *subtitleLabel;
/**
 *  箭头
 */
@property (strong, nonatomic) UIImageView *arrowView;
/**
 *  打钩
 */
@property (strong, nonatomic) UIImageView *checkView;
/**
 *  开关
 */
@property (strong, nonatomic) UISwitch *switchView;
/**
 *  提醒数字
 */
/**
 * 输入框,用于注册跟登录
 */
@property (strong, nonatomic) UITextField * inputTextField;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
