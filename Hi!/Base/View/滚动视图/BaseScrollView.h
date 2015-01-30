
#import <UIKit/UIKit.h>

@interface BaseScrollView : UIView
///滚动视图
@property (nonatomic,strong)UIScrollView * scrollView;

///下标
@property(nonatomic,strong)UIPageControl * pageControl;

///URLs
@property(nonatomic,strong)NSArray * URLS;
@end
