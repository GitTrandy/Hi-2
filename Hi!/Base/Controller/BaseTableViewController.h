#import "BaseViewController.h"
#import "MJRefresh.h"
#import "OrderedDictionary.h"



//屏幕高度
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#pragma mark - 判断是否ios7
#define IOS7 ([[[UIDevice currentDevice]systemVersion] floatValue] >= 7.0)


/**
 *  封装了若干属性,方法的UITableViewController
 0.基本的TableView,上下拉刷新
 1.封装了搜索栏
 2.等待加载指示
 3.
 
 */
@interface BaseTableViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource,UISearchDisplayDelegate,UISearchBarDelegate>


/**
 *  是否开启底部刷新
 */
@property (nonatomic, weak)   UIActivityIndicatorView *bottomActivityIndicatorView;
@property(nonatomic,assign)BOOL isRefreshControlBottom;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
/**
 *  第一次进入
 */
-(void)loadFirstData;
/**
 *  加载本地
 */
-(void)loadLocalData;
/**
 *  主动刷新网络
 */
-(void)loadMoreData;
/**
 *  刷新底部
 */
-(void)loadBottomData;
/**
 *  更改数据
 */
-(void)reloadTableData;


/**
 *  显示大量数据的控件
 */
@property (nonatomic, strong) UITableView *tableView;
/**
 *  初始化init的时候设置tableView的样式才有效
 */
@property (nonatomic, assign) UITableViewStyle tableViewStyle;

/**
 *  多个 key+ array
 */
@property (nonatomic, strong)MutableOrderedDictionary * sectionDictionary;
/**
 *  单个 key +array
 */
@property (nonatomic, strong) NSMutableArray *dataSource;
#pragma mark -搜索相关
/**
 *  是否要搜索
 */
@property (nonatomic ,assign)BOOL isShowSearch;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) NSArray *searchResult;
@property (nonatomic, strong) UISearchDisplayController *searchController;
-(void)searchAction;


#pragma mark -cell
-(id)configureCellWithClass:(Class)cellClass
                 WithCellID:(NSString*)CellIdentifier
              WithTableView:(UITableView*)tableView;
#pragma mark -多选,单选,取消
#define kBarHeight 45
-(void)addOperationBar;
-(void)cancelAction;
-(void)mutliAction;
-(void)cancelMutliAction;
@end
