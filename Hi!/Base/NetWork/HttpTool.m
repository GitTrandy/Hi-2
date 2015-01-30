/*
 可以自定义实现HTTP请求
 1.AF2.0
 2.IOS7自带的
 
 */

#import "HttpTool.h"
#import "AFHTTPSessionManager.h"
#import "AFNetworking.h"
//#warning "要改"





@interface HttpTool ()

@end


@implementation HttpTool
#pragma mark -上传图片
+(void)upLoadimage:(UIImage*)image
              path:(NSString*)path
             param:(NSDictionary*)param
          imageKey:(NSString*)imageKey
           success:(HttpSuccessBlock)success
           failure:(HttpFailureBlock)failure{
    
    AFHTTPRequestOperationManager *httpManager = [AFHTTPRequestOperationManager manager];
    NSData * imageData=UIImageJPEGRepresentation(image, 1.0);
    NSString * fullPath = [NSString stringWithFormat:@"%@/%@",BASEURL,path];
   [httpManager POST:fullPath parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:imageData name:imageKey fileName:@"jjjjjj.jpg" mimeType:@"image/jpeg"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
        NSLog(@"失败原因:%@---%@",error,operation);
    }];
    
    
    
}
#pragma mark -GET
+ (void)getWithPath:(NSString *)path params:(NSDictionary *)params success:(HttpSuccessBlock)success failure:(HttpFailureBlock)failure{

    [HttpTool requestWithPath:path params:params success:success failure:failure method:@"GET"];
}
#pragma mark -POST
+ (void)postWithPath:(NSString *)path params:(NSDictionary *)params success:(HttpSuccessBlock)success failure:(HttpFailureBlock)failure{

     [HttpTool requestWithPath:path params:params success:success failure:failure method:@"POST"];
}

+ (void)headWithPath:(NSString *)path
              params:(NSDictionary *)params
             success:(HttpSuccessBlock)success
             failure:(HttpFailureBlock)failure{
    
    [HttpTool requestWithPath:path params:params success:success failure:failure method:@"HEAD"];
    
}
#pragma mark -设置网络照片到视图中
//+ (void)downloadImage:(NSString *)url place:(UIImage *)place imageView:(UIImageView *)imageView success:(imageSuccessBlock)success{
//
//
//    
//    [imageView setImageWithURL:[NSURL URLWithString:url] placeholderImage:place options:SDWebImageLowPriority];
//    
//  
//
//}
#pragma mark -下载文件
+(void)downloadFile:(NSString *)fileURL{

    
   // NSURLRequest * urlRequset = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:fileURL]];
    
}

#pragma mark -辅助方法
+ (void)requestWithPath:(NSString *)path params:(NSDictionary *)params success:(HttpSuccessBlock)success failure:(HttpFailureBlock)failure method:(NSString *)method
{
  
    
    //2.拼接完整请求参数
    NSMutableDictionary *allParams = [NSMutableDictionary dictionary];
    // a.拼接传进来的参数
    if (params) {
        [allParams setDictionary:params];
//        if (UID) {
//            [allParams addEntriesFromDictionary:@{USER_UID:UID}];
//            
//        }
//
    }
    
    
    

#pragma mark -开始POST +GET +PUT +DEL
  
    //1,config
    NSURLSessionConfiguration  * sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    sessionConfiguration.timeoutIntervalForRequest=10;
    [sessionConfiguration setHTTPAdditionalHeaders:@{@"Content-Type": @"application/json"}];
    
    AFHTTPSessionManager * httpManager = [[AFHTTPSessionManager alloc]initWithBaseURL:[NSURL URLWithString:BASEURL] sessionConfiguration:sessionConfiguration];
    httpManager.responseSerializer =[AFJSONResponseSerializer serializer];

    
      //3.发送请求
    if ([method isEqualToString:@"GET"]) {
        
               NSURLSessionDataTask * getTask = [httpManager GET:path parameters:allParams success:^(NSURLSessionDataTask *task, id responseObject) {
                   
                  // NSLog(@"URL地址:%@",task.currentRequest);
                   if (responseObject[@"success"]&&[responseObject[@"success"] isEqualToNumber:@(0)]) {
                       success(nil);
                       return;
                   }
                   success(responseObject);
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            //
            failure(error);
        }];
        
          [getTask resume];
        
      
    }else if ([method isEqualToString:@"POST"]){
    
        NSURLSessionDataTask * postTask = [httpManager POST:path parameters:allParams success:^(NSURLSessionDataTask *task, id responseObject) {
            //
        //    NSLog(@"URL地址:%@",task.currentRequest);
            if (!responseObject[@"success"]||[responseObject[@"success"] isEqualToNumber:@(0)]) {
                success(nil);
                return;
            }
            success(responseObject);
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            //
            NSLog(@"URL错误:%@",error);
            failure(error);
        }];
        
        [postTask resume];
        
    }
    else if ([method isEqualToString:@"HEAD"]){
        
        NSURLSessionDataTask * postTask = [httpManager HEAD:path parameters:allParams success:^(NSURLSessionDataTask *task) {
            //
             success(task.response);
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            //
             failure(error);
        }];
        [postTask resume];
        
    }
    
    
    
}


@end
