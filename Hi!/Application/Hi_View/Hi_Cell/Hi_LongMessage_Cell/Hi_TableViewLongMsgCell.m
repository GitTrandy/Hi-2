
#import "Hi_TableViewLongMsgCell.h"
#import "UIButton+AFNetworking.h"
#import "Hi_BusinessTool.h"
#import "UIWindow+JJ.h"
@implementation Hi_TableViewLongMsgCell


+(instancetype)instancetypeWithXIB{

    return [[NSBundle mainBundle]loadNibNamed:HI_LONG_MSG_CELL_NAME owner:nil options:nil][0];
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
//1.
//2.点击事件
    self.single_imageView.userInteractionEnabled = YES;
    [self.single_imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapWallImage:)]];
    
//3
    [self.logoButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        if (self.AvatarAction) {
            self.AvatarAction(self,sender);
        }
    }];
    
//4,
    [self.like_button handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        [self likeAction:sender];
    }];
}
#pragma mark -点击头像
-(void)tapAvatar:(BaseTableViewCellAvatarAction)action{ self.AvatarAction=action;}
#pragma mark -点击图片墙
-(void)tapWallImage:(UITapGestureRecognizer*)tap{
    if (self.ImageWallAction) {
        self.ImageWallAction(self,tap.view);
    }
}
-(void)tapImageWall:(BaseTableViewCellImageWallAction)action{ self.ImageWallAction=action;}
#pragma mark -高度
-(CGFloat)cellHeight{

    [self.detailLab sizeToFit];
    if ([_longModel.img isKindOfClass:[NSNull class]]||!_longModel.img) {
        return 80+self.detailLab.height;
    }else{
        return 80+self.detailLab.height+self.otherView.height;
    }
}
-(UIImageView *)single_imageView{

    if (!_single_imageView) {
        _single_imageView=[[UIImageView alloc]init];
        _single_imageView.frame=self.otherView.bounds;

    }
    
    return _single_imageView;
    
}
-(void)setLongModel:(Hi_LongMsgModel *)longModel{

    _longModel=longModel;
    self.titleLab.text=longModel.nickName;
    self.detailLab.text=longModel.content;
    [self.logoButton setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:longModel.head] placeholderImage:[UIImage imageNamed:@"Meimei_Logo"]];
    [self.logoButton setRoundedCorners:UIRectCornerAllCorners radius:CGSizeMake(self.logoButton.width/2, self.logoButton.width/2)];
    self.logoButton.imageView.contentMode=UIViewContentModeScaleAspectFill;
    
    //1.
    if ([longModel.img isKindOfClass:[NSNull class]]||!longModel.img ) {
        self.otherView.hidden=YES;

    }else{
        self.otherView.hidden=NO;

        [_single_imageView sd_setImageWithURL:[NSURL URLWithString:longModel.img] placeholderImage:[UIImage imageNamed:@"Meimei_Logo"]];
        _single_imageView.contentMode=UIViewContentModeScaleAspectFill;
        [self.otherView addSubview:self.single_imageView];

    }
    
    //2,
    self.like_button.selected=_longModel.isLike;
    if (longModel.favourNum>0) {
        
        NSString * likeString = [NSString stringWithFormat:@"%d",(int)longModel.favourNum];
        UIControlState state=_longModel.isLike?UIControlStateSelected:UIControlStateNormal;
        [self.like_button setTitle:likeString forState:state];
    }else{
        [self.like_button setTitle:@"赞" forState:UIControlStateNormal];

    }
    
    //3.时间
    self.timeLab.text=longModel.msg_dealed_time;
    
}
- (void)likeAction:(id)sender {
    UIButton * btn =( UIButton *)sender;
    btn.selected=!btn.selected;
    NSLog(@"select:%d",btn.selected);
    
    NSInteger  total_like_num =self.longModel.favourNum;
    NSString * selected_like_num =nil;
    if (btn.selected) {
        NSInteger num =self.longModel.isLike?total_like_num-1:total_like_num+1;
        selected_like_num = [NSString stringWithFormat:@"%d",(int)num];
        [self.like_button setTitle:selected_like_num forState:UIControlStateSelected];
        
    }else{
        if (total_like_num<=0) {
            [self.like_button setTitle:@"赞" forState:UIControlStateNormal];
        }else{
            selected_like_num = [NSString stringWithFormat:@"%d",(int)total_like_num-1];
            [self.like_button setTitle:selected_like_num forState:UIControlStateNormal];
        }
    }

    
    //1.回调
    self.longModel.isLike=btn.selected;
    self.longModel.favourNum=[selected_like_num integerValue];
    
    //2.点赞同步服务器
    [Hi_BusinessTool postLongMessagesPraise:btn.selected msgID:self.longModel.ID Success:^(id result) {
        if (result) {
        }else{
            self.longModel.isLike=NO;

        }
        if (self.LikeAction) {
            self.LikeAction(self,self.longModel);
        }
    } failure:^(NSError *error) {
        self.longModel.isLike=NO;
        if (self.LikeAction) {
            self.LikeAction(self,self.longModel);
        }
    }];
   
}
//3.点赞
-(void)tapLike:(BaseTableViewCellLikeAction)action{
        self.LikeAction=action;
    
}
-(void)dealloc{self.AvatarAction=nil;self.ImageWallAction=nil; self.LikeAction=nil;}
@end
