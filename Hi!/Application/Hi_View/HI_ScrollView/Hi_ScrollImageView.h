

#import <UIKit/UIKit.h>
#import "Hi_ImageView.h"
typedef void(^tapImageAction) (id objectData);

@class Hi_ScrollImageView;
@protocol Hi_ScrollImageViewDataSource <NSObject>

@optional
//1.多少页
-(NSInteger)numOfScrollImageViewPages:(Hi_ScrollImageView*)ScrollImageView;

//2.什么视图
-(UIView*)ViewOfScrollImageViewPages:(Hi_ScrollImageView*)ScrollImageView
                                page:(NSInteger)page;

@end

@interface Hi_ScrollImageView : UIView

@property (weak,nonatomic)id<Hi_ScrollImageViewDataSource>dataSource;

@property (nonatomic ,strong)UIScrollView * scrollView;
@property (nonatomic ,strong)UIPageControl * pageControl;
@property (nonatomic ,strong)NSArray * dataArray;
- (id)initWithFrame:(CGRect)frame
              array:(NSArray*)dataArray;

/*
 点击
 */
@property (nonatomic,copy)tapImageAction action;
-(void)tapImageAction:(tapImageAction)action;
@end
