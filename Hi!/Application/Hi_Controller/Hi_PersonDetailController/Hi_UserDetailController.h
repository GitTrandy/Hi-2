//
//  Hi_PersonInfoController.h
//  Hi!
//
//  Created by 伍松和 on 14/12/8.
//  Copyright (c) 2014年 伍松和. All rights reserved.
//

#import "Hi_ProfileController.h"
#import "Hi_UserModel.h"
@interface Hi_UserDetailController : Hi_ProfileController
@property (nonatomic,copy)NSString * user_id;
@property (nonatomic,strong)Hi_UserModel * userModel; //copy 的话要实现 copyWithZone
///YES 就是非现场 NO就是现场的
@property (nonatomic,assign)BOOL isNotLiveUserModel;
@end
