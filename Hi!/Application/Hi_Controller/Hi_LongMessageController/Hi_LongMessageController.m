#import "Hi_LongMessageController.h"
#import "Hi_TextComposeViewController.h"



#import "Hi_TableViewLongMsgCell.h"
#import "Hi_LongMsgModel.h"

@interface Hi_LongMessageController ()

@end

@implementation Hi_LongMessageController

-(void)setBID:(NSString *)BID{
    
    _BID=BID;
    
//    [self.tableView headerBeginRefreshing];

}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    //0
    // self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTitle:@"发布留言" themeColor:[UIColor whiteColor] target:self action:@selector(jumpToWrite:)];
   self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithIcon:@"nav_icon_compose" highlightedIcon:@"nav_icon_compose" target:self action:@selector(jumpToWrite:)];
    
    //1.table
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    self.tableView.tableFooterView = [[UIView alloc] init];
//    self.tableView.separatorInset = UIEdgeInsetsMake(0, 100, 0, 0);
    [self.tableView headerBeginRefreshing];
    
//    self.navigationController.hidesBarsOnSwipe = YES;

   


}
#pragma mark -加载更多
-(void)loadBottomData{
    
    
    [Hi_BusinessTool getAllLongMessagesWithBID:self.BID
                                         Start:self.dataSource.count
                                         limit:20
                                       Success:^(NSArray *results) {
        if (results.count>0) {
            NSMutableArray * arrayM=[NSMutableArray arrayWithArray:results];
            NSIndexSet * set = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(self.dataSource.count, arrayM.count)];
            [self.dataSource insertObjects:arrayM atIndexes:set];
        }else{
            
            [self.tableView removeFooter];
            UIWINDOW_FAILURE(@"该现场没有更多留言了");
//            [UIWindow showWithBarStatus:@"没有留言" dismissAfter:7];
        }
        [self reloadTableData];
    } failure:^(NSError *error) {
        [self reloadTableData];
        
    }];
}
-(void)loadMoreData{
    
    
    [Hi_BusinessTool getAllLongMessagesWithBID:self.BID
                                             Start:0
                                             limit:20
                                           Success:^(NSArray *results) {
        if (results) {
            self.dataSource=[NSMutableArray arrayWithArray:results];
            if (results.count>=20) {
                WEAKSELF;
                [self.tableView addFooterWithCallback:^{
                    [weakSelf loadBottomData];
                }];
            }
        }
        
        [self reloadTableData];
    } failure:^(NSError *error) {
        [self reloadTableData];
        
    }];
    
    
}
-(void)reloadTableData{
    
    [super reloadTableData];
    [self.tableView footerEndRefreshing];
   
    

}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
-(void)jumpToWrite:(UIBarButtonItem*)item{

    Hi_TextComposeViewController * textComposeCtrl = [[Hi_TextComposeViewController alloc]initWithState:Hi_TextComposeStateLiveMessage];
    textComposeCtrl.title = @"现场留言";
    [self.navigationController pushViewController:textComposeCtrl animated:YES];
//    BaseNavigationController * nav = [[BaseNavigationController alloc]initWithRootViewController:textComposeCtrl];
//    [self presentViewController:nav animated:YES completion:nil];
    
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString * cellID= HI_LONG_MSG_CELL_NAME;
   [UITableViewCell configureCellWithClass:[Hi_TableViewLongMsgCell class] WithCellID:cellID WithTableView:tableView];
   Hi_TableViewLongMsgCell * cell =(Hi_TableViewLongMsgCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
//   if (!cell) {
//       cell=[Hi_TableViewLongMsgCell instancetypeWithXIB];
//   }
    Hi_LongMsgModel * longModel =self.dataSource[indexPath.row];
    cell.longModel=longModel;
    //1.图片
    [cell tapImageWall:^(id cell, id otherData) {
        UIImageView * imageView =(UIImageView *)otherData;
        [self viewWallImageView:imageView array:@[longModel.img]];
    }];
    //2.信息
    [cell tapAvatar:^(id cell, id otherData) {
        [self viewPersonInfo:longModel.mid];
    }];
    
    //3.点赞
    [cell tapLike:^(id cell, id otherData) {
        [self tapLike:otherData indexPath:indexPath];
    }];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
#pragma mark -点赞
-(void)tapLike:(Hi_LongMsgModel*)longModel
     indexPath:(NSIndexPath*)indexPath{
    [self.dataSource replaceObjectAtIndex:indexPath.row withObject:longModel];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}
#pragma mark -点击查看人物信息
-(void)viewPersonInfo:(NSString*)uid{
    
    Hi_UserDetailController * userDetail = [[Hi_UserDetailController alloc]init];
    userDetail.user_id=uid;
    userDetail.isNotLiveUserModel=YES;
    [self.navigationController pushViewController:userDetail animated:YES];
}
#pragma mark -点击查看照片
-(void)viewWallImageView:(UIImageView*)imageView
                   array:(NSArray*)array{

    // 2.显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    NSMutableArray * photos=[NSMutableArray array];
    for (NSInteger i=0; i<array.count; i++) {
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = [NSURL URLWithString:array[i]];
        photo.srcImageView = imageView; // 来源于哪个UIImageView
        [photos addObject:photo];
    }
  
    browser.photos = photos; // 设置所有的图片
    [browser show];
}
#pragma mark -高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    Hi_TableViewLongMsgCell *cell =(Hi_TableViewLongMsgCell *) [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.cellHeight;
}
#pragma mark -点击
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
 
}
#pragma mark -警告
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    
    
    NSDictionary *attributes= @{NSFontAttributeName:[UIFont boldSystemFontOfSize:17.0],NSForegroundColorAttributeName:[UIColor lightGrayColor]};
    NSAttributedString * string =[[NSAttributedString alloc]initWithString:@"当前WIFI现场没有用户留言哦" attributes:attributes];
    return string;
}
-(NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView{
    NSDictionary *attributes= @{NSFontAttributeName:[UIFont boldSystemFontOfSize:13.0],NSForegroundColorAttributeName:[UIColor redColor]};
    NSAttributedString * string =[[NSAttributedString alloc]initWithString:@"要不要到处走走?" attributes:attributes];
    return string;
}
-(UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView{return [UIImage imageNamed:@"em_3"];}
@end
