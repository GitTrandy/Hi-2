

#import <UIKit/UIKit.h>
#import "Hi_GlobalMarco.h"
#import "MGSwipeTableCell.h"

@interface Hi_TableViewSecondCell : UITableViewCell
+(instancetype)instancetypeWithSecondNib;
@property (weak, nonatomic) IBOutlet UIImageView *logoView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *detailLab;
@property (weak, nonatomic) IBOutlet UILabel *rightLab;

@property (weak, nonatomic) IBOutlet UILabel *bottomLine;


//B.
@property (weak, nonatomic) IBOutlet UILabel *bottomTitleLab;

#pragma mark -商店 Cell
@property (nonatomic,strong)Hi_BusinessModel * businessModel;
@end
