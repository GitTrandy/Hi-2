//
//  NSObject+DBCatefgory.h
//  hihi
//
//  Created by 伍松和 on 15/1/10.
//  Copyright (c) 2015年 伍松和. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LKDBHelper.h"

/**
 *  获取数组
 */
typedef void(^DBCatefgoryArrayBlock)(id results);
/**
 *  插入后更新
 */
typedef void(^DBCatefgoryDidInsertBlock)();

@interface NSObject (DBCatefgory)

//+(LKDBHelper *)getUsingLKDBHelper;
///A.插入
+(void)insertModelToDB:(id)model
             condition:(NSString*)condition
        didInsertBlock:(DBCatefgoryDidInsertBlock)block;

///B.查询

+(NSMutableArray*)queryFormDB:(NSString*)Where
              orderBy:(NSString*)order
                count:(NSInteger)count
              success:(DBCatefgoryArrayBlock)success;


+(NSMutableArray*)queryFormDBComplexSQL:(NSString *)ComplexSQL;


///C.更新
+ (BOOL)updatePropertyName:(NSString*)propertyName
                  newProperty:(id)newProperty
                        where:(NSString*)where;
@end
