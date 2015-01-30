
#import <Foundation/Foundation.h>
/**
 *  API地址
 *
 *  @param result 无
 *
 *  @return 无
 */
#define APIURL [[NSBundle mainBundle]URLForResource:@"Hi_API_Config" withExtension:@"plist"]
#define APIDic [NSDictionary dictionaryWithContentsOfURL:APIURL]


/**
 *  企业API
 */
#define USER_API_DIC APIDic[@"USER_API"]
#define GET_USER_LIST_WIFI_API COMPANY_DIC[@"同一Wif的用户列表"]


typedef void(^HttpBlock)();
typedef void(^HttpSuccessBlock)(id result);
typedef void(^HttpSuccessArrayBlock)(NSArray* results);
typedef void(^HttpFailureBlock)(NSError * error);
typedef void(^imageSuccessBlock)(CGSize imageSize);

#import "LibMarco.h"
#import "CategoryMarco.h"
#import "Hi_GlobalMarco.h"
#import "HttpTool.h"
#import "UIWindow+JJ.h"


@interface Hi_API_CLASS : NSObject


@end
