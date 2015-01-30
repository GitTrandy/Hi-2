//
//  Hi_TableViewSecondCell.m
//  Hi!
//
//  Created by 伍松和 on 14/11/27.
//  Copyright (c) 2014年 伍松和. All rights reserved.
//

#import "Hi_TableViewSecondCell.h"

@implementation Hi_TableViewSecondCell
+(instancetype)instancetypeWithSecondNib{
    
    return  [[NSBundle mainBundle]loadNibNamed:@"Hi_TableViewSecondCell" owner:nil options:nil][0];
    
}
- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

-(void)setBusinessModel:(Hi_BusinessModel *)businessModel{
    
    _businessModel=businessModel;
    //1-UI
    [self.logoView sd_setImageWithURL:[NSURL URLWithString:businessModel.logo] placeholderImage:[UIImage imageNamed:@"user_img"]];
    self.titleLab.text =businessModel.name;
    self.detailLab.text=businessModel.remark?businessModel.remark:@"暂时无简介";
    self.bottomTitleLab.text=businessModel.address?businessModel.address:@"呵呵,这货居然不写地址";
    
}

@end
