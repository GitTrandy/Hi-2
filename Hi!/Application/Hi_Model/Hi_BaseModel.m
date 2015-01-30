//
//  Hi_BaseModel.m
//  Hi!
//
//  Created by 伍松和 on 14/11/27.
//  Copyright (c) 2014年 伍松和. All rights reserved.
//

#import "Hi_BaseModel.h"

@implementation Hi_BaseModel
-(instancetype)initWithDictionary:(NSDictionary*)dict{

    if (self=[super init]) {
        [self setKeyValues:dict];
    }
    
    return self;
}

@end
