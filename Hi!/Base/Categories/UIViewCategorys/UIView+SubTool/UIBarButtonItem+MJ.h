//
//  UIBarButtonItem+MJ.h
//  新浪微博
//
//  Created by apple on 13-10-27.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface UIBarButtonItem (MJ)

@property (nonatomic,strong)UIButton *barButton;


/**
 *  用文字创建UIBarButtonItem
 */
+ (id)itemWithTitle:(NSString *)title
         themeColor:(UIColor *)themeColor
             target:(id)target
             action:(SEL)action;

/**
 *  用图片创建UIBarButtonItem
 */
+ (id)itemWithIcon:(NSString *)icon
   highlightedIcon:(NSString *)highlighted
            target:(id)target
            action:(SEL)action;


@end
