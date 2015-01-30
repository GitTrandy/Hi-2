//
//  MessageTableView.m
//  hihi
//
//  Created by 伍松和 on 15/1/16.
//  Copyright (c) 2015年 伍松和. All rights reserved.
//

#import "MessageTableView.h"
#import "UIScrollView+EmptyDataSet.h"
@interface MessageTableView()<DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@end

@implementation MessageTableView
- (void)initializator{

    self.emptyDataSetDelegate=self;
    self.emptyDataSetSource=self;
    self.separatorStyle= UITableViewCellSeparatorStyleNone;
}
- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:UITableViewStylePlain];
    if (self)     {
        [self initializator];

    }
    return self;
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    
    
    NSDictionary *attributes= @{NSFontAttributeName:[UIFont boldSystemFontOfSize:17.0],NSForegroundColorAttributeName:[UIColor lightGrayColor]};
    NSAttributedString * string =[[NSAttributedString alloc]initWithString:@"对方不回之前,你有说三句话的机会" attributes:attributes];
    return string;
}
-(NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView{
    NSDictionary *attributes= @{NSFontAttributeName:[UIFont boldSystemFontOfSize:13.0],NSForegroundColorAttributeName:[UIColor redColor]};
    NSAttributedString * string =[[NSAttributedString alloc]initWithString:@"不过如果你们下次能在另外一个WIFI相遇,证明你们的缘分未断,还可以给你再3次机会" attributes:attributes];
    return string;
}
-(UIImage*)imageForEmptyDataSet:(UIScrollView *)scrollView{return [UIImage imageNamed:@"em_3"];}
- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView
{
    return YES;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView
{
    return YES;
}
#pragma mark -表视图
- (void)scrollToBottomAnimated:(BOOL)animated
{
    
    
    NSInteger rows = [self numberOfRowsInSection:0];
    
    if(rows > 0) {
        [self scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:rows - 1 inSection:0]
                              atScrollPosition:UITableViewScrollPositionBottom
                                      animated:animated];
    }
    
}

- (void)reloadData
{
//    self.showsVerticalScrollIndicator = NO;
//    self.showsHorizontalScrollIndicator = NO;
    
    [super reloadData];
}

@end
