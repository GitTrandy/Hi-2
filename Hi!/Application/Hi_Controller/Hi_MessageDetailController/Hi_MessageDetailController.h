//
//  Hi_MessageDetailController.h
//  Hi!
//
//  Created by 伍松和 on 14/11/28.
//  Copyright (c) 2014年 伍松和. All rights reserved.
//

#import "MessageDisplayController.h"
#import "MJRefresh.h"

@class Hi_UserModel;
@interface Hi_MessageDetailController : MessageDisplayController

@property (nonatomic,strong)Hi_UserModel * userModel;

///**
// *  如果从 wifi 列表进入
// */
//@property (assign, nonatomic)BOOL isSameWifi;//
//@property (nonatomic,strong)UIImage * miniImage;
//@property (nonatomic,strong)UIImage * otherImage;



@end
