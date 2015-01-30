

#import "Hi_API_CLASS.h"



@interface Hi_CouponsTool : Hi_API_CLASS
#pragma mark - 查看优惠券接口
+(void)getCoupon:(NSString*)CID
         success:(HttpSuccessBlock)success
         failure:(HttpFailureBlock)failure;
#pragma mark - 查看所有有效优惠券接口
+(void)getAllCouponsbegin:(NSInteger)begin
                        limit:(NSInteger)limit
                      success:(HttpSuccessBlock)success
                  failure:(HttpFailureBlock)failure;

#pragma mark - 查看店家的所有有效优惠券接口
+(void)getCouponsWithBusiness:(NSString*)BID
                  begin:(NSInteger)begin
                  limit:(NSInteger)limit
                      success:(HttpSuccessBlock)success
                      failure:(HttpFailureBlock)failure;


//查看自己拥有的优惠券接口
+(void)getMyCouponsbegin:(NSInteger)begin
                        limit:(NSInteger)limit
                 success:(HttpSuccessBlock)success
                 failure:(HttpFailureBlock)failure;


//获取优惠券
+(void)obtainCoupons:(NSString*)UID
                With:(NSString*)CID
             Success:(HttpSuccessBlock)success
             failure:(HttpFailureBlock)failure;

//转发优惠券
+(void)retweetCoupons:(NSString*)UID
                With:(NSString*)CID
             Success:(HttpSuccessBlock)success
             failure:(HttpFailureBlock)failure;

//使用优惠券
+(void)useCoupons:(NSString*)UID
                With:(NSString*)CID
             Success:(HttpSuccessBlock)success
             failure:(HttpFailureBlock)failure;
@end
