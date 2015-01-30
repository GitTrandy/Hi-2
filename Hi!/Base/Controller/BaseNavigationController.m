//
//  CommonNavigationController.m
//  易商
//
//  Created by namebryant on 14-9-10.
//  Copyright (c) 2014年 Ruifeng. All rights reserved.
//

#import "BaseNavigationController.h"
#import "UIBarButtonItem+MJ.h"
#define iOS7 ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0)

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController
- (void)viewDidLoad
{
    [super viewDidLoad];
//    [self setToolbarHidden:YES animated:YES];
//    self.hidesBarsWhenKeyboardAppears=YES;
//    self.hidesBarsOnTap=YES;
//    self.hidesBarsWhenVerticallyCompact=YES;
     // 重新拥有滑动出栈的功能
//    UIEdgeInsets insets = UIEdgeInsetsMake(0, 0, 5, 0); // or (0, 0, -10.0, 0)
//    UIImage *alignedImage = [[UIImage imageNamed:@"navigationbar_back_os7"] imageWithAlignmentRectInsets:insets];
//    self.navigationController.navigationBar.backIndicatorImage=alignedImage;
//    self.navigationController.navigationBar.backIndicatorTransitionMaskImage = alignedImage;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    

    if (self.viewControllers.count) {
        viewController.hidesBottomBarWhenPushed = YES;
  
    }
    [super pushViewController:viewController animated:animated];
    
     if (self.viewControllers.count) {
         [viewController navigationItem].backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:NULL];}

}

//

@end
