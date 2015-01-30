#import "Hi_BaseTableSectionController.h"
@class Hi_BusinessModel;
@interface Hi_ShopDetailViewController : Hi_BaseTableSectionController
///商家
@property (nonatomic,strong)Hi_BusinessModel * businessModel;
///商家->ID
@property (nonatomic,copy)NSString * bid;


///视图

@property (nonatomic,strong)UIView *businessHeader;
@end
