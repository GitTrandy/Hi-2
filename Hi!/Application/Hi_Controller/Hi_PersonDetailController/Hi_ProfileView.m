//
//  ES_ProfileView.m
//  易商
//
//  Created by 伍松和 on 14/11/11.
//  Copyright (c) 2014年 Ruifeng. All rights reserved.
//

#import "Hi_ProfileView.h"
#import "UIImage+JJ.h"
@implementation Hi_ProfileView

#define ES_GRIL_COLOR  Color(254, 180, 215, 1)
#define ES_BOY_COLOR  Color(91, 168, 240, 1)
+(instancetype)instancetypeWithXib{

   
    return [[NSBundle mainBundle]loadNibNamed:@"Hi_ProfileView" owner:nil options:nil][0];
    
}
-(void)awakeFromNib{

    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(profileAction:)];
    self.userInteractionEnabled=YES;
    [self addGestureRecognizer:tap];
}
-(void)setUserModel:(Hi_UserModel *)userModel{

    _userModel=userModel;
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:userModel.head] placeholderImage:[UIImage imageNamed:@"user_img"]];
    self.nameLabel.text=_userModel.nickName;
    self.ageLab.text=_userModel.age?_userModel.age:@"未知";
    self.xingzuoLab.text=_userModel.Xingzuo?_userModel.Xingzuo:@"未知";
    self.jobLab.text=_userModel.occupation?_userModel.occupation:@"未知";
    
    if ([userModel.sex isEqualToString:@"女"]) {
        _imageView.layer.borderColor=[ES_GRIL_COLOR CGColor];
    }else{
        
        _imageView.layer.borderColor=[ES_BOY_COLOR CGColor];

        
    }    //1.

}
-(void)setAccount:(Hi_Account *)account{

    _account=account;
    [self.imageView setImage:account.image];
    self.nameLabel.text=account.NickName;
    self.ageLab.text=account.Age;
    self.xingzuoLab.text=account.Xingzuo;
    self.jobLab.text=account.Jobs;
    self.camera_btn.hidden=NO;
    if ([account.Sex isEqualToString:@"女"]) {
        _imageView.layer.borderColor=[ES_GRIL_COLOR CGColor];
    }else{
        
        _imageView.layer.borderColor=[ES_BOY_COLOR CGColor];
    }
  
    
    
}

-(void)profileAction:(id)sender{
    if (self.btnActionBlock) {
        self.btnActionBlock(self,0);
    }
}

@end
