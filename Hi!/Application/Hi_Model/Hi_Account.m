//
//  Account.m
//  新浪微博
//
//  Created by apple on 13-10-30.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "Hi_Account.h"
#import "NSDate+JJ.h"
@implementation Hi_Account

/**
 *  更改信息
 *
 *  @param account 账户
 *  @param Type    信息类型
 *  @param content 信息内容
 */

#pragma mark -同步帐号

+(void)sycnAccount:(Hi_Account*)account
              Type:(NSInteger)Type
           content:(NSString*)content {

    
    
//1.本地存储
    switch (Type) {
        case 1:
            account.NickName=content;
            break;
        case 2:
            account.Sex=content;
            break;
        case 3:{
         
            account.Birthday=[NSDate getRealTime:content withFormat:@"yyyy-MM-dd"];
            break;
        }
           
          
        case 4:
            account.CurrentState=content;
            break;
        case 5:
            account.Note=content;
            break;
        case 6:
            account.Jobs=content;
            break;
            
            
        default:
            break;
    }
    
    
    
//    [AccountTool saveCurrentAccount:account];
//    
//    
//    
////2.远程更新
//    if (Type==4) {
//        //1.同步
//        account.CurrentState=content;
//        [AccountTool saveCurrentAccount:account];
//        
//        [MMMemberTool UpdateUserStateType:1 content:content success:^(id result) {
//           // NSLog(@"更改成功");
//        } failure:^(NSError *error) {
//            //
//        }];
//    }else{
//        [MMMemberTool UpdateUserType:Type content:content success:^(id result) {
//            
//          //  NSLog(@"修改结果:%@",result);
//            
//        } failure:^(NSError *error) {
//            
//        }];
//    }
//    

    
  

}


#pragma mark 归档的时候调用
- (void)encodeWithCoder:(NSCoder *)encoder
{
    
    [self encode:encoder];
    
  
}

#pragma mark 解压.得到对象
- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        //@"修改你的昵称",@"修改性别男/女",@"添加你的生日",@"绑定你的手机",@"添加你的标签",@"添加你的职业"
        
        
        [self decode:decoder];
        [self customAccount];//增加用户体验
        
    }
    return self;
}

#pragma mark -额外备注
-(void)customAccount{
    
    

//    NSURL * fileUrl=[[NSBundle mainBundle]URLForResource:@"WriteTip" withExtension:@"plist"];
//    NSArray * array=[NSArray arrayWithContentsOfURL:fileUrl];
    
    if ([self.image isKindOfClass:[NSNull class]]||!self.image) {
        self.image=[UIImage imageNamed:@"user_img"];
        
    }
    
    //2.基本信息
    if ([self.NickName isKindOfClass:[NSNull class]]||!self.NickName) {
        self.NickName=AccountTIP;
    }
    
    if ([self.Sex isKindOfClass:[NSNull class]]||!self.Sex) {
        self.Sex=@"男";
    }
    
    if ([self.Jobs isKindOfClass:[NSNull class]]||!self.Jobs) {
        self.Jobs=AccountTIP;
    }
    if ([self.Note isKindOfClass:[NSNull class]]||!self.Note) {
        self.Note=AccountTIP;
    }
    if ([self.CurrentState isKindOfClass:[NSNull class]]||!self.CurrentState) {
        self.CurrentState=AccountTIP;
    }
    
    
    
    //
    //6.联系方式
    if ([self.phone isKindOfClass:[NSNull class]]||!self.phone) {
        self.phone=AccountTIP;
    }

    
    if (!self.Birthday) {
        NSDate * date = [NSDate date];
        self.Birthday=[NSDate getRealDateTime:date withFormat:@"yyyy-MM-dd"];
    }
    
    //年+星座
    
    NSDate * date=[NSDate dateString:self.Birthday];
    NSTimeInterval dateDiff = [date timeIntervalSinceNow];
    
    int age=-trunc(dateDiff/(60*60*24))/365;
    NSString * agestr=[NSString stringWithFormat:@"%d岁",age];
    self.Age=agestr;
    
    int mouth =[[NSDate getRealDateTime:date withFormat:@"MM"]intValue];
    int day =[[NSDate getRealDateTime:date withFormat:@"dd"]intValue];
    NSString * xingzuoStr=[NSDate getAstroWithMonth:mouth day:day];
    self.Xingzuo=[xingzuoStr stringByAppendingString:@"座"];
    
    
    //3.头像
    
    
    
    
   
 
    
}



@end