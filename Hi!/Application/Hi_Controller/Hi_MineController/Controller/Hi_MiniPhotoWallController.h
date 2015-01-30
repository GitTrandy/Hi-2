//
//  Hi_MiniPhotoWallController.h
//  hihi
//
//  Created by 伍松和 on 14/12/29.
//  Copyright (c) 2014年 伍松和. All rights reserved.
//

#import "Hi_BaseViewController.h"

@interface Hi_MiniPhotoWallController : Hi_BaseViewController
@property (weak, nonatomic) IBOutlet UIButton *oneBtn;
@property (weak, nonatomic) IBOutlet UIButton *twoBtn;
@property (weak, nonatomic) IBOutlet UIButton *threeBtn;
@property (weak, nonatomic) IBOutlet UIButton *foureBtn;
@property (strong,nonatomic)NSMutableArray * btnArray;
@end
