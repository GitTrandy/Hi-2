/*
 1.封装简单的web服务
 2.传输格式:JSON
 3.GET.POST,etc
 
 */

#import <Foundation/Foundation.h>
#define BASEURL @"http://mmapiss.meimeime.com:8081"//112.124.98.154
@interface HttpTool : NSObject



typedef void(^HttpSuccessBlock)(id result);
typedef void(^HttpFailureBlock)(NSError * error);
typedef void(^imageSuccessBlock)(CGSize imageSize);

/**
 *  根据URL路径跟请求参数完成GET请求
 *
 *  @param path         详细路径
 *  @param param        请求参数
 *  @param successBlock 请求成功
 *  @param failureBlock 请求失败
 */
+ (void)getWithPath:(NSString *)path params:(NSDictionary *)params
                success:(HttpSuccessBlock)success
                failure:(HttpFailureBlock)failure;

/**
 *  根据URL路径跟请求参数完成GET请求
 *
 *  @param path         详细路径
 *  @param param        请求参数
 *  @param successBlock 请求成功
 *  @param failureBlock 请求失败
 */

+ (void)postWithPath:(NSString *)path
              params:(NSDictionary *)params
             success:(HttpSuccessBlock)success
             failure:(HttpFailureBlock)failure;





+ (void)headWithPath:(NSString *)path
              params:(NSDictionary *)params
             success:(HttpSuccessBlock)success
             failure:(HttpFailureBlock)failure;

//- (NSURLSessionDataTask *)HEAD:(NSString *)URLString
//                    parameters:(NSDictionary *)parameters
//                       success:(void (^)(NSURLSessionDataTask *task))success
//                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

/**
 *  下载资源文件
 *
 *  @param fileURL 文件路径
 */
+(void)downloadFile:(NSString *)fileURL;

/**
    上传图片
 */
#pragma mark -上传图片
+(void)upLoadimage:(UIImage*)image
              path:(NSString*)path
             param:(NSDictionary*)param
          imageKey:(NSString*)imageKey
           success:(HttpSuccessBlock)success
           failure:(HttpFailureBlock)failure;




@end
