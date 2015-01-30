/*
 
 1.提示性语言,一次就好
 
 A.当优惠卷使用后，直接退出是使当前优惠卷无效(保存时长)----
 B.
 
 
 */




#import "Hi_CouponDetailController.h"
#import "Hi_CouponsModel.h"
#import "Hi_CouponsTool.h"


@interface Hi_CouponDetailController ()
@property (nonatomic,strong)UIButton        * timeButton;
@property (nonatomic,strong)NSDate           * hi_fireDate;
@property (nonatomic,strong)NSTimer         * hi_timer;
@property (nonatomic,assign)NSInteger        leftTime;

@end

@implementation Hi_CouponDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:self.timeButton];
    self.tableView.height-=self.timeButton.height;

    [self loadMoreData];
    self.cid=self.couponModel.cid;

}
#pragma mark -底部按钮
-(UIButton *)timeButton{

    if (!_timeButton) {
        
        UIImage * bgImg = [UIImage resizedImage:@"green_bg"];
        _timeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_timeButton setBackgroundImage:bgImg forState:UIControlStateNormal];
        _timeButton.frame=CGRectMake(20, self.view.height-70, self.view.width-40, 50);
        NSString * timeStr =[NSString stringWithFormat:@"使用:点击后开始计时,一共%d秒",(int)self.couponModel.use_time];
        [_timeButton setTitle:timeStr forState:UIControlStateNormal];
        [_timeButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            [self timeAction];
        }];
    }
    return _timeButton;
}
#pragma mark -定时器


-(void)quitCoupon:(id)sender{
 
    NSString * cidC=Hi_COUPONS_CONDTION_ID(self.cid);

    if (_leftTime<1) {
        [Hi_CouponsModel updatePropertyName:@"isUse" newProperty:@(YES) where:cidC];
        
    }else{
        [Hi_CouponsModel updatePropertyName:@"use_time" newProperty:@(_leftTime?_leftTime:30) where:cidC];


    }
    [_hi_timer invalidate];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)timeAction{
    _hi_timer= [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_hi_timer forMode:NSDefaultRunLoopMode];
    _hi_fireDate=[NSDate date];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTitle:@"退出" themeColor: [UIColor whiteColor] target:self action:@selector(quitCoupon:)];
}
-(void)timerFired:(NSTimer*)timer{
    
    NSInteger leftTime=self.couponModel.use_time;
    NSInteger timeNum=(NSInteger)[timer.fireDate timeIntervalSinceDate:_hi_fireDate];
    NSString * timeleft=[NSString stringWithFormat:@"请在%d秒内使用,%d秒后无效",leftTime-timeNum,leftTime-timeNum];
    NSLog(@"剩余时间：%@",timeleft);
    [_timeButton setTitle:timeleft forState:UIControlStateNormal];
    _timeButton.enabled=NO;
    _leftTime=leftTime-timeNum;
    if (leftTime-timeNum<1) {
        [_timeButton setTitle:@"优惠卷失效" forState:UIControlStateNormal];
        [timer invalidate];
        
    }

}
-(void)dealloc{
    [_hi_timer invalidate];
}
#pragma mark -CID
-(void)setCid:(NSString *)cid{

    _cid=cid;
    [Hi_CouponsTool getCoupon:cid success:^(id result) {
        if (result) {
            if (!self.couponModel) {
                self.couponModel=result;
            }else{
                Hi_CouponsModel * c =result;
                self.couponModel.remark=c.remark;
                self.couponModel.bid=c.bid;
                self.couponModel.startTimeFormat=c.startTimeFormat;
                [Hi_CouponsModel updateToDB:self.couponModel where:[NSString stringWithFormat:@"cid='%@'",c.cid]];
            }
            
            [self loadMoreData];
        }

    } failure:^(NSError *error) {
        [self.tableView reloadData];
    }];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section==0) {
        return 10;
    }
    return 40;
}
-(void)loadMoreData{
    if (self.couponModel) {
        
        //A.
        NSArray * arrayA = @[@{@"image_url":self.couponModel.image?self.couponModel.image:@"",@"title":self.couponModel.title},
                             @{@"image":@"business_phone_call",@"title":self.couponModel.phone?self.couponModel.phone:@"无电话"},
                             @{@"image":@"business_location",@"title":self.couponModel.address?self.couponModel.address:@"无地址"}];
        
        [self.sectionDictionary setObject:arrayA forKey:@""];
        
        //B.
        NSArray * arrayB=@[@{@"title":self.couponModel.content}];
        [self.sectionDictionary setObject:arrayB forKey:@"B优惠详情"];
        
      
        
        [self.tableView reloadData];

        
        
    }
   

}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    
    NSArray * arrayA =self.sectionDictionary[indexPath.section];
    NSDictionary * dic= arrayA[indexPath.row];
    static NSString * cellID=@"couponDetail";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
   
#pragma mark -图像
    
    if (dic[@"image_url"]) {
        
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:dic[@"image_url"]] placeholderImage:[UIImage imageNamed:@"user_img"]];
        cell.imageView.layer.cornerRadius=40;
        cell.imageView.clipsToBounds=YES;
        cell.imageView.contentMode=UIViewContentModeScaleAspectFill;

    }else if(dic[@"image"]){
        cell.imageView.contentMode=UIViewContentModeScaleAspectFill;
        cell.imageView.image=[UIImage imageNamed:dic[@"image"]];
    }else{
        //
    }
    
  
#pragma mark -文字
    cell.textLabel.numberOfLines=0;
    cell.textLabel.text=dic[@"title"];
    
    
#pragma mark -
    if (indexPath.section==0) {

        CGFloat cellHeight =(indexPath.row==0)?80:50;
        UIView * bottomline = [[UIView alloc]initWithFrame:CGRectMake(0, cellHeight-0.2, cell.width, 0.2)];
        bottomline.backgroundColor=Color(181, 181, 181, 0.2);
        [cell.contentView addSubview:bottomline];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
   
    
    return cell;

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    switch (indexPath.section) {
        case 0:
        {

        if (indexPath.row==0) {
            return 80;
        }else{
            return 50;
        }
         break;
        }
        case 1:
        {
            return [self heightForTitleLabel:self.couponModel.content].height+60;
        }
        
           
            
        default:
            return 50;
            break;
    }
    
  
    
}
- (CGSize)heightForTitleLabel:(NSString*)subTitle
{
    UIFont *font=[UIFont systemFontOfSize:15];
    NSDictionary *attribute = @{NSFontAttributeName:font};
    CGSize size = [subTitle boundingRectWithSize:CGSizeMake(self.view.width,MAXFLOAT) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:attribute context:NULL].size;
    
    return size;
}

@end
