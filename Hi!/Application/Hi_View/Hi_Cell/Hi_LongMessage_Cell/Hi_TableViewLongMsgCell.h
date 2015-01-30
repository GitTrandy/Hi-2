

#import <UIKit/UIKit.h>
#import "UITableViewCell+JJ.h"
#import "Hi_LongMsgModel.h"
#define HI_LONG_MSG_CELL_NAME @"Hi_TableViewLongMsgCell"

typedef void(^BaseTableViewCellAvatarAction)(id cell,id otherData);
typedef void(^BaseTableViewCellImageWallAction)(id cell,id otherData);
typedef void(^BaseTableViewCellLikeAction)(id cell,id otherData);

@interface Hi_TableViewLongMsgCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *logoButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *detailLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UIButton *like_button;

@property (weak, nonatomic) IBOutlet UIView *otherView;


@property (strong, nonatomic) UIImageView * single_imageView;
@property(assign,nonatomic)CGFloat cellHeight;
@property(strong,nonatomic)Hi_LongMsgModel * longModel;

///内部点击事件
@property (nonatomic,copy)BaseTableViewCellAvatarAction AvatarAction;
@property (nonatomic,copy)BaseTableViewCellImageWallAction ImageWallAction;
@property (nonatomic,copy)BaseTableViewCellImageWallAction LikeAction;

//1,点击头像
-(void)tapAvatar:(BaseTableViewCellAvatarAction)action;
//2.点击图片(图片墙)
-(void)tapImageWall:(BaseTableViewCellImageWallAction)action;
//3.点赞
-(void)tapLike:(BaseTableViewCellLikeAction)action;

+(instancetype)instancetypeWithXIB;


@end
