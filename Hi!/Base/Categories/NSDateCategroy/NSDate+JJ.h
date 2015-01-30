//
//  NSDate+JJ.h
//  易商
//
//  Created by 伍松和 on 14/10/24.
//  Copyright (c) 2014年 Ruifeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (JJ)
///时间相关

///传一个时间戳跟日期格式得到正确日期字符串
+(NSString*)getRealTime:(NSString *)timestamp
             withFormat:(NSString*)format;

///传一个NSDate跟日期格式得到正确日期字符串

+(NSString*)getRealDateTime:(NSDate *)date
                 withFormat:(NSString*)format;

///根据一个Date得到一个时间戳(10位的,看需求)
+(NSString*)getTimeStampWithDate:(NSDate*)date;
//次要方法


///根据时间戳获取年月日
+(NSString*)getRealTime:(NSString *)timestamp;
///根据时间戳获取分钟秒钟
+(NSString*)getDayRealTime:(NSString *)timestamp;

+(NSDate *)dateString:(NSString *)dateString
               Format:(NSString*)format;
///根据字符串拿到Date
+(NSDate *)dateString:(NSString *)dateString;

///比较现在时间是否超越N天
+(NSString*) compareCurrentTime:(NSDate*) compareDate;

///根据月日得到星座
+(NSString *)getAstroWithMonth:(int)m day:(int)d;

///根据 NSdate 来拿到长时间戳
+(NSString*)getTimeStampLong:(NSDate*)date;
@end
