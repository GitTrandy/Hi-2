
#import "MessageDisplayController.h"



#define IOS7_8 ([[[UIDevice currentDevice]systemVersion] floatValue] < 8.0)
#define IOS8 ([[[UIDevice currentDevice]systemVersion] floatValue] >= 8.0)
#define IOS7_1 ([[[UIDevice currentDevice]systemVersion] floatValue] >= 7.1)

@interface MessageDisplayController ()<
MessageInputViewDelegate,
MessageKeyboardViewDelegate
>

{
    
    CGRect m_endFrame; //键盘 Frame
    CGFloat m_duration; //键盘时间
    NSInteger m_ainimation; //键盘动画

}


@end

@implementation MessageDisplayController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //1.
    
    [self.view addSubview:self.messageTableView];
    
    //2.
    
    [self setDataAndConfig];
    
    
    //3.
    [self messageInputView];
}
-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
     //1.加入键盘通知
    [self addObserverForKeyboard];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [self removeObserverForKeyboard];

}
#pragma mark - 通知
-(void)addObserverForKeyboard{

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleKeyboardWillShowNotification:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleKeyboardWillHideNotification:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(messageUpdated:)
                                                 name:NOTIFICATION_MESSAGE_UPDATED
                                               object:nil];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(handleApplicationWillTerminateNotification:)
//                                                 name:UIApplicationWillTerminateNotification
//                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(messageEmojiDidClick:)
                                                 name:HMEmotionDidSelectedNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(messageEmojiDidDelete:)
                                                 name:HMEmotionDidDeletedNotification
                                               object:nil];

}

-(void)removeObserverForKeyboard{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_MESSAGE_UPDATED object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:HMEmotionDidSelectedNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:HMEmotionDidDeletedNotification object:nil];

//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillTerminateNotification object:nil];

}
//-(void)dealloc{[self removeObserverForKeyboard];}
#pragma mark -接受丢包数据

#pragma mark -数据/配置
-(void)setDataAndConfig{

    //1.消息初始化
    _messageArray = [NSMutableArray array];
    
    //2.
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        
        UIEdgeInsets insets = self.messageTableView.contentInset;
        insets.top = self.navigationController.navigationBar.bounds.size.height +
        [UIApplication sharedApplication].statusBarFrame.size.height;
        self.messageTableView.contentInset = insets;
        self.messageTableView.scrollIndicatorInsets = insets;
    }

}
#pragma mark -表视图
-(MessageTableView *)messageTableView{

    if (!_messageTableView) {
        MessageTableView * tableView_ = [[MessageTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        tableView_.frame = CGRectMake(0,
                                      0,
                                      CGRectGetWidth(self.view.frame),
                                      CGRectGetHeight(self.view.frame) - MESSAGE_INPUT_HEIGHT);
        tableView_.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        tableView_.dataSource = self;
        tableView_.delegate = self;
        
        _messageTableView =tableView_;
       
      
    }
    
    return _messageTableView;

}
#pragma mark - 输入工具视图
-(MessageInputView *)messageInputView{

    if (!_messageInputView) {
       MessageInputView* chatInputView_ = [[MessageInputView alloc] initWithFrame:CGRectMake(0,
                                                                           CGRectGetHeight(self.view.bounds) - MESSAGE_INPUT_HEIGHT,
                                                                           CGRectGetWidth(self.view.bounds),
                                                                           MESSAGE_INPUT_HEIGHT)];
        
        chatInputView_.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        chatInputView_.delegate = self;
        _messageInputView = chatInputView_;
        
        [self.view addSubview:_messageInputView];
    }
    return _messageInputView;

}
#pragma mark -表情视图
-(MessageEmotionKeyboardView *)messageEmotionView{

    if (!_messageEmotionView) {
       MessageEmotionKeyboardView*emotionView_ = [[MessageEmotionKeyboardView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 216)];
        emotionView_.delegate = self;
        emotionView_.controller = self;

        _messageEmotionView = emotionView_;

    }
    
    return _messageEmotionView;
}
#pragma mark -工具视图
-(MessageMediaKeyboardView *)messageMediaKeyboardView{
    if (!_messageMediaKeyboardView) {
        MessageMediaKeyboardView*medieView = [[MessageMediaKeyboardView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 216)];
        medieView.delegate = self;
        medieView.controller = self;
        medieView.backgroundColor = [UIColor whiteColor];//[UIColor colorWithPatternImage:[UIImage imageNamed:@"sharemore_app_markbg2"]];
        _messageMediaKeyboardView = medieView;

    }
    
    return _messageMediaKeyboardView;

}
#pragma mark -收发信息
- (void)messageUpdated:(NSNotification *)notification{

    [self.messageTableView reloadData];
//    [self.messageTableView  scrollBubbleViewToBottomAnimated:YES];
    if (self.messageInputView.messageInputViewType != MessageInputViewTypeNone) {
        [self adjustPosition];
        
    }
}
#pragma mark -Message-Input-View-Delegate
#pragma mark -发送信息回调
-(void)messageInputViewShouldReturn:(MessageInputView *)messageInputView{

    self.messageInputView.messageTextView.text = nil;
    [self.messageInputView adjustTextInputHeight];
    [self adjustPosition];
}
#pragma mark - 输入类型改变后的键盘处理

-(void)messageInputTypeChaged:(MessageInputView *)messageInputView{
    
    switch (messageInputView.messageInputViewType) {
        case MessageInputViewTypeEmoji:
            [[self messageMediaKeyboardView] dismissKeyBoardView];
            [[self messageEmotionView] showKeyBoardView];

            break;
        case MessageInputViewTypePlus:
            [[self messageEmotionView] dismissKeyBoardView];
            [[self messageMediaKeyboardView] showKeyBoardView];
            break;
        case MessageInputViewTypeText:
//                        [[NSNotificationCenter defaultCenter] postNotificationName:UIKeyboardWillHideNotification
//                                                                object:self
//                                                              userInfo:nil];
            [[self messageEmotionView] dismissKeyBoardView];
            [[self messageMediaKeyboardView] dismissKeyBoardView];
                break;
        default:
            [[self messageEmotionView] dismissKeyBoardView];
            [[self messageMediaKeyboardView] dismissKeyBoardView];
            break;
    }
    

}
-(void)messageInputViewFrameChanged:(MessageInputView *)messageInputView{ NSLog(@"%s", __FUNCTION__);}
#pragma mark - 删除
-(void)messageInputViewDidPressBackSpace:(MessageInputView *)messageInputView{
    [self handleBackspaceEvent];
    
}
#pragma mark -Message-KeyboardView-Delegate


- (void)keyboardViewShoudSend:(MessageKeyboardView *)keyboardView {
    [self messageInputViewFrameChanged:self.messageInputView];
}

- (void)keyboardViewDidPressBackSpace:(MessageKeyboardView *)keyboardView {
    [self handleBackspaceEvent];
}


#pragma mark - Private API
#pragma mark -调整位置
-(void)adjustPosition
{
    
  
    [UIView animateWithDuration:m_duration
                          delay:0.0
                        options:m_ainimation
                     animations:^{
                         self.messageInputView.transform = CGAffineTransformMakeTranslation(0, -CGRectGetHeight(m_endFrame));
                         
                         if (self.messageTableView.contentSize.height <= CGRectGetHeight(self.messageTableView.bounds) - MESSAGE_INPUT_HEIGHT) {
                             
                             if (self.messageTableView.contentSize.height > (CGRectGetHeight(self.messageTableView.bounds) - CGRectGetHeight(m_endFrame) - MESSAGE_INPUT_HEIGHT)) {
                                 // FIXME:DONE
                                 self.messageTableView.transform = CGAffineTransformMakeTranslation(0,
                                                                                             - self.messageTableView.contentSize.height - MESSAGE_INPUT_HEIGHT - 20 -CGRectGetHeight(m_endFrame) + CGRectGetHeight(self.messageTableView.bounds));
                                 
                             }
                             
                         } else if (self.messageTableView.contentSize.height > CGRectGetHeight(self.messageTableView.bounds)- MESSAGE_INPUT_HEIGHT){
                             self.messageTableView.transform = CGAffineTransformMakeTranslation(0,
                                                                                         - abs(CGRectGetHeight(m_endFrame)));
                         }
                         
                         [self.view bringSubviewToFront:self.messageInputView];
                     }
                     completion:NULL];
    
    [self scrollToBottomAnimated:YES];
}
#pragma mark -表视图
- (void)scrollToBottomAnimated:(BOOL)animated
{
    
    
    NSInteger rows = [self.messageTableView numberOfRowsInSection:0];
    
    if(rows > 0) {
        [self.messageTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:rows - 1 inSection:0]
                    atScrollPosition:UITableViewScrollPositionBottom
                            animated:animated];
    }
    
}
#pragma mark -键盘状态
- (void)handleKeyboardWillShowNotification:(NSNotification *)notification {
    
    

    NSDictionary *userInfo = [notification userInfo];
    m_endFrame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    m_duration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    m_ainimation = [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];

    m_ainimation= [self RDRAnimationOptionsForCurve:m_ainimation];
    
    //1.
    

    
    
    [self adjustPosition];
}

- (void)handleKeyboardWillHideNotification:(NSNotification *)notification {
    
    if ([self.messageInputView messageInputViewType] == MessageInputViewTypeText ||
        [self.messageEmotionView keyboardVisible] ||
        [self.messageMediaKeyboardView keyboardVisible]) {
        return;
    }
    
    NSDictionary *userInfo = [notification userInfo];
    CGFloat duration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    NSInteger ainimation = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] integerValue];
    ainimation= [self RDRAnimationOptionsForCurve:ainimation];

    [UIView animateWithDuration:duration
                          delay:0.0
                        options:ainimation
                     animations:^{
                         self.messageInputView.transform = CGAffineTransformIdentity;
                         self.messageTableView.transform = CGAffineTransformIdentity;
                     }
                     completion:NULL];
}
-(UIViewAnimationOptions)RDRAnimationOptionsForCurve:(UIViewAnimationCurve)curve{
    
    return (curve << 16 | UIViewAnimationOptionBeginFromCurrentState);
    
}

- (void)hideKeyboard
{
    m_endFrame = CGRectZero;
    m_duration = 0;
    m_ainimation = 0;
    
    [self.messageInputView resetView];

}

#pragma mark -UITableView_Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{return self.messageArray.count;}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{return nil;}
#pragma mark -添加后 UI 处理
-(void)adjustUIDidAppendMessage:(id)message{
    
    [self addMessage:message];
    [self.messageTableView reloadData];
    [self.messageTableView scrollToBottomAnimated:YES];
}
#pragma mark - 添加数据

-(void)addMessage:(id)message{
    
    [self.messageArray addObject:message];
    
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self hideKeyboard];
}
#pragma mark -表情点击
-(void)messageEmojiDidClick:(NSNotification*)notification{
    
    HMEmotion *emotion = notification.userInfo[HMSelectedEmotion];
    
    // 1.拼接表情
    if (emotion.emoji) {
        [self.messageInputView.messageTextView insertText:emotion.emoji];
    
    }else{
        [self.messageInputView.messageTextView insertText:emotion.chs];

    }
    
    // 2.检测文字长度
    [self.messageInputView textViewDidChange:self.messageInputView.messageTextView];

}
-(void)messageEmojiDidDelete:(NSNotification*)notification{
    
    [self handleBackspaceEvent];

}

#define EmojiRegex  @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]"
- (void)handleEmojiDelete
{

   
    NSMutableString * stringM = [NSMutableString stringWithString:self.messageInputView.messageTextView.text];
//
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:EmojiRegex options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray *array =nil;
    
    array = [regex matchesInString:stringM options:0 range:NSMakeRange(0, [stringM length])];
    if (array.count>0) {
        NSTextCheckingResult * targer = [array lastObject];
        NSRange targetRange = targer.range;
        [stringM replaceCharactersInRange:targetRange withString:@""];
        self.messageInputView.messageTextView.text=stringM;
    }else {
    
          [self.messageInputView.messageTextView deleteBackward];
    }
   
    
    
    
    
}
#pragma mark - 删除
- (void)handleBackspaceEvent {
    NSString *inputText = [[self.messageInputView messageTextView] text];
    
    if (![inputText length]) {
        return;
    }
    
    NSString *ls = [inputText substringWithRange:NSMakeRange(inputText.length-1, 1)];
    if ([ls isEqualToString:EMOJI_FLAGS]) {
        [self handleEmojiDelete];
    } else {
        [self.messageInputView.messageTextView deleteBackward];
    }
    
    // 重置输入框高度
    [self.messageInputView adjustTextInputHeight];
}

@end
