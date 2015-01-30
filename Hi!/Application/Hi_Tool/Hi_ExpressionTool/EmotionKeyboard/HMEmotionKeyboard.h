//
//  HMEmotionKeyboard.h
//  黑马微博
//
//  Created by apple on 14-7-15.
//  Copyright (c) 2014年 heima. All rights reserved.
//  表情键盘

#import <UIKit/UIKit.h>
#import "MessageKeyboardView.h"
@protocol HMEmotionKeyboardDelegate <NSObject>

-(void)HMEmotionKeyboardDidSend:(id)result;

@end
// 通知
// 表情选中的通知
#define HMEmotionDidSelectedNotification @"HMEmotionDidSelectedNotification"
// 点击删除按钮的通知
#define HMEmotionDidDeletedNotification @"HMEmotionDidDeletedNotification"
// 通知里面取出表情用的key
#define HMSelectedEmotion @"HMSelectedEmotion"
@interface HMEmotionKeyboard : MessageKeyboardView
@property (weak,nonatomic)id<HMEmotionKeyboardDelegate>emoji_delegate;
+ (instancetype)keyboard;
@end
