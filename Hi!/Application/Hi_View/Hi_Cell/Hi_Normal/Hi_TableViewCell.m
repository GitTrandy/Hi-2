//
//  Hi_TableViewCell.m
//  Hi!
//
//  Created by 伍松和 on 14/11/27.
//  Copyright (c) 2014年 伍松和. All rights reserved.
//

#import "Hi_TableViewCell.h"

@implementation Hi_TableViewCell

+(instancetype)instancetypeWithNib{

    return  [[NSBundle mainBundle]loadNibNamed:@"Hi_TableViewCell" owner:nil options:nil][0];
}

- (void)awakeFromNib {
    
        [super awakeFromNib];
    
    //0.
        [self.logoView setRoundedCorners:UIRectCornerAllCorners radius:CGSizeMake(self.logoView.width/2, self.logoView.width/2)];
        UITapGestureRecognizer * tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        self.logoView.userInteractionEnabled=YES;
        [self.logoView addGestureRecognizer:tap];
    //1.
    

}
-(void)tapAction:(UITapGestureRecognizer*)tap{

    if (self.btnActionBlock) {
        self.btnActionBlock(self,tap.view.tag);
    }
}

-(void)setUserModel:(Hi_UserModel *)userModel{

    _userModel=userModel;
    
    //1-UI
    [self.logoView sd_setImageWithURL:[NSURL URLWithString:userModel.head] placeholderImage:[UIImage imageNamed:@"user_img"]];
  
    self.titleLab.text =userModel.nickName;
    self.detailLab.text=userModel.currentState?userModel.currentState:@"这个人好懒,没有写状态";
    
    //2.
    self.rightBtn.hidden=NO;
    
    NSString * imgName =nil;
    switch (userModel.type) {
              //3.现场/没有关系链的
             case Hi_UserModelRelationTypeNone:imgName=([userModel.sex isEqualToString:@"男"])?@"tab_icon_boy":@"tab_icon_girl"; break;
             case Hi_UserModelRelationTypeFan:imgName=@"contact_send_small";break;
             case Hi_UserModelRelationTypeFollow:imgName=@"contact_like";break;//
             case Hi_UserModelRelationTypeEachOther:imgName=@"contact_togeter";break;//
                default:
                break;
    }
    [self.rightBtn setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];

    
    
   
}

-(void)setSmsModel:(Hi_SMSModel *)smsModel{


    _smsModel =smsModel;
    
    
    //1-UI
    [self.logoView sd_setImageWithURL:[NSURL URLWithString:smsModel.u_head] placeholderImage:[UIImage imageNamed:@"user_img"]];
    
    self.rightLab.text=smsModel.timeRealString;
    
    NSString * status = nil;
    switch (smsModel.status) {
        case MsgStatusSendStart:
            status =@"(发送中..)";
            break;
        case MsgStatusSendSucceed:
            status =@"";
            break;
        case MsgStatusSendFailed:
            status =@"(发送失败..)";
            break;
        case MsgStatusSendReceived:
            status =@"";
            break;
            
        default:
            break;
    }
    self.detailLab.text=[NSString stringWithFormat:@"%@%@",smsModel.m_content,status];

    if (smsModel.status==MsgStatusSendFailed) {
        self.detailLab.textColor=[UIColor redColor];
    }else{
        self.detailLab.textColor=[UIColor lightGrayColor];

    }
    
    
    NSInteger  num=[Hi_SMSModel hi_dealWithUnreadMessageNum:smsModel.u_uid];
    NSString * ssss=smsModel.u_name;
    NSString * readNum=[NSString stringWithFormat:@"%d",(int)num];

    if (num>0) {
       ssss=[NSString stringWithFormat:@"%@(%@)",smsModel.u_name,readNum];
    }
    self.titleLab.text =ssss;

    //2.
    switch (self.smsModel.m_type) {
        case MsgTypeText:
            //
            break;
        case MsgTypeImage:
            self.detailLab.text=@"[图片]";
            break;
            
        default:
            break;
    }

    

}
#pragma mark -构建Cell（根据数据）
+(id)configureCellWithClass:(Class)cellClass
                 WithCellID:(NSString*)CellIdentifier
              WithTableView:(UITableView*)tableView{
    
    
    //NIB万岁
    BOOL nibsRegistered = NO;
    if (!nibsRegistered) {
        UINib *nib = [UINib nibWithNibName:NSStringFromClass([Hi_TableViewCell class]) bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:CellIdentifier];
        nibsRegistered = YES;
    }
    Hi_TableViewCell *cell = (Hi_TableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    UIView *v=[[UIView alloc]initWithFrame:cell.bounds];
    v.backgroundColor=[UIColor clearColor];
    cell.multipleSelectionBackgroundView=v;//UITableViewCellStateShowingEditControlMask=UITableViewCellSelectionStyleGray;
    
    return cell;
    
}

@end
