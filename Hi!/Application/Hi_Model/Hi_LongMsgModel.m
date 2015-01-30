//
//  Hi_LongMessageModel.m
//  hihi
//
//  Created by 伍松和 on 14/12/12.
//  Copyright (c) 2014年 伍松和. All rights reserved.
//

#import "Hi_LongMsgModel.h"

@implementation Hi_LongMsgModel

-(NSString *)msg_dealed_time{
    if (self.time.length>10) {
        self.time=[self.time substringToIndex:10];
    }
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[self.time floatValue]];
    return [NSDate compareCurrentTime:confromTimesp];

}
@end
