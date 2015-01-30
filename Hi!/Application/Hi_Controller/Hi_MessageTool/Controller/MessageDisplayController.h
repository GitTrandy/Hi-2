#import <UIKit/UIKit.h>
#import "MessageTableView.h"
#import "MessageKeyboardView.h"
#import "MessageInputView.h"
#import "MessageEmotionKeyboardView.h"
#import "MessageMediaKeyboardView.h"
#define NOTIFICATION_MESSAGE_UPDATED @"NOTIFICATION_MESSAGE_UPDATED" //消息更新
#define NOTIFICATION_SESSION_UPDATED @"NOTIFICATION_SESSION_UPDATED" //状态更新
#define NOTIFICATION_GROUP_UPDATED @"NOTIFICATION_GROUP_UPDATED"//群组更新
@interface MessageDisplayController : UIViewController<
UITableViewDelegate,
UITableViewDataSource>

/**
 *  消息列表
 */
@property (nonatomic,strong)MessageTableView * messageTableView;
/**
 *  消息数组
 */
@property (nonatomic,strong)NSMutableArray * messageArray;

/**
 *  输入工具视图
 */
@property (nonatomic,weak)MessageInputView * messageInputView;
/**
 *  表情视图
 */
@property (nonatomic,strong)MessageEmotionKeyboardView * messageEmotionView;
/**
 *  多媒体视图
 */

@property (nonatomic,strong)MessageMediaKeyboardView * messageMediaKeyboardView;



@property (nonatomic,assign)MessageInputViewType curInputType;
/**
 *  当发送/收到信息时候调整高度
 */
#pragma mark -调整位置
-(void)adjustPosition;
#pragma mark -发送信息回调
-(void)messageInputViewShouldReturn:(MessageInputView *)messageInputView;
#pragma mark -添加信息
-(void)adjustUIDidAppendMessage:(id)message;
#pragma mark -收发信息
- (void)messageUpdated:(NSNotification *)notification;
-(void)addMessage:(id)message;
@end
