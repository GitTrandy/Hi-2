
typedef void(^ThreadCodeBlock)();

#import <Foundation/Foundation.h>

///线程管理
@interface Hi_ThreadTool : NSObject
///异步串行处理
+(void)ES_AsyncSerialQueue:(char*)queueName
                   threadCodeBlock:(ThreadCodeBlock)threadCodeBlock;

///异步并行处理
+(void)ES_AsyncConcurrentQueue:(char*)queueName
               threadCodeBlock:(ThreadCodeBlock)threadCodeBlock;

///直接后台异步执行(该队列限制在3-6线程)
+(void)ES_AsyncConcurrentOperationQueueBlock:(ThreadCodeBlock)threadCodeBlock;

///后台异步执行 + 主线程执行
+(void)ES_AsyncConcurrentOperationQueueBlock:(ThreadCodeBlock)threadCodeBlock
                             MainThreadBlock:(ThreadCodeBlock)mainThreadBlock;

@end
