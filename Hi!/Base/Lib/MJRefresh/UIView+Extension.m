//
//  UIView+Extension.m
//  MJRefreshExample
//
//  Created by MJ Lee on 14-5-28.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "UIView+Extension.h"

@implementation UIView (Extension)
- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGSize)size
{
    return self.frame.size;
}

- (void)setOrigin:(CGPoint)origin
{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGPoint)origin
{
    return self.frame.origin;
}
- (void)setCenterX:(CGFloat)centerX
{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)centerX
{
    return self.center.x;
}

- (void)setCenterY:(CGFloat)centerY
{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)centerY
{
    return self.center.y;
}
#pragma mark -随便写的
-(void)setTitle:(NSString*)title
           size:(float)size
          color:(UIColor*)color
       duration:(NSTimeInterval)duration
          delay:(NSTimeInterval)delay{
    
    
    
    
    UIView * view= [[UIView alloc]initWithFrame:CGRectMake(0, -100, 320, 100)];
    view.backgroundColor=color;
    [self.window addSubview:view];
    
    UILabel*label = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 320, 80)];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:size];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.text=title;
    [view addSubview:label];
    
    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionTransitionFlipFromTop animations:^{
        view.y=0;
    } completion:^(BOOL finished) {
        //
        [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
            view.y=-100;
        } completion:^(BOOL finished) {
            //
        }];
    }];
    
    
}

@end
