

#import "Hi_CouponsTool.h"
#import "Hi_CouponsModel.h"
@implementation Hi_CouponsTool

#pragma mark - 查看所有有效优惠券接口
+(void)getAllCouponsbegin:(NSInteger)begin
                    limit:(NSInteger)limit
                  success:(HttpSuccessBlock)success
                  failure:(HttpFailureBlock)failure{

    NSDictionary * param=@{@"id": MY_UID,
                           @"begin":@(begin),
                           @"limit":@(limit)};
    [HttpTool postWithPath:@"MM/coupons/list.action" params:param success:^(id result) {
        
        if (!result[@"success"]||!result[@"data"]) {
            success(nil);
             return;
        }
       
        [Hi_ThreadTool ES_AsyncConcurrentOperationQueueBlock:^{
            for (NSDictionary * dic in result[@"data"]) {
                Hi_CouponsModel * coupon=[[Hi_CouponsModel alloc]initWithDictionary:dic];
                coupon.cid=dic[@"id"];
                [Hi_CouponsModel insertModelToDB:coupon condition:Hi_COUPONS_CONDTION_ID( coupon.cid) didInsertBlock:nil];

            }
            success(@(YES));
        }];
       
        
        
    } failure:^(NSError *error) {
        failure(error);
    }];
    
}

//查看店家的所有有效优惠券接口
+(void)getCouponsWithBusiness:(NSString*)BID
                        begin:(NSInteger)begin
                        limit:(NSInteger)limit
                      success:(HttpSuccessBlock)success
                      failure:(HttpFailureBlock)failure{

    if (!BID) {
        return;
    }
    NSDictionary * param=@{@"bid": BID,
                           @"begin":@(begin),
                           @"limit":@(limit)};
    [HttpTool getWithPath:@"MM/coupons/list.action" params:param success:^(id result) {
        
        NSArray * couponArray =result[@"data"];
        if (!couponArray) {
            return;
        }
        NSMutableArray *temp=[NSMutableArray array];
        for (NSDictionary * dic in couponArray) {
        
            
            
            Hi_CouponsModel * coupon=[[Hi_CouponsModel alloc]initWithDictionary:dic];
//            coupon.ID=[NSString str]
            coupon.cid=[NSString stringWithFormat:@"%@",dic[@"id"]];
            coupon.bid=BID;
            [Hi_CouponsModel insertModelToDB:coupon condition:Hi_COUPONS_CONDTION_ID(coupon.cid) didInsertBlock:nil];

            [temp addObject:coupon];
        }
        
        success(temp);
        
    } failure:^(NSError *error) {
        failure(error);

    }];

}
+(void)getCoupon:(NSString*)CID
         success:(HttpSuccessBlock)success
         failure:(HttpFailureBlock)failure{
    
    if (!CID) {
        return;
    }
    NSDictionary * param=@{@"id": CID};
    [HttpTool getWithPath:@"MM/coupons/find.action" params:param success:^(id result) {
        
        
        if (result[@"data"]) {
            NSDictionary * dic =result[@"data"];
            Hi_CouponsModel * coupon=[[Hi_CouponsModel alloc]initWithDictionary:dic];
            coupon.cid=[NSString stringWithFormat:@"%@",dic[@"id"]];
            success(coupon);

        }else{
            success(nil);
        }
        
        
      
        
    } failure:^(NSError *error) {
        failure(error);

    }];
    
}

//查看自己拥有的优惠券接口
+(void)getMyCouponsbegin:(NSInteger)begin
                   limit:(NSInteger)limit
                 success:(HttpSuccessBlock)success
                 failure:(HttpFailureBlock)failure{

    
    
    
    

}


//获取优惠券
+(void)obtainCoupons:(NSString*)UID
                With:(NSString*)CID
             Success:(HttpSuccessBlock)success
             failure:(HttpFailureBlock)failure{


}

//转发优惠券
+(void)retweetCoupons:(NSString*)UID
                 With:(NSString*)CID
              Success:(HttpSuccessBlock)success
              failure:(HttpFailureBlock)failure{}

//使用优惠券
+(void)useCoupons:(NSString*)UID
             With:(NSString*)CID
          Success:(HttpSuccessBlock)success
          failure:(HttpFailureBlock)failure{}
@end
