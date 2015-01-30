
#import "MessageInputView.h"
#import "UIView+JJ.h"
@interface MessageInputView () <UITextViewDelegate>
/**
 *  切换文本和语音的按钮
 */
@property (nonatomic, strong) UIButton *voiceChangeButton;

/**
 *  +号按钮
 */
@property (strong,nonatomic) UIButton *mediaButton;

/**
 *  第三方表情按钮
 */
@property (nonatomic,strong) UIButton *emojiButton;

/**
 *  语音录制按钮
 */
@property (nonatomic,strong) UIButton *holdDownButton;

/**
 *  输入文字备份
 */
@property (nonatomic, strong) NSString *message;

@end

@implementation MessageInputView
#pragma mark -更新类型
- (void)updateInputView {
    
    switch (self.messageInputViewType) {
        case MessageInputViewTypeEmoji:
            [self.messageTextView resignFirstResponder];
            
            [self.emojiButton setBackgroundImage:[UIImage imageNamed:@"keyborad"] forState:UIControlStateNormal];
            [self.mediaButton setBackgroundImage:[UIImage imageNamed:@"multiMedia"] forState:UIControlStateNormal];
            break;
        case MessageInputViewTypePlus:
            [self.messageTextView resignFirstResponder];
            
            [self.emojiButton setBackgroundImage:[UIImage imageNamed:@"face"] forState:UIControlStateNormal];
            [self.mediaButton setBackgroundImage:[UIImage imageNamed:@"keyborad"] forState:UIControlStateNormal];
            break;
        case MessageInputViewTypeText:
            [self.messageTextView becomeFirstResponder];
            
            [self.emojiButton setBackgroundImage:[UIImage imageNamed:@"face"] forState:UIControlStateNormal];
            [self.mediaButton setBackgroundImage:[UIImage imageNamed:@"multiMedia"] forState:UIControlStateNormal];
            break;
        default:
            [self.messageTextView resignFirstResponder];
            [self.emojiButton setBackgroundImage:[UIImage imageNamed:@"face"] forState:UIControlStateNormal];
            [self.mediaButton setBackgroundImage:[UIImage imageNamed:@"multiMedia"] forState:UIControlStateNormal];
            break;
    }
}
#pragma mark - 表情按钮
-(UIButton *)emojiButton{
    
    if (!_emojiButton) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        CGRect frame = CGRectMake(MESSAGE_INPUT_MARGIN,
                                  MESSAGE_INPUT_MARGIN,
                                  MESSAGE_INPUT_BUTTON_SIZE,
                                  MESSAGE_INPUT_BUTTON_SIZE);
        button.frame =frame;
        [button addTarget:self action:@selector(emojiButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = MessageInputViewTypeEmoji;
         _emojiButton = button;
    }
    return _emojiButton;

}
#pragma mark - '+'号按钮
-(UIButton *)mediaButton{
    if (!_mediaButton) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        CGRect  mediaButtonFrame = CGRectMake(CGRectGetWidth(self.bounds) - MESSAGE_INPUT_BUTTON_SIZE -   MESSAGE_INPUT_MARGIN,
                           MESSAGE_INPUT_MARGIN,
                           MESSAGE_INPUT_BUTTON_SIZE,
                           MESSAGE_INPUT_BUTTON_SIZE);
     
        button.frame =mediaButtonFrame;
        [button addTarget:self action:@selector(mediaButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = MessageInputViewTypePlus;
        _mediaButton = button;
    }
    return _mediaButton;
}
#pragma mark -输入框
-(MessageTextView *)messageTextView{

    if (!_messageTextView) {
        CGRect messageTextViewFrame =  CGRectMake(CGRectGetMaxX(self.emojiButton.frame) + MESSAGE_INPUT_MARGIN,
                                                                            MESSAGE_INPUT_MARGIN,
                                                                            CGRectGetMinX(self.mediaButton.frame) - CGRectGetMaxX(self.emojiButton.frame) - 2 * MESSAGE_INPUT_MARGIN,
                                                                            CGRectGetHeight(self.bounds) - 2 * MESSAGE_INPUT_MARGIN);
        
        MessageTextView* textView_ = [[MessageTextView alloc] initWithFrame:messageTextViewFrame];
        textView_.backgroundColor = [UIColor whiteColor];
        textView_.returnKeyType = UIReturnKeySend;
        textView_.autocorrectionType = UITextAutocorrectionTypeNo;
        textView_.font = [UIFont systemFontOfSize:16];
        textView_.delegate = self;
        textView_.placeHolder = @"输入新消息";
        _messageTextView=textView_;
        
        [self addSubview:_messageTextView];
    }
    return _messageTextView;

}
#pragma mark -按钮动作
- (void)emojiButtonAction:(UIButton*)emojiButton{
    
    if (MessageInputViewTypeEmoji == _messageInputViewType) {
        self.messageInputViewType = MessageInputViewTypeText;
    } else {
        self.messageInputViewType = MessageInputViewTypeEmoji;
    }

}
- (void)mediaButtonAction:(UIButton*)emojiButton{
    
    if (MessageInputViewTypePlus == _messageInputViewType) {
        self.messageInputViewType = MessageInputViewTypeText;
    } else {
        self.messageInputViewType = MessageInputViewTypePlus;
    }
    
}

#pragma mark - 视图
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setup];
    }
    return self;
}
- (void)setup {
    // 配置自适应
    self.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin);
    self.opaque = YES;
    // 由于继承UIImageView，所以需要这个属性设置
    self.userInteractionEnabled = YES;
    self.image = [[UIImage imageNamed:@"input-bar-flat"] resizableImageWithCapInsets:UIEdgeInsetsMake(2.0f, 0.0f, 0.0f, 0.0f)
                                                                        resizingMode:UIImageResizingModeStretch];
    
    
    //UI
    //1.表情
    [self addSubview:self.emojiButton];
    
   

    
    //2.输入框
    [self  messageTextView];

    
    //3.'+'号
    [self addSubview:self.mediaButton];
    
    // 默认设置
    [self setMessageInputViewType:MessageInputViewTypeNone];


    
}

#pragma mark -改变输入类型
- (void)setMessageInputViewType:(MessageInputViewType)messageInputViewType {
        _messageInputViewType = messageInputViewType;
        if ([self.delegate respondsToSelector:@selector(messageInputTypeChaged:)]) {
            [self.delegate messageInputTypeChaged:self];
        }
        
        [self updateInputView];
    
}
- (void)resetView {
   
    self.messageInputViewType = MessageInputViewTypeNone;
    [self.messageTextView resignFirstResponder];
}


#pragma mark -动态调整高度
- (void)adjustTextInputHeight {
    [self adjustTextInputHeightForText:self.messageTextView.text animated:YES];
}

- (void)adjustTextInputHeightForText:(NSString *)text animated:(BOOL)animated{
    CGSize textMaxSize = {self.messageTextView.frame.size.width - self.messageTextView.contentInset.left - self.messageTextView.contentInset.right - 16, 170.0f};
    
    int textHeight = [text sizeWithFont:self.messageTextView.font constrainedToSize:textMaxSize lineBreakMode:NSLineBreakByWordWrapping].height;
    CGFloat inputHeight = textHeight + self.messageTextView.contentInset.top + self.messageTextView.contentInset.bottom + 16 + 2 * MESSAGE_INPUT_MARGIN;
    
    if (abs(MESSAGE_INPUT_HEIGHT - inputHeight) < 10) {
        inputHeight = MESSAGE_INPUT_HEIGHT;
    }
    
    CGRect preFrame = self.frame;
    
    if ([text length] && inputHeight > MESSAGE_INPUT_HEIGHT) {
        CGRect frame1 = CGRectMake(0,
                                   CGRectGetMinY(self.frame) - (inputHeight - CGRectGetHeight(self.frame)),
                                   CGRectGetWidth(self.bounds),
                                   inputHeight);
        self.frame = frame1;
        self.messageTextView.height=inputHeight-10;
    } else {
        self.frame = CGRectMake(CGRectGetMinX(self.frame),
                                CGRectGetMaxY(self.frame) - MESSAGE_INPUT_HEIGHT,
                                CGRectGetWidth(self.frame),
                                MESSAGE_INPUT_HEIGHT);
        self.messageTextView.height=MESSAGE_INPUT_TEXTVIEW_HEIGHT;

    }
    
    if (!CGRectEqualToRect(preFrame, self.frame)) {
        // 输入框frame变化告知delegate, 让其进行UI设置
        if ([self.delegate respondsToSelector:@selector(messageInputTypeChaged:)]) {
            [self.delegate messageInputTypeChaged:self];
        }
    }
}

#pragma mark - Text view delegate
- (void)textViewDidBeginEditing:(UITextView*)textView {
    self.messageInputViewType=MessageInputViewTypeText;
}


- (void)textViewDidEndEditing:(UITextView*)textView {
//    if (MessageInputViewTypeText == self.messageInputViewType) {
////        [self setMessageInputViewType:MessageInputViewTypeNone];
//    }
}

- (BOOL)textView:(UITextView*)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text {
    BOOL ret = YES;
    
    
//    if (MessageInputViewTypeText != self.messageInputViewType) {
//        return NO;
//    }
    
    if ([text isEqualToString:@"\n"]) {
        //发送
        if ([self.delegate respondsToSelector:@selector(messageInputViewShouldReturn:)]) {
            [self.delegate messageInputViewShouldReturn:self];
            self.messageTextView.text = nil;
          // [self setMessageInputViewType:MessageInputViewTypeText];//FHChatInputViewUnkown];
        }
        
        return NO;
    } else if (text.length > 0) {
        [self adjustTextInputHeightForText:[NSString stringWithFormat:@"%@%@", self.messageTextView.text, text] animated:YES];
    } else {
        
        //        NSString *inputText = textView.text;
        //        if (!inputText.length) {
        //            return YES;
        //        }
        //        NSString *ls = [inputText substringWithRange:NSMakeRange(inputText.length-1, 1)];
        //        if ([ls isEqualToString:flagS]) {
        //            // 使用正则表达式查找特殊字符的位置
        //            NSArray *itemIndexes = [CBRegularExpressionManager itemIndexesWithPattern:
        //                                    EmotionItemPattern inString:inputText];
        //            if (itemIndexes.count) {
        //                NSRange range = [[itemIndexes lastObject] rangeValue];
        //                NSString *newString = [inputText replaceCharactersAtRange:range withString:@""];
        //
        //                if (newString.length == 0) {
        //                    newString = nil;
        //                }
        //                self.textView.text = newString;
        //                return NO;
        //            }
//    }
    
            NSLog(@"self.textView.text:%@",self.messageTextView.text);
            if ([self.delegate respondsToSelector:@selector(messageInputViewDidPressBackSpace:)]) {
                [self.delegate messageInputViewDidPressBackSpace:self];
                ret = NO;
            }
            ret = NO;
    }

    return ret;
}

- (void)textViewDidChange:(UITextView*)textView {
    [self adjustTextInputHeight];
}


@end
