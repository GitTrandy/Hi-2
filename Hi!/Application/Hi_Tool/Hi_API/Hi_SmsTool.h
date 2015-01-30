//
//  MMSmsTool.h
//  Meimei
//
//  Created by namebryant on 14-7-27.
//  Copyright (c) 2014年 Meimei. All rights reserved.
//

#import "Hi_API_CLASS.h"
#import "Hi_SmsTool.h"


@interface Hi_SmsTool : NSObject

+(void)getSMSTimeWith:(NSString*)timestamp
               WithID:(NSInteger)ID
            success:(HttpSuccessBlock)success
             failure:(HttpFailureBlock)failure;


#pragma mark -用户间的对话
+(void)getUserSMS:(NSString*)sendID
         TimeWith:(NSString*)timestamp
           WithID:(NSInteger)ID
          success:(HttpSuccessBlock)success
          failure:(HttpFailureBlock)failure;





+(void)addFriendDidArrived:(NSString*)uid;


@end
