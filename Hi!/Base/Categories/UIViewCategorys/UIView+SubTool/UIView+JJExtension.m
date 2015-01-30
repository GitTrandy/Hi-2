//
//  UIView+Extension.m
//  易商
//
//  Created by namebryant on 14-9-27.
//  Copyright (c) 2014年 Ruifeng. All rights reserved.
//

#import "UIView+JJExtension.h"
#import "UIDevice+JJ.h"
#import "NSObject+AssociatedObjects.h"

#define KActivityViewTag 20142014
#define KWarningViewTag 20132013

@implementation UIView (Extension)



- (void)setRoundedCorners:(UIRectCorner)corners radius:(CGSize)size {
    UIBezierPath* maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:size];
    CAShapeLayer* maskLayer = [CAShapeLayer new];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
    
}

#pragma mark -提示
static char kWarningViewKey;
static char kActivityOverView;

-(void)setWarningView:(UIView *)warningView{

    [self associateValue:warningView withKey:&kWarningViewKey];

}
-(UIView *)warningView{

   return [self associatedValueForKey:&kWarningViewKey];
}
-(void)setActivityOverView:(UIView *)activityOverView{
    [self associateValue:activityOverView withKey:&kActivityOverView];

    
}
-(UIView *)activityOverView{

    return [self associatedValueForKey:&kActivityOverView];
}
#pragma mark -Action
-(void)showActivityOverView:(CGRect)rect
                       WithStyle:(UIActivityIndicatorViewStyle)Style{

    if (!self.activityOverView) {
        
        
        if ([self isKindOfClass:[UIButton class]]) {
            UIButton*btn=(UIButton*)self;
            [btn setTitle:@"" forState:UIControlStateNormal];
            [btn setImage:nil forState:UIControlStateNormal];
            
        }
        //1.视图
        UIView * activityOverView=[[UIView alloc]initWithFrame:rect];
        activityOverView.backgroundColor=[UIColor clearColor];
        UIActivityIndicatorView*_activityIndicatorView = [[UIActivityIndicatorView alloc]initWithFrame: CGRectMake(0,0,24,24)];
        _activityIndicatorView.center=activityOverView.center;
        _activityIndicatorView.activityIndicatorViewStyle = Style;
        _activityIndicatorView.tag=KActivityViewTag;
        //2
        [activityOverView addSubview:_activityIndicatorView];
        [self addSubview:activityOverView];
        self.activityOverView=activityOverView;
        
    }
    
    //3.开始动画
    UIActivityIndicatorView*_activityIndicatorView =(UIActivityIndicatorView*)[self.activityOverView viewWithTag:KActivityViewTag];
    [_activityIndicatorView startAnimating];

}

-(void)hideActivityOverView:(NSString *)originTitle{

    //0.如果是 button
    if ([self isKindOfClass:[UIButton class]]) {
        UIButton*btn=(UIButton*)self;
        [btn setTitle:originTitle forState:UIControlStateNormal];
        
    }
    
    //1.
    UIActivityIndicatorView*_activityIndicatorView =(UIActivityIndicatorView*)[self.activityOverView viewWithTag:KActivityViewTag];
    [_activityIndicatorView stopAnimating];
    [_activityIndicatorView removeFromSuperview];
    _activityIndicatorView = nil;
    
    //2.
    [self.activityOverView removeFromSuperview];
    self.activityOverView = nil;
}
/**
 *  结束加载
 */
-(void)hideActivityOverView{

    [self hideActivityOverView:nil];
   

}
#pragma mark -警告动作
-(void)showWaringOverView:(NSString*)imageName
             warningTitle:(NSString*)warningTitle
                                rect:(CGRect)rect{


    if (!self.warningView) {
        UIView *waringView=[[UIView alloc]initWithFrame:rect];
        waringView.backgroundColor=self.backgroundColor;
        waringView.tag=KWarningViewTag;
        [self addSubview:waringView];
        //2.图片
        UIImageView * imgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 200, 200)];
        imgView.center=waringView.center;
        imgView.image=[UIImage imageNamed:imageName];
        [waringView addSubview:imgView];
        //3.文字
        UILabel * titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, imageName?imgView.bottom:60, ScreenWidth, 20)];
        titleLabel.textAlignment=NSTextAlignmentCenter;
        titleLabel.font=[UIFont systemFontOfSize:20];
        titleLabel.textColor=[UIColor lightGrayColor];
        titleLabel.text=warningTitle;
        [waringView addSubview:titleLabel];
        //4.赋值
        
        self.warningView=waringView;

    }
 
    
}
/**
 *  结束加载
 */
-(void)hideWaringOverView{
    [self.warningView removeFromSuperview];
    self.warningView=nil;
}
@end
