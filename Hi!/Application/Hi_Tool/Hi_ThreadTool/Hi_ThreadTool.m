//
//  ES_ThreadTool.m
//  易商
//
//  Created by 伍松和 on 14/11/10.
//  Copyright (c) 2014年 Ruifeng. All rights reserved.
//

#import "Hi_ThreadTool.h"

@implementation Hi_ThreadTool

static  NSOperationQueue * _ConcurrentQueue;


+(void)initialize{

    _ConcurrentQueue=[[NSOperationQueue alloc]init];
    _ConcurrentQueue.maxConcurrentOperationCount=7;

}
//+(void)ES_AsyncSerialQueue:(char*)queueName
//     threadCodeBlock:(ThreadCodeBlock)threadCodeBlock{
//
//    GCDQueue *queue = [[GCDQueue alloc] initSerial:queueName];
//    [queue queueBlock:^{
//        if (threadCodeBlock) {
//            threadCodeBlock();
//        }
//    }];
//
//}
//+(void)ES_AsyncConcurrentQueue:(char*)queueName
//               threadCodeBlock:(ThreadCodeBlock)threadCodeBlock{
//
//
//    GCDQueue *queue = [[GCDQueue alloc] initConcurrent:queueName];
//    [queue queueBlock:^{
//        if (threadCodeBlock) {
//            threadCodeBlock();
//        }
//    }];
//}

+(void)ES_AsyncConcurrentOperationQueueBlock:(ThreadCodeBlock)threadCodeBlock{
    
    
    NSBlockOperation *operation = [[NSBlockOperation alloc]init];
    operation.completionBlock = ^{
        
        NSLog(@"NO MAIN：%@",[NSThread currentThread]);

        if (threadCodeBlock) {
            threadCodeBlock();
        }
    };
    [_ConcurrentQueue addOperation:operation];
   
    

}
///后台异步执行 + 主线程执行
+(void)ES_AsyncConcurrentOperationQueueBlock:(ThreadCodeBlock)threadCodeBlock
                             MainThreadBlock:(ThreadCodeBlock)mainThreadBlock{


    
    
    NSBlockOperation *operation = [[NSBlockOperation alloc]init];
    operation.completionBlock = ^{
        
        //1.异步
        NSLog(@"要更新:%@",[NSThread currentThread]);

        if (threadCodeBlock) {
            threadCodeBlock();
        }
        //2.主线程
        NSBlockOperation * mainOperation=[[NSBlockOperation alloc]init];
        [mainOperation addExecutionBlock:^{
            if (mainThreadBlock) {
                mainThreadBlock();
            }}];
        [[NSOperationQueue mainQueue]addOperation:mainOperation];
        
    };
    [_ConcurrentQueue addOperation:operation];
    
   

}
@end
