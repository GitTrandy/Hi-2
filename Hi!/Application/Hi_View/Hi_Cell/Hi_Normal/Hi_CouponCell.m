
#import "Hi_CouponCell.h"
#import "Hi_GlobalMarco.h"

@implementation Hi_CouponCell

- (void)awakeFromNib {
    // Initialization code
}
-(void)setCouponsModel:(Hi_CouponsModel *)couponsModel{

    //1.头像
    
    [self.logoView sd_setImageWithURL:[NSURL URLWithString:couponsModel.image] placeholderImage:[UIImage imageNamed:@"user_img"]];
  //2.标题
    _titleLab.text=couponsModel.title;
    
    //3.
    _detailLab.text=couponsModel.content;
     //4.
    _bottomLab.text=couponsModel.address;
    
    
    _rightLab.text=couponsModel.startTimeFormat;
}
//固定cell的frame，因为会不停动态改变
#define kCellBorderWidth 10
-(void)setFrame:(CGRect)frame{
    
    frame.origin.x = kCellBorderWidth;
    frame.origin.y += kCellBorderWidth;
    
    frame.size.width-=kCellBorderWidth *2;
    frame.size.height-=kCellBorderWidth;
    
    [super setFrame:frame];
}
@end
