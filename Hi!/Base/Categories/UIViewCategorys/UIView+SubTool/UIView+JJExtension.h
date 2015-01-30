//
//  UIView+Extension.h
//  易商
//
//  Created by namebryant on 14-9-27.
//  Copyright (c) 2014年 Ruifeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewExt.h"


@interface UIView (JJExtension)
//设置利用Mask设置圆角
- (void)setRoundedCorners:(UIRectCorner)corners radius:(CGSize)size;
//以递归的方式遍历(查找)subview





@property(weak,nonatomic)UIView * warningView;
@property(weak,nonatomic)UIView * activityOverView;


/**
 *  覆盖在视图上面,加载中....
 */
-(void)showActivityOverView:(CGRect)rect
                  WithStyle:(UIActivityIndicatorViewStyle)Style;
/**
 *  结束加载
 */
-(void)hideActivityOverView;
/**
 *  覆盖在视图上面,加载中....
 */
-(void)showWaringOverView:(NSString*)imageName
             warningTitle:(NSString*)warningTitle
                     rect:(CGRect)rect;
/**
 *  结束加载
 */
-(void)hideWaringOverView;//:(NSString*)title;
-(void)hideActivityOverView:(NSString *)originTitle;
@end
