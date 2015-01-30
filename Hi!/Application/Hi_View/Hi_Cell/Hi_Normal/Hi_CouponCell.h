
#import <UIKit/UIKit.h>
#import "UITableViewCell+JJ.h"


#import "Hi_CouponsModel.h"

@interface Hi_CouponCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *logoView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *detailLab;
@property (weak, nonatomic) IBOutlet UILabel *rightLab;
@property (weak, nonatomic) IBOutlet UILabel *bottomLab;

@property (weak, nonatomic) IBOutlet UILabel *bottomLine;
@property (nonatomic,strong)Hi_CouponsModel * couponsModel;
@end
