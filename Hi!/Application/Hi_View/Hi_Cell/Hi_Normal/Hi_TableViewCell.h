
#import <UIKit/UIKit.h>
#import "Hi_GlobalMarco.h"
#import "MGSwipeTableCell.h"
#import "MGSwipeButton.h"
@interface Hi_TableViewCell : MGSwipeTableCell
+(instancetype)instancetypeWithNib;
@property (weak, nonatomic) IBOutlet UIImageView *logoView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *detailLab;
@property (weak, nonatomic) IBOutlet UILabel *rightLab;

@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (weak, nonatomic) IBOutlet UILabel *bottomLine;
#pragma mark -用户 Cell
@property (nonatomic,strong)Hi_UserModel * userModel;
@property (nonatomic,strong)Hi_SMSModel * smsModel;
@property (weak, nonatomic) IBOutlet UIView *badgeView;

+(id)configureCellWithClass:(Class)cellClass
                 WithCellID:(NSString*)CellIdentifier
              WithTableView:(UITableView*)tableView;
@end
