
#import <UIKit/UIKit.h>
#import "UITableViewCell+JJ.h"
#import "Hi_SMSModel.h"
#import "MLEmojiLabel.h"

typedef void(^tapImageViewBlock) (id result);
typedef void(^tapMsgLabelBlock) (id result);


@interface Hi_TableViewChatCell : UITableViewCell
@property (nonatomic, strong)Hi_SMSModel * smsModel;
@property (nonatomic, strong)Hi_UserModel * userModel;

@property (weak, nonatomic) IBOutlet UIImageView *logoView;
@property (weak, nonatomic) IBOutlet UIImageView *chatline;
@property (weak, nonatomic) IBOutlet UIImageView *whoView;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *msgActivty;
@property (weak, nonatomic) IBOutlet UIView *content_view;
@property (weak, nonatomic) IBOutlet MLEmojiLabel *msgLab;
@property (strong, nonatomic)  UIImageView *msg_imageView;


@property (nonatomic, assign)CGFloat cellHeight;

+(instancetype)instancetypeWithXib;
#pragma mark -构建Cell（根据数据）
+(id)configureCellWithClass:(Class)cellClass
                 WithCellID:(NSString*)CellIdentifier
              WithTableView:(UITableView*)tableView;

#pragma mark -内部点击
@property (nonatomic,copy)tapImageViewBlock tapImageViewBlock;
@property (nonatomic,copy)tapMsgLabelBlock tapMsgLabelBlock;
-(void)addActionImageViewBlock:(tapImageViewBlock)tapImageViewBlock;
-(void)addActionMsgLabelBlock:(tapMsgLabelBlock)tapMsgLabelBlock;

@end
