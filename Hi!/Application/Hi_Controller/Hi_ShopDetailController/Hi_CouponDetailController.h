//
//  Hi_CouponDetailController.h
//  hihi
//
//  Created by 伍松和 on 14/12/11.
//  Copyright (c) 2014年 伍松和. All rights reserved.
//

#import "Hi_BaseTableSectionController.h"
@class Hi_CouponsModel;
@interface Hi_CouponDetailController : Hi_BaseTableSectionController
///优惠卷 
@property (nonatomic,strong)Hi_CouponsModel * couponModel;
///优惠卷 ID
@property (nonatomic,copy)NSString * cid;

@end
