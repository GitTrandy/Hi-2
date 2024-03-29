//
//  HMEmotionTool.m
//  黑马微博
//
//  Created by apple on 14-7-17.
//  Copyright (c) 2014年 heima. All rights reserved.
//
#define HMRecentFilepath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"recent_emotions.data"]

#import "HMEmotionTool.h"
#import "HMEmotion.h"
#import "MJExtension.h"

@implementation HMEmotionTool

/** 默认表情 */
static NSArray *_defaultEmotions;
/** emoji表情 */
static NSArray *_emojiEmotions;
/** 浪小花表情 */
static NSArray *_lxhEmotions;

/** 最近表情 */
static NSMutableArray *_recentEmotions;

+ (NSArray *)defaultEmotions
{
    if (!_defaultEmotions) {
        NSString *plist = [[NSBundle mainBundle] pathForResource:@"sina_emoji_info.plist" ofType:nil];
        _defaultEmotions = [HMEmotion objectArrayWithFile:plist];
        [_defaultEmotions makeObjectsPerformSelector:@selector(setDirectory:) withObject:@"sina_emoji_info"];
    }
    return _defaultEmotions;
}

+ (NSArray *)emojiEmotions
{
    if (!_emojiEmotions) {
        NSString *plist = [[NSBundle mainBundle] pathForResource:@"emoji_info.plist" ofType:nil];
        _emojiEmotions = [HMEmotion objectArrayWithFile:plist];
        [_emojiEmotions makeObjectsPerformSelector:@selector(setDirectory:) withObject:@"emoji_info"];
    }
    return _emojiEmotions;
}

//+ (NSArray *)lxhEmotions
//{
//    if (!_lxhEmotions) {
//        NSString *plist = [[NSBundle mainBundle] pathForResource:@"EmotionIcons/lxh/info.plist" ofType:nil];
//        _lxhEmotions = [HMEmotion objectArrayWithFile:plist];
//        [_lxhEmotions makeObjectsPerformSelector:@selector(setDirectory:) withObject:@"EmotionIcons/lxh"];
//    }
//    return _lxhEmotions;
//}

+ (NSArray *)recentEmotions
{
    if (!_recentEmotions) {
        // 去沙盒中加载最近使用的表情数据
        _recentEmotions = [NSKeyedUnarchiver unarchiveObjectWithFile:HMRecentFilepath];
        if (!_recentEmotions) { // 沙盒中没有任何数据
            _recentEmotions = [NSMutableArray array];
        }
    }
    return _recentEmotions;
}

// Emotion -- 戴口罩 -- Emoji的plist里面加载的表情
+ (void)addRecentEmotion:(HMEmotion *)emotion
{
    // 加载最近的表情数据
    [self recentEmotions];
    
    // 删除之前的表情
    [_recentEmotions removeObject:emotion];
    
    // 添加最新的表情
    [_recentEmotions insertObject:emotion atIndex:0];
    
    // 存储到沙盒中
    [NSKeyedArchiver archiveRootObject:_recentEmotions toFile:HMRecentFilepath];
}
@end
