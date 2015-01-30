/*
 3、优惠详细页
 
 a. 内容：即店家在后台输入的内容。
 b. 展示模式：常规手机网页模式（即上下滚动） 。
 c. 操作：

 1. 查看对应店家页。
 2. 获取优惠：点击后服务器将发送优惠到消息栏目，对应优惠次数减1。
 3. 转发优惠（内部是好友间转发，可多选；外部通过三方分享平台推荐）
 */

/**
 *  礼券
 */

#import "Hi_BaseModel.h"

#define Hi_COUPONS_CONDTION_ID(CID) [NSString stringWithFormat:@"cid = '%@'",CID]
@interface Hi_CouponsModel : Hi_BaseModel
@property (nonatomic, copy)NSString * self_id;

@property (nonatomic, copy)NSString *cid;
@property (nonatomic, copy)NSString *bid;
@property (nonatomic, copy)NSString *title;
@property (nonatomic, copy)NSString *name;

@property (nonatomic, copy)NSString *logo;
@property (nonatomic, copy)NSString *image;
@property (nonatomic, copy)NSString *image_1;
@property (nonatomic, copy)NSString *image_2;
@property (nonatomic, copy)NSString *image_3;

@property (nonatomic, copy)NSString *remark;
@property (nonatomic, copy)NSString * total;//使用次数 默认:0 代表无限
@property (nonatomic, copy)NSString * forwardEffe;//转发是否有效 0:无效 1:有效 默认:1
@property (nonatomic, copy)NSString * aloneEffe;//是否单独使用 1:单独使用 0:可以共同使用
@property (nonatomic, copy)NSString *content;
@property (nonatomic, copy)NSString *coordinates;//用户备注

@property (nonatomic, copy)NSString *phone;
@property (nonatomic, copy)NSString *address;

@property (nonatomic, copy)NSString *endTimeFormat;
@property (nonatomic, copy)NSString *startTimeFormat;
@property (nonatomic, copy)NSString *endTime;
@property (nonatomic, copy)NSString *startTime;


#pragma mark -额外参数
@property (nonatomic, assign)BOOL isUse;//是否使用,默认没有
@property (nonatomic, assign)NSInteger use_time;//默认30秒




@end
