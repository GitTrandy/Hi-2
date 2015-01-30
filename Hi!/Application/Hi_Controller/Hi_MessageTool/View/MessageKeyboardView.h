

#import <UIKit/UIKit.h>
@class MessageKeyboardView;

@protocol MessageKeyboardViewDelegate <NSObject>

@optional
- (void)keyboardView:(MessageKeyboardView *)keyboardView didInputValue:(NSString *)value;

- (void)keyboardViewShoudSend:(MessageKeyboardView *)keyboardView;

- (void)keyboardViewDidPressBackSpace:(MessageKeyboardView *)keyboardView;

@end
/**
 *  处理键盘事件
 */
@interface MessageKeyboardView : UIView

@property (nonatomic, weak) id<MessageKeyboardViewDelegate> delegate;
/**
 *  键盘是否显示
 */
@property (nonatomic, assign) BOOL keyboardVisible;
/**
 *  控制器
 */
@property (nonatomic, weak) UIViewController *controller;


/**
 *  展示键盘
 */
- (void)showKeyBoardView;
/**
 *  隐藏键盘
 */
- (void)dismissKeyBoardView;
@end
