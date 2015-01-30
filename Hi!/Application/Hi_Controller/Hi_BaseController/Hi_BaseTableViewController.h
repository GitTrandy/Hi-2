#import "BaseTableViewController.h"
#import "Hi_MessageDetailController.h"
#import "Hi_UserDetailController.h"


#import "Hi_TableViewCell.h"
#import "Hi_TableViewSecondCell.h"
#import "Hi_LoginRegisterTool.h"
@interface Hi_BaseTableViewController : BaseTableViewController<DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>
@property(nonatomic,assign)NSInteger currentCellIndex;

@end
