//
//  MemberModel.m
//  Notifation-Demo
//
//  Created by namebryant on 14-7-3.
//  Copyright (c) 2014年 namebryant. All rights reserved.
//

#import "Hi_UserModel.h"
#import "Hi_UserTool.h"
@implementation Hi_UserModel
#pragma mark -生日
-(void)setBirthDay:(NSString*)birthDay{
    
    
    _birthDay=birthDay;
   
    if (_birthDay) {
      NSString * temp=[NSString stringWithFormat:@"%@",_birthDay];
        if (_birthDay.length>9) {
             _birthDay=[_birthDay substringToIndex:9];
        }
   
    NSString * birthdayStr=[NSDate getRealTime:temp];
     _birthDay=birthdayStr;
        
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date =  [dateFormatter dateFromString:birthdayStr];
    
    NSTimeInterval dateDiff = [date timeIntervalSinceNow];
    
  
    int age=-trunc(dateDiff/(60*60*24))/365;
    NSString * agestr=[NSString stringWithFormat:@"%d岁",age];
    self.age=agestr;
    
   
    int mouth =[[NSDate getRealDateTime:date withFormat:@"MM"]intValue];
    int day =[[NSDate getRealDateTime:date withFormat:@"dd"]intValue];
    NSString * xingzuoStr=[NSDate getAstroWithMonth:mouth day:day];
    self.Xingzuo=[xingzuoStr stringByAppendingString:@"座"];
        
        
    }
    
}
-(void)setSex:(NSString *)sex{
    
    _sex=sex;

    if ([_sex isEqualToString:@"1"]) {_sex=@"男";}else{_sex=@"女";}

}
-(void)setOccupation:(NSString *)occupation{

    _occupation=occupation;
    if ([occupation isKindOfClass:[NSNull class]]) {
        _occupation=@"未知职业";
    }
}


@end
