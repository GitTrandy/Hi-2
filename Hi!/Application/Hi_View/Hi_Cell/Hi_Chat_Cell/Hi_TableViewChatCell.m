
#import "Hi_TableViewChatCell.h"
#import "Hi_AccountTool.h"
#import "UIImage+XHRounded.h"

@interface Hi_TableViewChatCell()
@property (nonatomic,strong)Hi_Account * account;

@end

@implementation Hi_TableViewChatCell

+(instancetype)instancetypeWithXib{

    return [[NSBundle mainBundle]loadNibNamed:@"Hi_TableViewChatCell" owner:nil options:nil][0];
}


- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    //1.头像
    UIImageView * coverImgView=[[UIImageView alloc]initWithFrame:_logoView.frame];
    coverImgView.image=[UIImage imageNamed:@"mask_blank"];
    [self.contentView addSubview:coverImgView];
    self.msgActivty.hidden=YES;
    _account=[Hi_AccountTool getCurrentAccount];
   

    //2.Emoji_Msg
    _msgLab.customEmojiRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
    _msgLab.customEmojiPlistName=@"sinaExpression.plist";
    
    //3.长按
    UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureRecognizerHandle:)];
    [recognizer setMinimumPressDuration:0.4f];
    self.msgLab.userInteractionEnabled=YES;
    [self.msgLab addGestureRecognizer:recognizer];
   
    //4.点击头像
    UITapGestureRecognizer * tapImage =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImage:)];
    [self.msg_imageView addGestureRecognizer:tapImage];
    [self.msg_imageView setUserInteractionEnabled:YES];
    

}
#pragma mark -UI

-(UIImageView *)msg_imageView{

    if (!_msg_imageView) {
        UIImageView * msg_imageView = [[UIImageView alloc]initWithFrame:self.content_view.bounds];
        _msg_imageView=msg_imageView;
    }
    return _msg_imageView;
    
}
-(void)setSmsModel:(Hi_SMSModel *)smsModel{

    _smsModel=smsModel;
    
    switch (smsModel.m_type) {
        case MsgTypeText:
        {
            self.content_view.hidden=YES;
            self.msgLab.hidden=NO;
            self.msgLab.emojiText=self.smsModel.m_content;
            break;
        }
            
        case MsgTypeImage:
        {
            
            self.content_view.hidden=NO;
            self.msgLab.hidden=YES;

            [self.msg_imageView sd_setImageWithURL:[NSURL URLWithString:smsModel.m_content_img_url] placeholderImage:smsModel.m_content_img];
            self.msg_imageView.contentMode=UIViewContentModeScaleAspectFill;
            [self.content_view addSubview:self.msg_imageView];
            
            break;
        }
            
            
        default:
            break;
    }
   
    //    self.msgLab.text=smsDetailModel.msg;
    self.timeLab.text=smsModel.timeRealString;
    
    
    switch (self.smsModel.status) {
        case MsgStatusSendStart:
            self.msgActivty.hidden=NO;
            [self.msgActivty startAnimating];
            break;
        case MsgStatusSendSucceed:
            self.msgActivty.hidden=YES;
            [self.msgActivty stopAnimating];
            break;
        case MsgStatusSendFailed:
            self.msgActivty.hidden=YES;
            [self.msgActivty stopAnimating];
            self.whoView.image=[UIImage imageNamed:@"msg_send_failure"];
            NSLog(@"失败");
            break;
            
        default:
            break;
    }
    
    
    if ([smsModel.fromPeerId isEqualToString:MY_UID]) {
        self.logoView.image=_account.image;
        self.whoView.image=[UIImage imageNamed:@"msg_mine"];
        
    }else{
        [self.logoView sd_setImageWithURL:[NSURL URLWithString:smsModel.u_head] placeholderImage:[UIImage imageNamed:@"user_img"]];
        self.whoView.image=[UIImage imageNamed:@"msg_send"];
        
    }
    
}

-(CGFloat)cellHeight{

    [self.msgLab sizeToFit];
    if (self.smsModel.m_type==0) {
        return 80+self.msgLab.height;
    }else if(self.smsModel.m_type==1){
        return 80+self.msgLab.height+self.content_view.height;
    }else{
        return 80;
    }
  
    
 }

#pragma mark -构建Cell（根据数据）
+(id)configureCellWithClass:(Class)cellClass
                 WithCellID:(NSString*)CellIdentifier
              WithTableView:(UITableView*)tableView{
    
    
    //NIB万岁
    BOOL nibsRegistered = NO;
    if (!nibsRegistered) {
        UINib *nib = [UINib nibWithNibName:NSStringFromClass([Hi_TableViewChatCell class]) bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:CellIdentifier];
        nibsRegistered = YES;
    }
    Hi_TableViewChatCell *cell = (Hi_TableViewChatCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    
    return cell;
    
}

- (void)longPressGestureRecognizerHandle:(UILongPressGestureRecognizer *)longPressGestureRecognizer {
//        if (longPressGestureRecognizer.state != UIGestureRecognizerStateBegan || ![self becomeFirstResponder])
//            return;
//
    
    UIMenuController *menu = [UIMenuController sharedMenuController];
    [menu setTargetRect:self.msgLab.frame inView:self.msgLab.superview];
    [menu setMenuVisible:YES animated:YES];
    
//    if (self.tapMsgLabelBlock) {
//        self.tapMsgLabelBlock(longPressGestureRecognizer);
//    }

}
- (BOOL) canBecomeFirstResponder
{
    return YES;
}
#pragma mark -点击
-(void)tapImage:(UITapGestureRecognizer*)tap{
    
    if (self.tapImageViewBlock) {
        self.tapImageViewBlock(tap.view);
    }
    
}
-(void)addActionImageViewBlock:(tapImageViewBlock)tapImageViewBlock{self.tapImageViewBlock=tapImageViewBlock;}
-(void)addActionMsgLabelBlock:(tapMsgLabelBlock)tapMsgLabelBlock{self.tapMsgLabelBlock=tapMsgLabelBlock;}
@end
