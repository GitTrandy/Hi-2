//
//  Hi_HtmlViewController.h
//  Hi!
//
//  Created by 伍松和 on 14/12/7.
//  Copyright (c) 2014年 伍松和. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Hi_HtmlViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic,strong)NSURL * htmlPath;
@end
