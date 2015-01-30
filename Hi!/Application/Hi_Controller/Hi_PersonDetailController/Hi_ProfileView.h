//
//  ES_ProfileView.h
//  易商
//
//  Created by 伍松和 on 14/11/11.
//  Copyright (c) 2014年 Ruifeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Hi_UserModel.h"
#import "Hi_Account.h"
typedef void(^hi_profile_block) (id result);

@interface Hi_ProfileView : UIView
@property (strong, nonatomic) IBOutlet UIImageView * imageView;
@property (strong, nonatomic) IBOutlet UILabel  * nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageLab;
@property (weak, nonatomic) IBOutlet UILabel *xingzuoLab;
@property (weak, nonatomic) IBOutlet UILabel *jobLab;
@property (weak, nonatomic) IBOutlet UIButton *camera_btn;
@property (nonatomic,strong)Hi_UserModel * userModel;
@property (nonatomic,strong)Hi_Account * account;
+(instancetype)instancetypeWithXib;

@end
