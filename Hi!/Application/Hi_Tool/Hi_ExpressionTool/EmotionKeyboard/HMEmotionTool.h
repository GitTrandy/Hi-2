//
//  HMEmotionTool.h
//  黑马微博
//
//  Created by apple on 14-7-17.
//  Copyright (c) 2014年 heima. All rights reserved.
//  管理表情数据：加载表情数据、存储表情使用记录

#import <Foundation/Foundation.h>
/** 表情相关 */
// 表情的最大行数
#define HMEmotionMaxRows 3
// 表情的最大列数
#define HMEmotionMaxCols 7
// 每页最多显示多少个表情
#define HMEmotionMaxCountPerPage (HMEmotionMaxRows * HMEmotionMaxCols - 1)
@class HMEmotion;

@interface HMEmotionTool : NSObject
/**
 *  默认表情
 */
+ (NSArray *)defaultEmotions;
/**
 *  emoji表情
 */
+ (NSArray *)emojiEmotions;
/**
 *  浪小花表情
 */
+ (NSArray *)lxhEmotions;
/**
 *  最近表情
 */
+ (NSArray *)recentEmotions;

/**
 *  保存最近使用的表情
 */
+ (void)addRecentEmotion:(HMEmotion *)emotion;
@end
