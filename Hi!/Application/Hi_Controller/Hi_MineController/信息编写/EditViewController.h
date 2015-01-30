//
//  EditViewController.h
//  Meimei
//
//  Created by namebryant on 14-7-10.
//  Copyright (c) 2014年 Meimei. All rights reserved.
//

#import "BaseEditViewController.h"
@interface EditViewController : BaseEditViewController

@property (strong, nonatomic) UITextField *messageTextField;
@property (strong, nonatomic) UILabel * tipLabel;
@property (strong, nonatomic)NSMutableArray * ArrayM;
@property (strong, nonatomic)NSDictionary * tipDic;
@property (strong, nonatomic)NSMutableArray * suggestArray;

@property (copy, nonatomic)NSString * tipkey;

@end
