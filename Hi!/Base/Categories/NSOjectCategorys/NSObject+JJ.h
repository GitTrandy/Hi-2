//
//  NSObject+JJ.h
//  易商
//
//  Created by 伍松和 on 14/10/23.
//  Copyright (c) 2014年 Ruifeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (JJ)
//perform block1 in main thread,when finished perform block2 in background
+(void)perform:(void(^)())block1 withCompletionHandler:(void (^)())block2;
-(void)perform:(void(^)())block1 withCompletionHandler:(void (^)())block2;


//use JJObject to deliver param(retain)
-(void)setJJObject:(id)obj;
-(id)getJJObject;



//默认block回调 key:zxDefaultEventHandler
-(void)handlerDefaultEventWithBlock:(id)block;
-(id)blockForDefaultEvent;

//设置一个block作为回调
-(void)handlerEventWithBlock:(id)block withIdentifier:(NSString *)identifier;
-(id)blockForEventWithIdentifier:(NSString *)identifier;

//send object
//handle block with default identifier is @"ZXObjectSingleObjectDictionary".
-(void)receiveObject:(void(^)(id object))sendObject;
-(void)sendObject:(id)object;

//tag can't be nil
-(void)receiveObject:(void(^)(id object))sendObject withIdentifier:(NSString *)identifier;
-(void)sendObject:(id)object withIdentifier:(NSString *)identifier;



//给UITableViewCell的数据存储计算过的行高的，防止重复计算
//类似于setZXObject,不过这个意义更明确
//-(float)JJRowHeight;
//-(void)setJJRowHeight:(float)height;


#pragma mark -把数组逆转
+(NSMutableArray*)reverseArray:(NSMutableArray*)arrayM;
@end
