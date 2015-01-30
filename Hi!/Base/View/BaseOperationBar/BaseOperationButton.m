
#import "BaseOperationButton.h"
#import "UIView+JJ.h"
@interface BaseOperationButton()

@end

@implementation BaseOperationButton

-(instancetype)initWithFrame:(CGRect)frame
          ButtonPositionType:(ButtonPositionType)type{
    
    if (self=[super initWithFrame:frame]) {
        
        self.buttonPositionType=type;
        
        // 添加一个提醒数字按钮
      
        
        //
        
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    switch (_buttonPositionType) {
        case ButtonPositionTypeBothCenter:
        {
            [self buttonPositionTypeBothCenter];
            break;
        }
            
        case ButtonPositionTypeTitleLeft:
        {
            [self buttonPositionTypeTitleLeft];
            break;
        }
        case ButtonPositionTypeNoneTitle:{
        
            [self buttonPositionTypeNoneTitle];
            break;

        }
            
            
        default:
            [self buttonPositionTypeBothCenter];
            break;
    }
    
}
-(void)buttonPositionTypeNoneTitle{

    self.imageView.center=CGPointMake(self.frame.size.width/2, self.center.y);

}
-(void)buttonPositionTypeBothCenter{
    //0.image
    self.imageView.center=CGPointMake(self.frame.size.width/2, self.frame.size.height/2-2);
    
    
    //1.title
    CGRect frame = [self titleLabel].frame;
    frame.origin.x = 0;
    frame.origin.y = self.imageView.bottom + 2;
    frame.size.width = self.frame.size.width;
    self.titleLabel.frame = frame;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.titleLabel setFont:[UIFont boldSystemFontOfSize:10.0f]];
}
-(void)buttonPositionTypeTitleLeft{
    
    self.titleEdgeInsets=UIEdgeInsetsMake(0, 0, 0, -8);
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
   
    
}
-(void) centerButtonAndImageWithSpacing:(CGFloat)spacing {
    self.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, spacing);
    self.titleEdgeInsets = UIEdgeInsetsMake(0, spacing, 0, 0);
}
// 设置提醒数字的位置
//CGFloat badgeY = 5;
//CGFloat badgeX = self.frame.size.width - self.badgeButton.frame.size.width - 10;
//CGRect badgeF = self.badgeButton.frame;
//badgeF.origin.x = badgeX;
//badgeF.origin.y = badgeY;
//self.badgeButton.frame = badgeF;



@end

