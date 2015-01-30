#import "Hi_ShopDetailViewController.h"
#import "Hi_BusinessTool.h"
#import "Hi_OperationBar.h"

#import "Hi_ScrollImageView.h"
#import "Hi_LongMessageController.h"
#import "Hi_CouponListController.h"



#import "LXActivity.h"
#import "Hi_ShareTool.h"

typedef NS_ENUM(NSInteger, Hi_ShopButtonAction) {

    Hi_ShopButtonActionYouhui,
    Hi_ShopButtonActionShare,
    Hi_ShopButtonActionLove,
    Hi_ShopButtonActionUnLove
};
@interface Hi_ShopDetailViewController ()<LXActivityDelegate>
@property (nonatomic,strong)Hi_OperationBar *operationBar;
@property (nonatomic,strong)UIButton *selectedButton;
@property (nonatomic,strong)Hi_ScrollImageView * scrollImageView;
@end

@implementation Hi_ShopDetailViewController
-(Hi_OperationBar *)operationBar{

    if (!_operationBar) {
        CGRect rect =CGRectMake(0, self.view.height-50, self.view.width, 50);
        
        Hi_OperationBar * bar=[[Hi_OperationBar alloc]initWithFrame:rect operationBarDicArray:HI_IMAGE_SHOP_DETAIL_ARRAY titleColor:nil ButtonPositionType:ButtonPositionTypeNoneTitle];
        bar.bottomImageView.image =[UIImage resizedImage:@"chat_bottom_bg"];
        
        [bar addActionBlock:^(id button, NSInteger buttonTag) {
            [self buttonAction:button tag:buttonTag];
        }];
        _operationBar=bar;
    }
    return _operationBar;
}
-(void)buttonAction:(UIButton*)button
                tag:(NSInteger)buttonTag{
    button.selected =!button.selected;
    Hi_ShopButtonAction action=buttonTag;
    switch (action) {
        case Hi_ShopButtonActionYouhui:
        {
            
            Hi_CouponListController * couponCtrl = [[Hi_CouponListController alloc]init];
            couponCtrl.BID=self.bid;
            [self.navigationController pushViewController:couponCtrl animated:YES];
            break;
        }
        case Hi_ShopButtonActionShare:
        {
            
            NSArray *shareButtonTitleArray = @[@"开心果",@"微信",@"微信朋友圈",@"微博",@"QQ",@"QQ空间"];
            NSArray *shareButtonImageNameArray = @[@"Group_0",@"Group_1",@"Group_2",@"Group_3",@"Group_4",@"Group_5"];
            LXActivity *lxActivity = [[LXActivity alloc] initWithTitle:@"分享到社交平台" delegate:self cancelButtonTitle:@"取消" ShareButtonTitles:shareButtonTitleArray withShareButtonImagesName:shareButtonImageNameArray];
            [lxActivity showInView:self.view];
            break;
        }
        case Hi_ShopButtonActionLove:
        {
            break;
        }
        case Hi_ShopButtonActionUnLove:
        {
            break;
        }
            
            
        default:
            break;
    }
    
}
- (void)didClickOnImageIndex:(NSInteger )imageIndex
{
    NSInteger index = imageIndex;
    
    [Hi_ShareTool ShareActionDidClickOnButtonIndex:index url:@"http://mmapiss.meimeime.com:8081/MM"
                                             image:[UIImage imageNamed:@"Group_0"]
                                             title:self.businessModel.name
                                          desTitle:self.businessModel.remark
                                              ctrl:self];
}

- (void)didClickOnCancelButton
{
    NSLog(@"didClickOnCancelButton");
}

-(Hi_ScrollImageView*)scrollImageView{

    if (!_scrollImageView) {
        CGRect frame =CGRectMake(0, 0, ScreenWidth, 200);
      
        NSMutableArray * arrayM =[NSMutableArray array];
        for (NSString * url in self.businessModel.photos) {
            [arrayM addObject:@{@"url":url,@"image":@"Meimei_Logo"}];
        }
        
        Hi_ScrollImageView * ScrollImageView =[[Hi_ScrollImageView alloc]initWithFrame:frame array:arrayM];
        [ScrollImageView tapImageAction:^(id objectData) {
            
            [self tapImage:(Hi_ImageView*)objectData];
        }];
        _scrollImageView=ScrollImageView;

    }
    
    return _scrollImageView;
}
-(void)tapImage:(Hi_ImageView*)imageView{

    NSArray * array = self.businessModel.photos;
    int count = (int)array.count;
    // 1.封装图片数据
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i<count; i++) {
        // 替换为中等尺寸图片
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = [NSURL URLWithString:array[i]]; // 图片路径
        photo.srcImageView = imageView; // 来源于哪个UIImageView
        [photos addObject:photo];
    }
    
    // 2.显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = imageView.tag; // 弹出相册时显示的第一张图片是？
    browser.photos = photos; // 设置所有的图片
    [browser show];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //1.
    
    
    WEAKSELF;
    [self.tableView addHeaderWithCallback:^{
        [weakSelf loadMoreData];
    }];
    
    [self.tableView headerBeginRefreshing];
    
    
    //2.
    
    self.navigationItem.rightBarButtonItem=[UIBarButtonItem itemWithTitle:@"留言墙" themeColor: [UIColor whiteColor] target:self action:@selector(jumpToLiuYan:)];
    self.rightBtn=self.navigationItem.rightBarButtonItem.barButton;

}
-(void)jumpToLiuYan:(UIBarButtonItem*)item{
    
#pragma mark -留言
 
        
        Hi_LongMessageController * longMsgCtrl = [[Hi_LongMessageController alloc]init];
        longMsgCtrl.BID=self.businessModel.bid;
        longMsgCtrl.title=[NSString stringWithFormat:@"%@的留言",self.businessModel.name];
        [self.navigationController pushViewController:longMsgCtrl animated:YES];
    
   
    
}
-(void)loadMoreData{

    [Hi_BusinessTool getBusinessWithBID:self.bid success:^(id result) {
        if (result) {
            self.businessModel=(Hi_BusinessModel*)result;
            [self dealBusinessModel:self.businessModel];
        }
    } failure:^(NSError *error) {
        //
    }];
}
-(void)dealBusinessModel:(Hi_BusinessModel*)businessModel{


    
    NSArray * arrayA =@[@{@"image": @"business_phone_call",@"info":businessModel.fixPhone},
                @{@"image": @"business_location",@"info":businessModel.address},
                @{@"image": @"business_newspaper",@"info":businessModel.remark}];

    
    [self.sectionDictionary setValue:arrayA forKey:@"A 联系方式"];
    
    [self reloadTableData];
    
}
-(void)reloadTableData{

    [super reloadTableData];
    
    self.tableView.tableHeaderView=self.scrollImageView;
    [self.view addSubview:self.operationBar];
    self.tableView.height-=self.operationBar.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath

{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"BusinessCellDetail"];
    
    if (cell==nil) {
        
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BusinessCellDetail"];
    }
    NSInteger section=indexPath.section;
    if (section==0) {
       
            NSDictionary * dic =self.sectionDictionary[indexPath.section][indexPath.row];
            cell.textLabel.textColor=[UIColor lightGrayColor];
            cell.textLabel.text=dic[@"info"];
            cell.imageView.image=[UIImage imageNamed:dic[@"image"]];
            if (indexPath.row==2) {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.textLabel.numberOfLines=0;
            }
        
        
        
        
        
        
    }
    return cell;
    
    
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section==0) {
        if (indexPath.row==2) {
            return 200;
        }
        else{
            return 50;
        }
    }
    
    return 50;
}

@end
