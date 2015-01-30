
///用户信息
typedef NS_ENUM(NSInteger, Hi_UserModelRelationType) {
    Hi_UserModelRelationTypeNone,
    Hi_UserModelRelationTypeFan,
    Hi_UserModelRelationTypeFollow,
    Hi_UserModelRelationTypeEachOther,
    
};

#import "Hi_BaseModel.h"
#define HI_USER_MODEL_UID_SQL(UID) [NSString stringWithFormat:@"uid='%@'",UID]
@interface Hi_UserModel :Hi_BaseModel
@property (nonatomic, copy)NSString * self_id;

//@property (nonatomic, strong)NSString *ID;//用户UID
@property (nonatomic, strong)NSString *nickName;//昵称
@property (nonatomic, strong)NSString *openID;//第三方登录OpenID
@property (nonatomic, strong)NSString *uid;//UID

@property (nonatomic, strong)NSString *accostTimes;//被赞数
@property (nonatomic, strong)NSString *occupation;
@property (nonatomic, strong)NSMutableArray* photos;

@property (nonatomic, strong)NSString *phone;
@property (nonatomic, strong)NSString *currentState;//当前状态
@property (nonatomic, strong)NSString *note;//用户标签
@property (nonatomic, strong)NSString *sex;//用户性别
@property (nonatomic, strong)NSString *interest;//用户兴趣爱好
@property (nonatomic, strong)NSString *head;//头像Url地址
@property (nonatomic, strong)NSString* openType;
@property (nonatomic, assign)Hi_UserModelRelationType type;//好友类型

@property (nonatomic, strong)NSString* birthDay;//用户生日
@property (nonatomic, strong)NSString*birthDayStr;
@property (nonatomic, strong)NSString * age;
@property (nonatomic, strong)NSString * Xingzuo;
//好友列表
@property (nonatomic, strong)NSString *location;
//计算后
+(void)addFriendDidArrived;

@end
