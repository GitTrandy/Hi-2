////
////  StateEditController.m
////  Meimei
////
////  Created by namebryant on 14-8-1.
////  Copyright (c) 2014年 Meimei. All rights reserved.
////
//
//#import "StateEditController.h"
//#import "BaseSettingCell.h"
//
//@interface StateEditController ()<UITextViewDelegate>
//{
//
//    Account * account;
//    UIButton * _backButton;
//}
//
//
//@end
//
//@implementation StateEditController
////@synthesize messageTextView;
//
//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//    
//    //0.背景
//    self.view.backgroundColor=kColor(239, 239, 239);
//    //1.输入栏
//   _messageTextView.placeholder = NSLocalizedString(@"添加你的个人简介",);
//    if ([self.cell.subtitleLabel.text isEqualToString:@"添加你的个人简介"]) {
//        _messageTextView.text=@"";
//    }else{
//        _messageTextView.text=self.cell.item.subtitle;
//    }
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(messageDidChange:) name:UITextViewTextDidChangeNotification object:_messageTextView];
//
//    
//    //2.字数
//    NSString * num=[NSString stringWithFormat:@"%d字",(int)self.cell.item.subtitle.length];
//    _numLabel.text=num;
//    _messageTextView.delegate=self;
//    account=[AccountTool getCurrentAccount];
//    
//    
//    //3.返回
//    self.navigationItem.leftBarButtonItem.customView.hidden=YES;
//    [self.rightBtn setTitle:@"完成" forState:UIControlStateNormal];
//   
//
//}
//
//#pragma mark -键盘弹起
//-(void)viewDidAppear:(BOOL)animated{
//    
//    [super viewDidAppear:animated];
//    [_messageTextView becomeFirstResponder];
//    
//}
//#pragma mark - 左右
//
//-(void)rightBtnAction:(UIButton *)rightBtn{
//    
//    if (_messageTextView.text.length>50) {
//        
//        //[CommonClass showSIAlert:@"字数大于了50个了" msg:@"警告"];
//        
//        return;
//    }else if (_messageTextView.text.length<=0){
//     //   [CommonClass showSIAlert:@"字数少于0个了" msg:@"警告"];
//        return;
//    }
//    
//    account.CurrentState=_messageTextView.text;
//    [AccountTool saveCurrentAccount:account];
//    //2.UI
//    [_messageTextView resignFirstResponder];
//    self.cell.item.subtitle=_messageTextView.text;
//    [self.navigationController popViewControllerAnimated:YES];
//    
//}
//#pragma mark -字数改变
//-(void)messageDidChange:(NSNotification*)notification{
//
//    NSString * num=[NSString stringWithFormat:@"%d字",(int)_messageTextView.text.length];
//    // NSLog(@"字数：%@",num);
//    
//    _numLabel.text=num;
//    
//    if (_messageTextView.text.length>50) {
//        _numLabel.textColor=[UIColor redColor];
//    }else{
//        _numLabel.textColor=[UIColor lightGrayColor];
//    }
//    
//
//}
//
//-(void)showAlert:(NSString*)msg{
//    
//    UIAlertView * alertView=[[UIAlertView alloc]initWithTitle:@"信息" message:msg delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
//    [alertView show];
//}
//
//@end
