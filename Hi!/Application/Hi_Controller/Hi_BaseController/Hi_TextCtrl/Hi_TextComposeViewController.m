//
//  Hi_TextComposeViewController.m


#import "Hi_TextComposeViewController.h"
#import "Hi_PlaceholderTextView.h"
#import "Hi_BusinessTool.h"
#import "PhotoPickerTool.h"
#import "UIWindow+JJ.h"
#import "Hi_AccountTool.h"
#import "Hi_UserTool.h"

@interface Hi_TextComposeViewController ()<UITextViewDelegate>
@property (nonatomic, strong)Hi_PlaceholderTextView *textView;
@property (nonatomic, strong)UIView    * toolbar;
@property (nonatomic, strong)UIButton  * btnAddImage;
@property (nonatomic, strong)UIView    * headerView;
@property (nonatomic, strong)UIImage   * sendImage;

@end

@implementation Hi_TextComposeViewController
-(instancetype)initWithState:(Hi_TextComposeState)textComposeState{

    if (self=[super init]) {
        self.textComposeState=textComposeState;
    }
    
    return self;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addAllSubview];
    [self setupGroup1];
    
    //4
    

}
-(void)addAllSubview{
    //1.导航
    [self setupNavBar];
    
    
    self.headerView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 220)];
    self.headerView.backgroundColor =[UIColor whiteColor];
   
    //2.
    [self setupTextView];
    if (self.textComposeState==Hi_TextComposeStateLiveMessage) {
        [self setupImageView];
    }else {
        self.headerView.height-=80;
        
    }
    self.tableView.tableHeaderView=self.headerView;


    //3
      [self.textView becomeFirstResponder];
   // [self setupToolbar];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{return 5;}

-(void)setupGroup1{

    BaseSettingGroup *group = [BaseSettingGroup group];
    
    BaseSettingItem *item1 =  [BaseSettingItem itemWithIcon:nil title:@"选项"  subTitle:@"未知，我也没想到" settingItemSytle:BaseSettingItemSytleArrow option:nil];
    group.items=@[item1];
    self.tableView.rowHeight=50;
    self.groups[0]=group;
    
    [self.tableView reloadData];

}




- (void)setupToolbar
{
    UIView *toolbar = [[UIView alloc] init];
//    toolbar.delegate = self;
    CGFloat toolbarH = 44;
    CGFloat toolbarW = self.view.frame.size.width;
    CGFloat toolbarY = self.view.frame.size.height - toolbarH;
    toolbar.frame = CGRectMake(0, toolbarY, toolbarW, toolbarH);
    toolbar.backgroundColor=[UIColor whiteColor];
   // [self.view addSubview:toolbar];
    self.toolbar = toolbar;
}

#pragma mark -TextView
- (void)setupTextView{
    
        Hi_PlaceholderTextView *textView = [[Hi_PlaceholderTextView alloc] init];
        textView.font = [UIFont systemFontOfSize:17];
//        textView.placeHolder = @"此时此地，你想说点什么.......";
        textView.delegate=self;
        textView.alwaysBounceVertical = YES;
        textView.frame = CGRectMake(4, 0, self.view.width-8, 120);
        [self.headerView addSubview:textView];
        _textView = textView;
    
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center addObserver:self selector:@selector(textDidChange:) name:UITextViewTextDidChangeNotification object:textView];
//
}



- (void)setupImageView
{
    UIButton *btnAddImage = [[UIButton alloc] init];
    btnAddImage.frame = CGRectMake(10, self.textView.bottom+1, 80, 80);
    btnAddImage.clipsToBounds = YES;
    btnAddImage.imageView.contentMode=UIViewContentModeScaleAspectFill;
    [btnAddImage setBackgroundImage:[UIImage imageNamed:@"live_add_msg"] forState:UIControlStateNormal];
    [self.headerView addSubview:btnAddImage];
    [btnAddImage handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        [self btnAddImageAction:(UIButton*)sender];
    }];
    _btnAddImage=btnAddImage;
}
-(void)btnAddImageAction:(UIButton*)btn{

    UIActionSheet * actionSheet = [[UIActionSheet alloc]initWithTitle:@"选择图片" delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:@"图片库" otherButtonTitles:@"拍照", nil];
    
    [actionSheet showInView:self.view withCompletionHandler:^(NSInteger buttonIndex) {
        
        [self.view endEditing:YES];
        //0.图片库 1.拍照
        if (buttonIndex==2) {
            return;
        }
        [[PhotoPickerTool sharedPhotoPickerTool]showOnPickerViewControllerSourceType:buttonIndex onViewController:self compled:^(UIImage *image, NSDictionary *editingInfo) {
            if (image) {
                [btn setImage:image forState:UIControlStateNormal];
                self.sendImage=image;
            }
        }];
    }];
//
    
}
#pragma mark -选择图片
- (void)textDidChange:(NSNotification *)note
{
//    self.navigationItem.rightBarButtonItem.enabled = self.textView.text.length != 0;
   
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    [self.textView resignFirstResponder];
}
#pragma mark -视图周期
//- (void)dealloc
//{
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//}
#pragma mark -导航
- (void)setupNavBar
{
    self.view.backgroundColor = [UIColor whiteColor];
    
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancel)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStyleDone target:self action:@selector(send)];
//    self.navigationItem.rightBarButtonItem.enabled = NO;
}
-(void)cancel{[self dismissViewControllerAnimated:YES completion:nil];}
-(void)send{
    
    [self.navigationController popViewControllerAnimated:YES];
    
    switch (self.textComposeState) {
        case Hi_TextComposeStateLiveMessage:
            [self sendLongMsg];
            break;
        case Hi_TextComposeStateChangeState:
            [self sendState];
            break;
            
        default:
            break;
    }
   

}
#pragma mark -发送状态
-(void)sendState{

     UIWINDOW_STATE_SHOW(@"正在修改");
    
    [Hi_AccountTool UpdateUserStateType:1 content:self.textView.text success:^(id result) {
        Hi_Account * account= [Hi_AccountTool getCurrentAccount];
        account.CurrentState = self.textView.text;
        [Hi_AccountTool saveCurrentAccount:account];
         UIWINDOW_SUCCESS(@"修改成功");

    } failure:^(NSError *error) {
        UIWINDOW_FAILURE(@"修改失败");

    }];

}
#pragma mark -发留言
-(void)sendLongMsg{

    //1.发送
    UIWINDOW_STATE_SHOW(@"正在发送");
    __block  NSString * tip =nil;
    UIImage * img =self.sendImage;
    [Hi_BusinessTool postLongMessagesContent:self.textView.text imgData:img Success:^(id result) {
        if (!result) {
            tip=@"服务器错误,发送失败..";
        }else{
            tip=@"发送成功..";
            
        }
        UIWINDOW_FAILURE(tip);
        
        
    } failure:^(NSError *error) {
        tip=@"网络延迟,发送失败..";
        UIWINDOW_FAILURE(tip);
        
    }];
}



@end
