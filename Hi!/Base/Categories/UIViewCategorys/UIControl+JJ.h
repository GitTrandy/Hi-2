//
//  UIControl+JJ.h
//  易商
//
//  Created by 伍松和 on 14/10/24.
//  Copyright (c) 2014年 Ruifeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIControl (JJ)
- (void)handleControlEvent:(UIControlEvents)event withBlock:(void(^)(id sender))block;
- (void)removeHandlerForEvent:(UIControlEvents)event;
@end
