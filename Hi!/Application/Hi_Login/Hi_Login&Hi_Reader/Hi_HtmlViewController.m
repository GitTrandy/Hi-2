//
//  Hi_HtmlViewController.m
//  Hi!
//
//  Created by 伍松和 on 14/12/7.
//  Copyright (c) 2014年 伍松和. All rights reserved.
//

#import "Hi_HtmlViewController.h"

@interface Hi_HtmlViewController ()<UIWebViewDelegate>

@end

@implementation Hi_HtmlViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.webView.delegate = self;
    
   
    self.title=@"用户协议";
    // 创建请求
    NSURLRequest *request = [NSURLRequest requestWithURL:self.htmlPath];
    
    // 发送请求加载网页
    [self.webView loadRequest:request];

}

/**
 *  网页加载完毕的时候调用
 */
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    // 跳到id对应的网页标签
    
    // 1.拼接Javacript代码
    NSString *js = [NSString stringWithFormat:@"window.location.href = '#%@';", @"gdy11_howto.html"];
    // 2.执行JavaScript代码
    [webView stringByEvaluatingJavaScriptFromString:js];
}

@end
