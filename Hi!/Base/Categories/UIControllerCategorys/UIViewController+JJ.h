//
//  UIViewController+JJ.h
//  易商
//
//  Created by 伍松和 on 14/10/24.
//  Copyright (c) 2014年 Ruifeng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AlertViewBlock)(id alertView,NSInteger alertView_Index);
@interface UIViewController (JJ)



///警告Alert视图
-(void)showAlertViewWithTitle:(NSString*)title
                   detailTitle:(NSString*)detailTitle
                   cancelTitle:(NSString*)cancelTitle
                    otherTitle:(NSArray*)otherTitles
                    alertViewBlock:(AlertViewBlock)alertViewBlock;
@end
