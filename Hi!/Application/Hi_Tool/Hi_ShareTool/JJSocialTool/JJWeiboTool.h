//
//  WeiboTool.h
//  Meimei
//
//  Created by namebryant on 14-7-25.
//  Copyright (c) 2014年 Meimei. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, JJShareActionType){
    
    
    JJShareActionTypeSMS =0,
    JJShareActionTypeWeChat ,
    JJShareActionTypeWeChatTimeline  ,
    JJShareActionTypeSina ,
    JJShareActionTypeQQ  ,
    JJShareActionTypeQQZone  ,
    JJShareActionTypeEmail  ,
    
    JJShareActionTypeCopy  ,
};
@interface JJWeiboTool : NSObject

@end
