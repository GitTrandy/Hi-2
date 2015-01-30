//
//  Hi_BaseModel.h
//  Hi!
//
//  Created by 伍松和 on 14/11/27.
//  Copyright (c) 2014年 伍松和. All rights reserved.
//

#import "BaseModel.h"
#import "CategoryMarco.h"
#import "MJExtension.h"
#import "UIImageView+WebCache.h"
#import "Hi_ThreadTool.h"
#import "NSObject+DBCatefgory.h"

typedef void(^Hi_ArrayBlock)(id results);

@interface Hi_BaseModel : BaseModel

-(instancetype)initWithDictionary:(NSDictionary*)dict;
@end
