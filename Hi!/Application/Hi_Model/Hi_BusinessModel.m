//
//  BusinessModel.m
//  Meimei
//
//  Created by namebryant on 14-7-3.
//  Copyright (c) 2014年 namebryant. All rights reserved.
//

#import "Hi_BusinessModel.h"
#import "Hi_CouponsTool.h"
@implementation Hi_BusinessModel





-(NSArray *)photos{
    
    NSMutableArray * arrayM=[NSMutableArray array];
    if (self.logo_1&&![self.logo_1 isKindOfClass:[NSNull class]]) {
        [arrayM addObject:self.logo_1];
    }if (self.logo_2&&![self.logo_2 isKindOfClass:[NSNull class]]) {
        [arrayM addObject:self.logo_2];
    }if (self.logo_3&&![self.logo_3 isKindOfClass:[NSNull class]]) {
        [arrayM addObject:self.logo_3];
    }

    
    return arrayM;

}
-(void)setBid:(NSString *)bid{

    _bid=bid;
    [Hi_CouponsTool getCouponsWithBusiness:bid begin:0 limit:30 success:^(id result) {
        //
    } failure:^(NSError *error) {
        //
    }];
    
}
@end
