//
//  MessageKeyboardView.m
//  hihi
//
//  Created by 伍松和 on 15/1/16.
//  Copyright (c) 2015年 伍松和. All rights reserved.
//

#import "MessageKeyboardView.h"
#define UIViewParentController(__view) ({ \
UIResponder *__responder = __view; \
while ([__responder isKindOfClass:[UIView class]]) \
__responder = [__responder nextResponder]; \
(UIViewController *)__responder; \
})
@implementation MessageKeyboardView

@synthesize delegate = delegate_;
@synthesize keyboardVisible = keyboardVisible_;
@synthesize controller = controller_;

- (id)initWithFrame:(CGRect)frame

{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        keyboardVisible_ = NO;
//        controller_ = UIViewParentController(self.superview);
//        controller_.view.backgroundColor = [UIColor lightGrayColor];
    }
    return self;
}
- (UIView *)rootView{
    return controller_.view;
}
#pragma mark -展示键盘
- (void)showKeyBoardView{
    if (keyboardVisible_) {
        return;
    }
    self.keyboardVisible = YES;
    
    UIView *rootView = [self rootView];
    [rootView addSubview:self];
    
    self.hidden = NO;
    CGRect frame = CGRectMake(0,
                              CGRectGetMaxY(rootView.bounds),
                              CGRectGetWidth(self.frame),
                              CGRectGetHeight(self.frame));
    
    self.frame = frame;
    
    CGFloat duration = 0.2;
    NSInteger animation = 7;
    animation= [self RDRAnimationOptionsForCurve:animation];

    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:[NSValue valueWithCGRect:frame] forKey:UIKeyboardFrameEndUserInfoKey];
    
    
    frame = CGRectMake(0,
                       CGRectGetMaxY(rootView.bounds) - CGRectGetHeight(self.bounds),
                       CGRectGetWidth(self.frame),
                       CGRectGetHeight(self.frame));
    
    [info setObject:@(duration) forKey:UIKeyboardAnimationDurationUserInfoKey];
    [info setObject:@(animation) forKey:UIKeyboardAnimationCurveUserInfoKey];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:UIKeyboardWillShowNotification
                                                        object:self
                                                      userInfo:info];
    [UIView animateWithDuration:duration
                          delay:0
                        options:animation
                     animations:^{
                         self.frame = frame;
                         [rootView bringSubviewToFront:self];
                         
                     }completion:^(BOOL finished){
                         [[NSNotificationCenter defaultCenter] postNotificationName:UIKeyboardDidShowNotification
                                                                             object:self
                                                                           userInfo:info];
                     }];
    
}
#pragma mark -隐藏键盘
- (void)dismissKeyBoardView {
    if (!keyboardVisible_) {
        return;
    }
    
    self.keyboardVisible = NO;
    
    UIView *rootView = [self rootView];
    
    CGRect frame = CGRectMake(0,
                              CGRectGetMaxY(rootView.bounds),
                              CGRectGetWidth(self.frame),
                              CGRectGetHeight(self.frame));
    
    CGFloat duration = 0.2;
    NSInteger animation = 7;
    animation= [self RDRAnimationOptionsForCurve:animation];

    
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:[NSValue valueWithCGRect:self.frame] forKey:UIKeyboardFrameBeginUserInfoKey];
    [info setObject:[NSValue valueWithCGRect:frame] forKey:UIKeyboardFrameEndUserInfoKey];
    [info setObject:@(duration) forKey:UIKeyboardAnimationDurationUserInfoKey];
    [info setObject:@(animation) forKey:UIKeyboardAnimationCurveUserInfoKey];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:UIKeyboardWillHideNotification
                                                        object:self
                                                      userInfo:info];
    
    
    

    
    [UIView animateWithDuration:duration
                          delay:0
                        options:animation
                     animations:^{
                         self.frame = frame;
                     }
                     completion:^(BOOL finished){
                         self.hidden = YES;
                         [self removeFromSuperview];
                         [[NSNotificationCenter defaultCenter] postNotificationName:UIKeyboardDidHideNotification
                                                                             object:self
                                                                           userInfo:info];
                     }];
}

-(UIViewAnimationOptions)RDRAnimationOptionsForCurve:(UIViewAnimationCurve)curve{
    
    return (curve << 16 | UIViewAnimationOptionBeginFromCurrentState);
    
}

@end
