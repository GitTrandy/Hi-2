//
//  DateEditController.m
//  易商
//
//  Created by namebryant on 14-8-22.
//  Copyright (c) 2014年 Ruifeng. All rights reserved.
//

#import "DateEditController.h"
#import "BaseSettingCell.h"
@interface DateEditController ()

@end

@implementation DateEditController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"生日";
    [self addUnTextSubViews];
    self.account=[Hi_AccountTool getCurrentAccount];
}


-(void)addUnTextSubViews{
    
    
    
    //日期
    self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0,40,ScreenWidth,60)];
    self.datePicker.backgroundColor=[UIColor whiteColor];
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    [self.datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged ];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *date =  [dateFormatter dateFromString:self.cell.item.subtitle];
   [self.datePicker setDate:date animated:YES];
    [self.view addSubview:self.datePicker];
    
    //1.表示
    self.ageCellText=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    self.ageCellText.textLabel.text=@"生日";
    self.ageCellText.detailTextLabel.text=self.cell.item.subtitle;
    self.ageCellText.frame=CGRectMake(0, CGRectGetMaxY(self.datePicker.frame)+20, ScreenWidth, 44);
    self.ageCellText.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:self.ageCellText];
    
    //2.数字表示
    self.numCellText=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    self.numCellText.textLabel.text=@"年龄";
    NSTimeInterval  timeInterval = [date timeIntervalSinceNow];
    timeInterval = -timeInterval;
    int age = timeInterval/(60*60*24*30*12);
    NSString * ages=[NSString stringWithFormat:@"%d岁",age];
    self.numCellText.detailTextLabel.text=ages;
    self.numCellText.frame=CGRectMake(0, CGRectGetMaxY(self.ageCellText.frame), ScreenWidth, 44);
    self.numCellText.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:self.numCellText];
    
    
    
}

#pragma mark -textView-Delegate

-(void)dateChanged:(UIDatePicker*)adatePicker{
    
    
    NSDate* date = adatePicker.date;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *currentDateStr = [dateFormatter stringFromDate:date];
    //转化为时间戳
    
    NSTimeInterval  timeInterval = [date timeIntervalSinceNow];
    timeInterval = -timeInterval;
    int age = timeInterval/(60*60*24*30*12);
    
    \
    NSString * ages=[NSString stringWithFormat:@"%d岁",age];
    
    [adatePicker setDate:date animated:YES];
    self.numCellText.detailTextLabel.text=ages;
    self.ageCellText.detailTextLabel.text=currentDateStr;
  
    
}
-(void)save:(NSDate*)date{
    
    NSString * brithDayStr=[NSDate getRealDateTime:date withFormat:@"yyyy-MM-dd"];
    NSString * content = [NSDate getTimeStampLong:date];
    [Hi_AccountTool UpdateUserType:AccountTypeBirthday content:content success:^(id result) {
        
        if (!result) {
            [JDStatusBarNotification showWithStatus:@"服务器暂时休息了,修改失败" dismissAfter:1];
            
        }
        self.account.Birthday=brithDayStr;
        [Hi_AccountTool saveCurrentAccount:self.account];
        self.cell.item.subtitle= self.ageCellText.detailTextLabel.text;
        [self.navigationController popViewControllerAnimated:YES];

    } failure:^(NSError *error) {
        [JDStatusBarNotification showWithStatus:@"服务器暂时休息了,修改失败" dismissAfter:1];
    }];
    
   

    
}

-(void)rightBtnAction:(UIButton *)rightBtn{
   
    [self save:self.datePicker.date];

}

@end
