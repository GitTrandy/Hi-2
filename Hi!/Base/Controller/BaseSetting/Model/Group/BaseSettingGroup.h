//
//  BaseSettingGroup.h
//  易商
//
//  Created by namebryant on 14-10-6.
//  Copyright (c) 2014年 Ruifeng. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  封装group的模型
 1.头部
 2.尾部
 3.items=多个SettingItems
 */
@interface BaseSettingGroup : NSObject
@property (copy, nonatomic) NSString *header;
@property (copy, nonatomic) NSString *footer;
@property (strong, nonatomic) NSArray *items;
@property (strong, nonatomic) UIView *footerView;
@property (strong, nonatomic) UIView *headerView;
+ (instancetype)group;
@end
