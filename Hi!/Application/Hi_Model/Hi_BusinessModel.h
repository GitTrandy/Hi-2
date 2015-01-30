/*
 2、店家详细页
 
 a. 内容：即店家在后台输入的内容。
 b. 展示模式：常规手机网页模式（即上下滚动） 。
 c. 操作：
 1. 查看店家介绍（一个店家可有多条介绍，列表形式显示）
 2. 查看店家优惠
 3. 推荐店家（内部是好友间转发，可多选；外部通过三方分享平台推荐）
 4. 喜欢
 5. 不喜欢
 
 */

#import "Hi_BaseModel.h"

@interface Hi_BusinessModel :Hi_BaseModel

@property (nonatomic, assign)int friends;//店铺类型

@property (nonatomic, copy)     NSString *bid;
@property (nonatomic, copy)     NSString *name;
@property (nonatomic, copy)     NSString *address;
@property (nonatomic, strong)   NSArray* photos;
@property (nonatomic, copy)     NSString *sms;
@property (nonatomic, copy)     NSString *fixPhone;

//1,图片
@property (nonatomic, copy)     NSString *logo;
@property (nonatomic, copy)     NSString *logo_1;
@property (nonatomic, copy)     NSString *logo_2;
@property (nonatomic, copy)     NSString *logo_3;

//2.时间
@property (nonatomic, copy)     NSString *createTime; //创建时间
@property (nonatomic, copy)NSString *createTimeDate;
@property (nonatomic, copy)NSString *serviceTime;//服务时间


//3,其他
@property (nonatomic, assign)NSInteger coupons;
@property (nonatomic, assign)NSInteger islove;

@property (nonatomic, copy)NSString *balance;//余额
@property (nonatomic, copy)NSString *descHtml;//图文简介
@property (nonatomic, copy)NSString *spreadCode;//推广码
@property (nonatomic, copy)NSString *businessType;
@property (nonatomic, copy)NSString *contact;
@property (nonatomic, copy)NSString *coordinates;

@property (nonatomic, copy)NSString *remark;
@property (nonatomic, copy)NSString * self_id;
@end
