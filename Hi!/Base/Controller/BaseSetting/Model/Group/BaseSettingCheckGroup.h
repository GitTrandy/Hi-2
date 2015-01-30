//
//  BaseSettingCheckGroup.h
//  易商
//
//  Created by namebryant on 14-10-6.
//  Copyright (c) 2014年 Ruifeng. All rights reserved.
//

#import "BaseSettingGroup.h"
@class BaseSettingItem;
/**
 *  打勾的组
 */
@interface BaseSettingCheckGroup : BaseSettingGroup
/**
 *  选中的索引
 */
@property (assign, nonatomic) int checkedIndex;

/**
 *  选中的item
 */
@property (strong, nonatomic) BaseSettingItem *checkedItem;

/**
 *  来源于哪个item
 */
@property (strong, nonatomic) BaseSettingItem *sourceItem;
@end
