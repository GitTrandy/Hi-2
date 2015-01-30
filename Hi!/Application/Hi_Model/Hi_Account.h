//
//  Account.h
//  新浪微博
//
//  Created by apple on 13-10-30.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Hi_BaseModel.h"
@interface Hi_Account : Hi_BaseModel <NSCoding>
/*
 归档帐号,用NSCoding协议
 */


/**
 *  本地个人信息库
 */

#define AccountTIP @"未填写"

@property (nonatomic, copy)NSString *NickName;//昵称
@property (nonatomic, copy)NSString *CurrentState;//当前状态
@property (nonatomic, copy)NSString *Note;//用户标签
@property (nonatomic, copy)NSString *Jobs;//职业
@property (nonatomic, copy)NSString *location;//居住地
@property (nonatomic, copy)NSString *Sex;//用户性别
@property (nonatomic, copy)NSString *Interest;//用户兴趣爱好
@property (nonatomic, copy)NSString *accostTimes;

@property (nonatomic, copy)NSString *Birthday;//用户生日
@property (nonatomic, copy)NSString *Age;//年级
@property (nonatomic, copy)NSString *Xingzuo;//星座


@property (nonatomic, copy)NSString *Head;//头像Url地址
@property (nonatomic,strong)UIImage *image;
@property (nonatomic,strong)UIImage *image1;
@property (nonatomic,strong)UIImage *image2;
@property (nonatomic,strong)UIImage *image3;
@property (nonatomic,strong)NSArray*photos;
//隐私
@property (nonatomic,assign)BOOL isLocation;
@property (nonatomic,assign)BOOL isMessage;

//数据类的
@property (nonatomic, copy)NSString *phone;
@property (nonatomic, copy)NSString *PassWord;//密码



@property (nonatomic, copy) NSString *driveType;
@property (nonatomic, copy) NSString *openid;//密码




/**
 *  网络同步account,小属性
 *
 *  @param account account
 *  @param Type    类型
 *  @param content 内容
 */
+(void)sycnAccount:(Hi_Account*)account
              Type:(NSInteger)Type
           content:(NSString*)content;





@end