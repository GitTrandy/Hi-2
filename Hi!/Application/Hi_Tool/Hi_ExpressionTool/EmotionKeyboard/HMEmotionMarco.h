//
//  HMEmotionMarco.h
//  hihi
//
//  Created by 伍松和 on 15/1/11.
//  Copyright (c) 2015年 伍松和. All rights reserved.
//

#ifndef hihi_HMEmotionMarco_h
#define hihi_HMEmotionMarco_h

/** 表情相关 */
// 表情的最大行数
#define HMEmotionMaxRows 3
// 表情的最大列数
#define HMEmotionMaxCols 7
// 每页最多显示多少个表情
#define HMEmotionMaxCountPerPage (HMEmotionMaxRows * HMEmotionMaxCols - 1)

// 通知
// 表情选中的通知
#define HMEmotionDidSelectedNotification @"HMEmotionDidSelectedNotification"
// 点击删除按钮的通知
#define HMEmotionDidDeletedNotification @"HMEmotionDidDeletedNotification"
// 通知里面取出表情用的key
#define HMSelectedEmotion @"HMSelectedEmotion"

#import "UIView+Extension.h"
#import "UIImage+JJ.h"
#endif
