//
//  Hi_ScrollView.m
//  hihi
//
//  Created by 伍松和 on 14/12/15.
//  Copyright (c) 2014年 伍松和. All rights reserved.
//

#import "Hi_ScrollImageView.h"

@interface Hi_ScrollImageView()<UIScrollViewDelegate>
@end

@implementation Hi_ScrollImageView
#define Hi_ScrollViewBottomMargin 36
-(instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.scrollView];
        [self addSubview:self.pageControl];
    }
    return self;
}
/*
 1.多少页
 2.什么视图
 3.
 
 */
- (id)initWithFrame:(CGRect)frame
              array:(NSArray*)dataArray
{
    self = [super initWithFrame:frame];
    if (self) {
        self.dataArray=dataArray;
        [self addSubview:self.scrollView];
        [self addSubview:self.pageControl];
    }
    return self;
}
/*
 
 @{@"image":xxx,@"url":xxxx,
 @"image":aaa,@"url":xxxx}
 
 */
-(void)setDataArray:(NSArray *)dataArray{

    _dataArray=dataArray;
    
    [dataArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary * dic=obj;
        NSString *url=@"";
        NSString * imageName=@"";
        //1.暂时用 Hi_ImageView
        if (dic[@"url"]) {
            url=dic[@"url"];
        }
        if (dic[@"image"]) {
            imageName=dic[@"image"];
        }
        CGFloat X =idx*CGRectGetWidth(self.scrollView.bounds);
        CGRect frame ={CGPointMake(X,0.0f),self.scrollView.frame.size};
        Hi_ImageView * hi_imageView=[[Hi_ImageView alloc]initWithFrame:frame url_string:url image:imageName];
        hi_imageView.tag = idx;
        hi_imageView.userInteractionEnabled = YES;
        [hi_imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)]];
        [self.scrollView addSubview:hi_imageView];

    }];
}
-(void)tapImageAction:(tapImageAction)action{
    self.action=action;
}
-(void)dealloc{self.action=nil;}
-(void)tapImage:(UITapGestureRecognizer*)tap{
    if (self.action) {
        self.action(tap.view);
    }
}
-(UIScrollView *)scrollView{

    if (!_scrollView) {
        UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0.0f,0.0f,CGRectGetWidth(self.bounds),CGRectGetHeight(self.bounds)-Hi_ScrollViewBottomMargin)];
         scrollView.delegate = self;
        [scrollView setPagingEnabled:YES];
        [scrollView setShowsHorizontalScrollIndicator:NO];
        [scrollView setContentSize:CGSizeMake(CGRectGetWidth(scrollView.frame)*self.dataArray.count,CGRectGetHeight(scrollView.frame))];
        _scrollView=scrollView;
    }
    return _scrollView;

}
-(UIPageControl *)pageControl{

    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc]init];
        [_pageControl setFrame:CGRectMake(0,CGRectGetMaxY(self.scrollView.frame)-Hi_ScrollViewBottomMargin,CGRectGetWidth(self.bounds),Hi_ScrollViewBottomMargin)];
        [_pageControl setPageIndicatorTintColor:[UIColor lightGrayColor]];
        [_pageControl setCurrentPageIndicatorTintColor:[UIColor orangeColor]];
        _pageControl.numberOfPages = self.dataArray.count;
        _pageControl.currentPage   = 0;
    }
    return  _pageControl;
}
#pragma mark  scrollView Delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int page = scrollView.contentOffset.x/self.bounds.size.width;
    _pageControl.currentPage = page;
    
}
#pragma mark -block

//- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event
//{
//    UIView* result = [super hitTest:point withEvent:event];
//    
//    if ([result.superview isKindOfClass:[UIScrollView class]])
//    {
//        UIScrollView * scrollView=(UIScrollView*)result.superview;
//        scrollView.scrollEnabled = NO;
//    }
//    else
//    {    UIScrollView * scrollView=(UIScrollView*)result.superview;
//        scrollView.scrollEnabled = YES;
//    }
//    return result;
//}
//-(NSInteger)pages{
//    
//    NSInteger pages = 0;
//
//    if ([self.dataSource respondsToSelector:@selector(numOfScrollImageViewPages:)]) {
//        pages = [self.dataSource numOfScrollImageViewPages:self];
//    }else{
//        pages=self.pages;
//    }
//    
//    return pages;
//}

@end
