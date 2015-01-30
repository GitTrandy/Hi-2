//
//  BaseSettingItem.m
//  易商
//
//  Created by namebryant on 14-10-6.
//  Copyright (c) 2014年 Ruifeng. All rights reserved.
//

#import "BaseSettingItem.h"

@implementation BaseSettingItem
#pragma mark -设置输入框
+ (instancetype)itemWithIcon:(NSString *)icon
                       title:(NSString *)title
                keyboardType:(UIKeyboardType)keyboardType
                 placeholder:(NSString*)placeholder
                    isSecure:(BOOL)isSecure
            isFirstResponser:(BOOL)isFirstResponser
                      option:(BaseSettingItemTextDidChangeOption)baseSettingItemTextDidChangeOption{

    BaseSettingItem *item = [self item];
    item.icon = icon;
    item.title = title;
    item.keyBoardType=keyboardType;
    item.placeholder=placeholder;
    item.secure=isSecure;
    item.firstResponser=isFirstResponser;
    item.settingItemSytle=BaseSettingItemSytleTextField;
    item.baseSettingItemTextDidChangeOption=baseSettingItemTextDidChangeOption;
    return item;
}


/**
 *  设置有开关,打勾的cell
 isOption(yes/no)
 */
+ (instancetype)itemWithIcon:(NSString *)icon
                       title:(NSString *)title
                    subTitle:(NSString*)subTitle
                    isOption:(BOOL)isOption
            settingItemSytle:(BaseSettingItemSytle)settingItemSytle
                      option:(BaseSettingItemOption)option{

    BaseSettingItem *item = [self item];
    item.icon = icon;
    item.title = title;
    item.subtitle=subTitle;
    item.checked=isOption;
    item.on=isOption;
    item.settingItemSytle=settingItemSytle;
    item.option=option;//点击开关，打勾
    return item;
    
}


///有其他视图的,如小红点,图片,其他
+ (instancetype)itemWithIcon:(NSString *)icon
                       title:(NSString *)title
                    subTitle:(NSString*)subTitle
                   otherView:(UIView*)otherView
            settingItemSytle:(BaseSettingItemSytle)settingItemSytle
                      option:(BaseSettingItemOption)option{


    BaseSettingItem *item = [self item];
    item.icon = icon;
    item.title = title;
    item.subtitle=subTitle;
    item.otherView=otherView;
    item.settingItemSytle=settingItemSytle;
    item.option=option;//点击开关，打勾
    return item;
}

/**
 *  有图片有文字,子标题
 */
+ (instancetype)itemWithIcon:(NSString *)icon
                       title:(NSString *)title
                    subTitle:(NSString*)subTitle
            settingItemSytle:(BaseSettingItemSytle)settingItemSytle
                      option:(BaseSettingItemOption)option{
    
    return [self itemWithIcon:icon title:title subTitle:subTitle avatorImage:nil settingItemSytle:settingItemSytle option:option];
}



//类型微信头像
+ (instancetype)itemWithTitle:(NSString *)title
                  avatorImage:(UIImage*)avatorImage
                       option:(BaseSettingItemOption)option{
    
    return [self itemWithIcon:nil title:title subTitle:nil avatorImage:avatorImage settingItemSytle:BaseSettingItemSytleAvator option:option];
    
}

#pragma mark -私有函数
+ (instancetype)itemWithIcon:(NSString *)icon
                       title:(NSString *)title
                    subTitle:(NSString*)subTitle
                 avatorImage:(UIImage*)avatorImage
            settingItemSytle:(BaseSettingItemSytle)settingItemSytle
                      option:(BaseSettingItemOption)option{
    

    BaseSettingItem *item = [self item];
    item.icon = icon;
    item.title = title;
    item.subtitle=subTitle;
    item.avatorImage=avatorImage;
    item.settingItemSytle=settingItemSytle;
    item.option=option;
    return item;
}
+ (instancetype)item
{
    return [[self alloc] init];
}
-(void)dealloc{

    self.baseSettingItemTextDidChangeOption=nil;
    self.option=nil;
    

}
@end
