

#import "Hi_ShopViewController.h"
#import "Hi_CouponListController.h"
#import "Hi_ShopDetailViewController.h"

@interface Hi_ShopViewController ()

@end

@implementation Hi_ShopViewController


-(void)viewWillAppear:(BOOL)animated{}
- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.navigationItem.rightBarButtonItem=[UIBarButtonItem itemWithTitle:@"优惠卷" themeColor: [UIColor whiteColor] target:self action:@selector(jumpToYouhui:)];
    self.rightBtn=self.navigationItem.rightBarButtonItem.barButton;
   
    [self.tableView headerBeginRefreshing];
    
}
-(void)jumpToYouhui:(id)sender{

    Hi_CouponListController * couponCtrl = [[Hi_CouponListController alloc]init];
    [self.navigationController pushViewController:couponCtrl animated:YES];
}
-(void)loadMoreData{

    [Hi_BusinessTool getBusinessSuccess:^(id results) {
        if (results) {
            self.dataSource=[NSMutableArray arrayWithArray:results];
            
        }
        [self reloadTableData];
    } failure:^(NSError *error) {
        [self reloadTableData];

    }];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    static NSString * cellID= @"shop_cell";
    Hi_TableViewSecondCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell=[Hi_TableViewSecondCell instancetypeWithSecondNib];
    }
    
    cell.rightLab.hidden=YES;
    cell.businessModel=self.dataSource[indexPath.row];
    
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{return 80;}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Hi_BusinessModel * businessModel = self.dataSource[indexPath.row];
    Hi_ShopDetailViewController * shopDetailCtrl = [[Hi_ShopDetailViewController alloc]init];
    shopDetailCtrl.bid=businessModel.bid;
    shopDetailCtrl.title=businessModel.name;
    [self.navigationController pushViewController:shopDetailCtrl animated:YES];
}
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    
    
    NSDictionary *attributes= @{NSFontAttributeName:[UIFont boldSystemFontOfSize:17.0],NSForegroundColorAttributeName:[UIColor lightGrayColor]};
    NSAttributedString * string =[[NSAttributedString alloc]initWithString:@"没有你所属的店铺" attributes:attributes];
    return string;
}
-(NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView{
    NSDictionary *attributes= @{NSFontAttributeName:[UIFont boldSystemFontOfSize:13.0],NSForegroundColorAttributeName:[UIColor redColor]};
    NSAttributedString * string =[[NSAttributedString alloc]initWithString:@"需要你连接到官方授权的店铺才可以添加属于你的店铺" attributes:attributes];
    return string;
}
-(UIImage*)imageForEmptyDataSet:(UIScrollView *)scrollView{return [UIImage imageNamed:@"em_3"];}
@end
