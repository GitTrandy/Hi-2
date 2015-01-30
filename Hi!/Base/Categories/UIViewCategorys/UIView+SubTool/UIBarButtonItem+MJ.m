//
//  UIBarButtonItem+MJ.m
//  新浪微博
//
//  Created by apple on 13-10-27.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "UIBarButtonItem+MJ.h"
#import "NSObject+AssociatedObjects.h"


@implementation UIBarButtonItem (MJ)
static char UIBarButtonItemButtonKey;

-(void)setBarButton:(UIButton *)barButton{

    [self associateValue:barButton withKey:&UIBarButtonItemButtonKey];
}
-(UIButton *)barButton{

    return [self associatedValueForKey:&UIBarButtonItemButtonKey];
}


- (id)initWithTitle:(NSString *)title
            themeColor:(UIColor *)themeColor
             target:(id)target
             action:(SEL)action{

    // 创建按钮
    CGSize maxButtonSize = CGSizeMake(MAXFLOAT, 30);
    CGFloat width = [title sizeWithFont:[UIFont systemFontOfSize:17]
                      constrainedToSize:maxButtonSize
                          lineBreakMode:NSLineBreakByCharWrapping].width;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    if (title.length<=2) {
        [btn setFrame:CGRectMake(0.0f, 0.0f, width+5, 30.0f)];

    }else if(title.length==3){
        [btn setFrame:CGRectMake(0.0f, 0.0f, width+5, 30.0f)];
    }else{
        [btn setFrame:CGRectMake(0.0f, 0.0f, width+20, 30.0f)];

    }
    
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:themeColor forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];

    [btn.titleLabel setFont:[UIFont systemFontOfSize:17]];
    [btn setImage:nil forState:UIControlStateNormal];
    [btn setImage:nil forState:UIControlStateHighlighted];
    
    self.barButton=btn;
    
    return [self initWithCustomView:btn];
}
- (id)initWithIcon:(NSString *)icon highlightedIcon:(NSString *)highlighted target:(id)target action:(SEL)action
{
    // 创建按钮
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    // 设置普通背景图片
    UIImage *image = [UIImage imageNamed:icon];
    [btn setBackgroundImage:image forState:UIControlStateNormal];
    
    // 设置高亮图片
    [btn setBackgroundImage:[UIImage imageNamed:highlighted] forState:UIControlStateHighlighted];
    
    // 设置尺寸
    btn.bounds = (CGRect){CGPointZero, image.size};
   // btn.bounds = (CGRect){CGPointZero, CGSizeMake(30, 30)};
    btn.imageView.contentMode=UIViewContentModeScaleAspectFit;

    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return [self initWithCustomView:btn];
}

+ (id)itemWithIcon:(NSString *)icon highlightedIcon:(NSString *)highlighted target:(id)target action:(SEL)action
{
    return [[self alloc] initWithIcon:icon highlightedIcon:highlighted target:target action:action];
}
+ (id)itemWithTitle:(NSString *)title
         themeColor:(UIColor *)themeColor
             target:(id)target
             action:(SEL)action{

    return [[self alloc]initWithTitle:title themeColor:themeColor target:target action:action];
}

@end
