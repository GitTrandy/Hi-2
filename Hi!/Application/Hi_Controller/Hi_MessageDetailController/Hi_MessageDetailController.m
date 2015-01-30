
#import "Hi_MessageDetailController.h"
#import "Hi_TableViewChatCell.h"

#import "Hi_SmsTool.h"
#import "Hi_UserTool.h"
#import "Hi_AccountTool.h"
#import "Hi_SessionTool.h"
#import "Hi_SMSModel.h"


#import "MJPhotoBrowser.h"
#import "PhotoPickerTool.h"

///查询与对方对话的最新10条记录,时间倒序
#define HI_MESSGAE_LIST_CONDITION(UID) [NSString stringWithFormat:@"SELECT * FROM (SELECT * FROM Hi_SMSModel WHERE %@ =  '%@' ORDER BY %@ desc LIMIT 10)ORDER BY %@",U_UID,UID,TIMESTAMP,TIMESTAMP]
#define HI_MESSGAE_LIST_LESS_TIME_CONDITION(UID,LAST_TIMESTAMP) [NSString stringWithFormat:@"SELECT * FROM (SELECT * FROM Hi_SMSModel WHERE %@ =  '%@' AND %@ < %lld ORDER BY %@ desc LIMIT 10)ORDER BY %@",U_UID,UID,TIMESTAMP,LAST_TIMESTAMP,TIMESTAMP,TIMESTAMP]

///查询最后三条,属于用户本身的数据
#define HI_MESSGAE_LIST_WITHIN_MINE_CONDITION(UID,MY_ID,NUM) [NSString stringWithFormat:@"SELECT * FROM\
(SELECT * FROM Hi_SMSModel WHERE %@ =  '%@' AND status = 1  ORDER BY %@ desc LIMIT %d )\
WHERE %@ =  '%@' ORDER BY timestamp",FROM_PEER_ID,UID,TIMESTAMP,(int)NUM,FROM_PEER_ID,MY_ID]


/*
 
 
 */
///返回 YES 即使可以继续对话,NO 就是不可以
#define TOTAL_NUM  3
@interface Hi_MessageDetailController()<XHShareMenuViewDelegate,HMEmotionKeyboardDelegate> {

    NSMutableArray* _msgs;///临时数组
    BOOL isLoadingMsg;
    int64_t last_timestamp;

}
@property (nonatomic,strong)Hi_Account *account;
@property (nonatomic,strong)UIRefreshControl *refreshControl;
///被发送的模型
@property (nonatomic,strong)Hi_SMSModel * sendSmsModel;
@property (nonatomic,strong)Hi_SessionTool * sessionTool;

//UID
@property (nonatomic,strong)NSString * uid;
@property (nonatomic,strong)UIImage * smsImage;

@end

@implementation Hi_MessageDetailController

#pragma mark -清除未读
#define UID
-(void)clearUnread{
    
    if (self.messageArray.count>0) {
        [Hi_SMSModel hi_clearWithUnreadMessageNum:self.uid];
    }
    
}
#pragma mark -视图启动
#define HI_CHAT_CELL_ID @"chatcellID"
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self mediaKeyboardViewDidSetup];
//    self.messageEmotionView.emoji_delegate=self;

    
    self.uid=self.userModel.uid;
//    [self loadLocalData];
    
    
    
    UINib *rowCellNib = [UINib nibWithNibName:@"Hi_TableViewChatCell" bundle:nil];
    [self.messageTableView registerNib:rowCellNib forCellReuseIdentifier:HI_CHAT_CELL_ID];
    
    //1.
    //2.
    _sessionTool = [Hi_SessionTool sharedInstance];
    [_sessionTool watchPeerId:_uid];
    
    //3.数组
    self.account = [Hi_AccountTool getCurrentAccount];
    [self loadLocalData];
    
    //4
    
//    [NSException raise:@"Invalid foo value" format:@"foo of %@ is invalid", self];
    
}
#pragma mark -接受丢包数据
//static  NSIndexPath * indexPath=nil;
-(void)messageUpdated:(NSNotification*)notification{
    
    
    //0.查询新信息的时间
    Hi_SMSModel * smsModel =(Hi_SMSModel*)notification.object;
    
    if ([smsModel.u_uid isEqualToString:self.userModel.uid]) {
        if (smsModel.status==MsgStatusSendReceived) {
            [self adjustUIDidAppendMessage:smsModel];

        }else{
            //发送成功
//            [self addMessage:smsModel];

            [self.messageArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                
                if ([[obj objectId] isEqualToString:smsModel.objectId]) {
                    [self.messageArray replaceObjectAtIndex:idx withObject:smsModel];
                     [self.messageTableView reloadData];
                        *stop=YES;
                }
                //

            }];
            
        }

    }
    [super messageUpdated:notification];



}
-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [self clearUnread];
    
    //2.实时更新当前控制器
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    SAVE_USER_CURRENT_CTRL(@"");

    
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    //2.实时更新当前控制器
    
    [self clearUnread];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadLocalData) name:NOTIFICATION_MESSAGE_UPDATED object:nil];
    

    //3.视图
    SAVE_USER_CURRENT_CTRL(NSStringFromClass(self.class));
   
}

#pragma mark - 加载本地数据
-(void)loadLocalData{

    NSString * condition = HI_MESSGAE_LIST_CONDITION(self.userModel.uid);
    NSMutableArray * arrayM = [[Hi_SMSModel getUsingLKDBHelper]searchWithSQL:condition toClass:[Hi_SMSModel class]];
    if (arrayM.count>0) {
        self.messageArray=arrayM;
        [self.messageTableView reloadData];
        [self.messageTableView scrollToBottomAnimated:NO];
        if (arrayM.count>=10) {
            WEAKSELF;
            [self.messageTableView addHeaderWithCallback:^{
                [weakSelf loadMoreData];
            }];
        }
    }
}

#pragma mark -游戏规则,控制在三句话

-(BOOL)is_msg_be_talk{
    
    NSString * condition_last_3 = HI_MESSGAE_LIST_WITHIN_MINE_CONDITION(self.uid, MY_UID, TOTAL_NUM);
    NSArray * arrayLast_3 =[[Hi_BaseModel getUsingLKDBHelper]searchWithSQL:condition_last_3 toClass:[Hi_SMSModel class]];
    NSString * msg_tip =@"勇敢上去搭讪TA吧";
    switch (TOTAL_NUM-arrayLast_3.count) {
        case 0:
            msg_tip=@"等TA回复就可以继续了";
            break;
        default:
            msg_tip=[NSString stringWithFormat:@"你剩下%d句话,加油",TOTAL_NUM-(int)arrayLast_3.count];
            break;
    }
    
    self.messageInputView.messageTextView.placeHolder=msg_tip;
    return (arrayLast_3.count<TOTAL_NUM);
}



#pragma mark -CELL
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{return self.messageArray.count;}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    Hi_TableViewChatCell *cell =(Hi_TableViewChatCell *) [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.cellHeight;
  
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * cellID =HI_CHAT_CELL_ID;
    // [UITableViewCell configureCellWithClass:[Hi_TableViewChatCell class] WithCellID:cellID WithTableView:tableView];
    Hi_TableViewChatCell * cell  =(Hi_TableViewChatCell * )[tableView dequeueReusableCellWithIdentifier:cellID];    
    Hi_SMSModel * smsModel=self.messageArray[indexPath.row];
    cell.userModel=self.userModel;

    cell.smsModel=smsModel;
    
    //动作
    [cell addActionImageViewBlock:^(id result) {
        if (result) {
            // 2.显示相册
            MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
            NSMutableArray * photos=[NSMutableArray array];
            MJPhoto *photo = [[MJPhoto alloc] init];
            //                photo.url = [NSURL URLWithString:array[i]];
            photo.srcImageView = result; // 来源于哪个UIImageView
            [photos addObject:photo];
            browser.photos = photos; // 设置所有的图片
            [browser show];
        }
    }];
    
    //长按动作
    [cell addActionMsgLabelBlock:^(id result) {
        if (result) {
//            [self showResetMenu:result];
        }
    }];
    
    return cell;
    
}



//-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{return NO;}
//-(void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath{}
#pragma mark - Messages view delegate
-(void)messageInputViewShouldReturn:(MessageInputView *)messageInputView{
    
    if (messageInputView.messageTextView.text.length==0) {
        return;
    }
    Hi_SMSModel * smsModel = [Hi_SMSModel createMsgWithType:messageInputView.messageInputViewType-1
                                                      image:nil
                                                   objectId:nil
                                                    content:messageInputView.messageTextView.text
                                                   toPeerId:self.userModel.uid
                                                     toName:self.userModel.nickName
                                                     toHead:self.userModel.head
                                                      group:nil];
    [self adjustUIDidAppendMessage:smsModel];
    
    [super messageInputViewShouldReturn:messageInputView];

    
    [[Hi_SessionTool sharedInstance]sendMessage:smsModel];
    
}
-(void)adjustUIDidAppendMessage:(id)message{
    
    if (message) {
        Hi_SMSModel * smsModel =message;
        [super adjustUIDidAppendMessage:smsModel];
    }
    

}


#pragma mark -SMSDetailModel消息插入




#pragma mark -视图周期
-(UIRefreshControl *)refreshControl{
    
    if (!_refreshControl) {
        _refreshControl = [[UIRefreshControl alloc] initWithFrame:CGRectMake(0.0f, 0.0f, ScreenWidth, 50.0f)];
        _refreshControl.tintColor = [UIColor orangeColor];
        self.refreshControl.backgroundColor = [UIColor whiteColor];
        [_refreshControl addTarget:self action:@selector(loadMoreData) forControlEvents:UIControlEventValueChanged];
    }
    return _refreshControl;
    
}
-(void)loadMoreData{

    Hi_SMSModel * firstSms = [self.messageArray firstObject];
    last_timestamp= firstSms.timestamp;
    NSString * condition = HI_MESSGAE_LIST_LESS_TIME_CONDITION(self.userModel.uid,last_timestamp);
    NSMutableArray * arrayMB = [[Hi_SMSModel getUsingLKDBHelper]searchWithSQL:condition toClass:[Hi_SMSModel class]];
    if (arrayMB.count>0) {
        
        NSIndexSet * set = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, arrayMB.count)];
        [self.messageArray insertObjects:arrayMB atIndexes:set];
        [self.messageTableView reloadData];
        [self.messageTableView headerEndRefreshing];
//        [self scrollToBottomAnimated:NO];
        
    }else{
    
        [self.messageTableView headerEndRefreshing];

//        [self.refreshControl removeFromSuperview];
        UIWINDOW_FAILURE(@"没有更多信息");
    }
    
}
#pragma mark -媒体视图
-(void)mediaKeyboardViewDidSetup{

    // 添加第三方接入数据
    NSMutableArray *shareMenuItems = [NSMutableArray array];
    NSArray *plugIcons = @[@"sharemore_pic", @"sharemore_video"];
    NSArray *plugTitle = @[@"照片", @"拍摄"];
    for (NSString *plugIcon in plugIcons) {
        XHShareMenuItem *shareMenuItem = [[XHShareMenuItem alloc] initWithNormalIconImage:[UIImage imageNamed:plugIcon] title:[plugTitle objectAtIndex:[plugIcons indexOfObject:plugIcon]]];
        [shareMenuItems addObject:shareMenuItem];
        
        
    }
    
     self.messageMediaKeyboardView.shareMenuItems = shareMenuItems;
    self.messageMediaKeyboardView.share_delegate=self;
    self.messageEmotionView.emoji_delegate=self;
    [self.messageMediaKeyboardView reloadData];
}

- (void)didSelecteShareMenuItem:(XHShareMenuItem *)shareMenuItem atIndex:(NSInteger)index{

    if (index>2) {
        return;
    }
    [[PhotoPickerTool sharedPhotoPickerTool]showOnPickerViewControllerSourceType:index onViewController:self compled:^(UIImage *image, NSDictionary *editingInfo) {
        Hi_SMSModel * smsModel = [Hi_SMSModel createMsgWithType:self.messageInputView.messageInputViewType-1
                                                          image:image
                                                       objectId:nil
                                                        content:self.messageInputView.messageTextView.text
                                                       toPeerId:self.userModel.uid
                                                         toName:self.userModel.nickName
                                                         toHead:self.userModel.head
                                                          group:nil];
        
        [self adjustUIDidAppendMessage:smsModel];
        
        [[Hi_SessionTool sharedInstance]sendMessage:smsModel];

        
        [super messageInputViewShouldReturn:self.messageInputView];
    }];
    
    
}
-(void)HMEmotionKeyboardDidSend:(id)result{
    
    [self messageInputViewShouldReturn:self.messageInputView];
}

 
@end
