//
//  Hi_LongMessageModel.h
//  hihi
//
//  Created by 伍松和 on 14/12/12.
//  Copyright (c) 2014年 伍松和. All rights reserved.
//

#import "Hi_BaseModel.h"

@interface Hi_LongMsgModel : Hi_BaseModel


@property (nonatomic, assign)NSInteger ID;
@property (nonatomic, copy) NSString *bid;
@property (nonatomic, copy) NSString *mid;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, assign)NSInteger favourNum;
@property (nonatomic, copy) NSString *head;
@property (nonatomic, copy) NSString *img;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *wifiMac;

//@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign)NSInteger isLike;//默认不like

@property (nonatomic, copy)NSString * msg_dealed_time;



@end
