//
//  Hi_TextComposeViewController.h
//  hihi
//
//  Created by 伍松和 on 14/12/10.
//  Copyright (c) 2014年 伍松和. All rights reserved.
//

#import "Hi_BaseViewController.h"
#import "Hi_SettingTableController.h"

typedef NS_ENUM(NSInteger, Hi_TextComposeState) {

    Hi_TextComposeStateLiveMessage,//现场留言
    Hi_TextComposeStateChangeState,//改状态

};
@interface Hi_TextComposeViewController : BaseSettingTableController
@property (nonatomic,assign)Hi_TextComposeState textComposeState;
-(instancetype)initWithState:(Hi_TextComposeState)textComposeState;
@end
