

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, ButtonPositionType){
    
    ButtonPositionTypeBothCenter,
    ButtonPositionTypeTitleLeft,
    ButtonPositionTypeNoneTitle,
    ButtonPositionTypeNoneImageView,
};
@interface BaseOperationButton : UIButton
@property (nonatomic,assign)ButtonPositionType buttonPositionType;

-(instancetype)initWithFrame:(CGRect)frame
          ButtonPositionType:(ButtonPositionType)type;
@end
