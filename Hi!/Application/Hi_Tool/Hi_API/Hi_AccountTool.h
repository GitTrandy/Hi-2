#import "Hi_API_CLASS.h"
#import "Hi_Account.h"
#import "UIWindow+JJ.h"

typedef NS_ENUM(int, LOGINType){
    LOGINPhone  =0,
    LOGINSinaWeibo  =1,
    LOGINCloudSNSQQ =2,
    LOGINRegitersPhone  =3,
};
typedef NS_ENUM(NSInteger, AccountType)  {
    
    AccountTypeNone=0,
    AccountTypeName=1,
    AccountTypeSex=2,
    AccountTypeBirthday=3,
    AccountTypeHobby=4,
    AccountTypeNote=5,
    AccountTypeJob=6
};
typedef NS_ENUM(NSInteger, AccountSaveType){
    /// 手机登录
    AccountSaveTypePhoneLogin  =0,
    AccountSaveTypePhoneRegiters=1,
    AccountSaveTypeThreeLogin=2,
    AccountSaveTypeThreeRegiters=3,
    
};
@class Hi_Account;

@interface Hi_AccountTool : Hi_API_CLASS


#pragma mark -1.手动注册用户


#pragma mark -2.注册.登录
//+(void)registerLoginMember:(Account*)account
//              success:(RegisterSuccessBlock)success
//              failure:(RegisterFailureBlock)failure;

#pragma mark -3.登出
+(void)LoginOutSuccess:(HttpSuccessBlock)success
               failure:(HttpFailureBlock)failure;

#pragma mark -4.用户修改
+(void)UpdateUserType:(AccountType)type
              content:(NSString*)content
              success:(HttpSuccessBlock)success
              failure:(HttpFailureBlock)failure;

#pragma mark -5.更改用户的通用状态/现场状态
+(void)UpdateUserStateType:(NSInteger)stateType
                 content:(NSString*)content
                 success:(HttpSuccessBlock)success
                 failure:(HttpFailureBlock)failure;

#pragma mark -6.位置是否可见/是否可被搭讪
+(void)UpdateUserLocation:(BOOL)le //位置是否可见
                      ae:(BOOL)ae   //是否可被搭讪
                 success:(HttpSuccessBlock)success
                 failure:(HttpFailureBlock)failure;

#pragma mark -7.绑定手机号码的第一步操作:发送验证码短信
+(void)BindPhone:(NSString*)phone
                 success:(HttpSuccessBlock)success
                 failure:(HttpFailureBlock)failure;
#pragma mark -8.用于绑定手机号码的第二步操作:验证短信验证码
+(void)VerifyPhone:(NSString*)phone
                     code:(NSString*)code
                success:(HttpSuccessBlock)success
                failure:(HttpFailureBlock)failure;


#pragma mark -12.上传图片
+(void)upLoadPhoto:(UIImage*)image
          location:(int)location
          imageKey:(NSString*)key
           Success:(HttpSuccessBlock)success
           failure:(HttpFailureBlock)failure;

#pragma mark - 更新wifiMac
+(void)updateUserWifiSuccess:(HttpSuccessBlock)success
                     failure:(HttpFailureBlock)failure;

#pragma mark -更新 AVOS
+(void)updateAVOSSuccess:(HttpSuccessBlock)success
                 failure:(HttpFailureBlock)failure;
+(void)LoginByAvosWithUserID:(NSString*)UID
                     success:(HttpSuccessBlock)success
                     failure:(HttpFailureBlock)failure;
#pragma mark - 用 AVOS 注册
+(void)registerByAvosWithUserID:(NSString*)UID
                        success:(HttpSuccessBlock)success
                        failure:(HttpFailureBlock)failure;


/**
 *  取得系统的Account
 *
 *  @return Account对象
 */
+(Hi_Account*)getCurrentAccount;


/**
 *  保存系统Account
 *
 *  @param account Account对象
 */
+(void)saveCurrentAccount:(Hi_Account*)account;

///删除

+(void)loginWithType:(LOGINType)type;
+(void)loginWithUserName:(NSString*)username
                password:(NSString*)password
                 Success:(HttpSuccessBlock)success
                 failure:(HttpFailureBlock)failure;;
+(void)registerWithUserName:(NSString*)username
                   password:(NSString*)password
                    Success:(HttpSuccessBlock)success
                    failure:(HttpFailureBlock)failure;;

@end
