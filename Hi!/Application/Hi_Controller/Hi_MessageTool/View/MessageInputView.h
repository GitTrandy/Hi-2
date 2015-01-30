// 聊天输入界面
static NSString *EMOJI_FLAGS = @"]";
typedef NS_ENUM(NSInteger, MessageInputViewType) {
    MessageInputViewTypeNone,//就是什么都不输入
    MessageInputViewTypeText,//文本
    MessageInputViewTypeEmoji, //表情视图
    MessageInputViewTypePlus,//多功能视图等等
};
#define MESSAGE_INPUT_HEIGHT       (44.0f) ///总体高度
#define MESSAGE_INPUT_TEXTVIEW_HEIGHT  (32.0f)//输入框高度
#define MESSAGE_INPUT_MARGIN      (6.0f)//控件间距
#define MESSAGE_INPUT_BUTTON_SIZE  (32.0f) //

#import <UIKit/UIKit.h>
#import "MessageTextView.h"

@protocol MessageInputViewDelegate;
@interface MessageInputView : UIImageView<UITextViewDelegate>

@property (nonatomic, weak) id <MessageInputViewDelegate> delegate;

/**
 *  用于输入文本消息的输入框
 */
@property (nonatomic, weak) MessageTextView *messageTextView;
/**
 *  输入类型
 */
@property (assign,nonatomic)MessageInputViewType messageInputViewType;
/**
 *  动态改变高度
 *
 *  @param changeInHeight 目标变化的高度
 */
- (void)adjustTextInputHeight;

/**
 *  重置视图
 */
- (void)resetView;


@end

@protocol MessageInputViewDelegate <NSObject>
@required

/**
 *  发送信息
 */
- (void)messageInputViewShouldReturn:(MessageInputView *)messageInputView;
/**
 *  输入类型改变
 */
- (void)messageInputTypeChaged:(MessageInputView *)messageInputView;
/**
 *  删除文字
 */
- (void)messageInputViewDidPressBackSpace:(MessageInputView *)messageInputView;
/**
 *  输入视图大型位置改变
 */

- (void)messageInputViewFrameChanged:(MessageInputView *)messageInputView;
@end




