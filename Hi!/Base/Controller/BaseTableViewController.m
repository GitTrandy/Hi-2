



#import "BaseTableViewController.h"
@interface BaseTableViewController ()

@end
@implementation BaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //0.
    
    
    
    [self.view addSubview:self.tableView];
    //默认不行
    self.isRefreshControlBottom=NO;
    self.searchController.delegate=self;

    
   

}
#pragma mark -是否需要搜索
-(void)setIsShowSearch:(BOOL)isShowSearch{
    _isShowSearch=isShowSearch;
    if (self.isShowSearch) {
         self.navigationItem.leftBarButtonItem=[UIBarButtonItem itemWithIcon:@"tabbar_discover_os7" highlightedIcon:@"tabbar_discover_os7" target:self action:@selector(searchAction)];
    }
}
-(void)searchAction{
    
//        self.searchBar.frame=CGRectMake(0, 20, self.view.width, 44.0f);
//        [self.searchBar becomeFirstResponder];
    

}
-(void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller
{
    
//    self.searchBar.frame=CGRectMake(0, -44, self.view.width, 44.0f);
//    [self.searchBar resignFirstResponder];

}

#pragma mark -搜索拦

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{

    
}
#pragma mark -搜索拦控制器
- (UISearchDisplayController *)searchController
{
    if (!_searchController) {
        _searchController = [[UISearchDisplayController alloc]initWithSearchBar:self.searchBar contentsController:self];
        _searchController.searchResultsDataSource = self;
        _searchController.searchResultsDelegate = self;
        _searchController.searchResultsTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    }
    return _searchController;
}

#pragma mark -是否需要底部刷新
-(void)setIsRefreshControlBottom:(BOOL)isRefreshControlBottom{
    _isRefreshControlBottom=isRefreshControlBottom;
    if (_isRefreshControlBottom==YES) {
        [self bottomActivityIndicatorView];
    }else{
        //
    }
}
-(UIActivityIndicatorView *)bottomActivityIndicatorView{

    if (!_bottomActivityIndicatorView) {
        //烽火
        UIActivityIndicatorView* spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        spinner.tintColor=[UIColor orangeColor];
        [spinner stopAnimating];
        spinner.hidesWhenStopped = YES;
        spinner.frame = CGRectMake(0, 0, 320, 44);
        self.tableView.tableFooterView = spinner;
        _bottomActivityIndicatorView=spinner;
    }
    
    return _bottomActivityIndicatorView;

}
- (void)scrollViewDidEndDragging:(UIScrollView *)aScrollView
                  willDecelerate:(BOOL)decelerate{
    
    if (_isRefreshControlBottom) {
        CGPoint offset = aScrollView.contentOffset;
        CGRect bounds = aScrollView.bounds;
        CGSize size = aScrollView.contentSize;
        UIEdgeInsets inset = aScrollView.contentInset;
        float y = offset.y + bounds.size.height - inset.bottom;
        float h = size.height;
        
        float reload_distance = 50;
        if(y > h + reload_distance) {
            
            _bottomActivityIndicatorView.hidden=NO;
            [_bottomActivityIndicatorView startAnimating];
            [self loadBottomData];
        }

    }
}
-(void)loadBottomData{
    [_bottomActivityIndicatorView startAnimating];
  
}

-(UIRefreshControl *)refreshControl{

    if (!_refreshControl) {
        _refreshControl = [[UIRefreshControl alloc] initWithFrame:CGRectMake(0.0f, 0.0f, ScreenWidth, 50.0f)];
        _refreshControl.tintColor = [UIColor orangeColor];
        self.refreshControl.backgroundColor = [UIColor whiteColor];
        [_refreshControl addTarget:self action:@selector(loadMoreData) forControlEvents:UIControlEventValueChanged];
    }
    return _refreshControl;
    
}
#pragma mark -UI控件
- (UITableView *)tableView {
    if (!_tableView) {
      //  CGRect tableViewFrame = self.view.bounds;
      
        UITableView * tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:_tableViewStyle];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.delegate = self;
        tableView.dataSource = self;
      //  [tableView addHeaderWithTarget:self action:@selector(loadMoreData)];
        tableView.tintColor=[UIColor orangeColor];

        _tableView=tableView;


    }
    return _tableView;
}

-(void)setTableViewStyle:(UITableViewStyle)tableViewStyle{
    
    _tableViewStyle=tableViewStyle;
    [self tableView];

}
#pragma mark -数据源
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] initWithCapacity:1];
    }
    return _dataSource;
}
-(MutableOrderedDictionary *)sectionDictionary{

    if (!_sectionDictionary) {
        _sectionDictionary=[[MutableOrderedDictionary alloc]initWithCapacity:0];
    }
    return _sectionDictionary;
}

#pragma mark - UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([tableView isEqual:self.searchController.searchResultsTableView]) {
        return self.searchResult.count;
    }
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // in subClass
    return nil;
}

#pragma mark -构建Cell（根据数据）
-(id)configureCellWithClass:(Class)cellClass
                 WithCellID:(NSString*)CellIdentifier
              WithTableView:(UITableView*)tableView{
    
    
    //NIB万岁
 
    return nil;
}
-(void)loadFirstData{}
-(void)loadLocalData{}
-(void)loadOldData{}
-(void)loadMoreData{}
-(void)reloadTableData{

    
    if (self.dataSource.count>0||self.sectionDictionary.count>0) {
        [self.tableView reloadData];
    }
//  [self.tableView reloadData];
    [self.tableView hideActivityOverView];
    [self.tableView headerEndRefreshing];
//    if ([JDStatusBarNotification isVisible]) {
//         [JDStatusBarNotification dismiss];
//    }
  
    

}

#pragma mark -多选,单选,取消
-(void)addOperationBar{}
#define kBarHeight 45

-(void)buttonAction:(NSInteger)btnTag{
    
    switch (btnTag) {
        case 0:
            [self mutliAction];
            break;
        case 1:
            [self cancelMutliAction];
            break;
        case 2:
            [self cancelAction];
            break;
            
        default:
            break;
    }
    
}
-(void)cancelAction{[self dismissViewControllerAnimated:YES completion:nil];}
-(void)mutliAction{
    
    for (NSInteger s = 0; s < self.tableView.numberOfSections; s++) {
        for (NSInteger r = 0; r < [self.tableView numberOfRowsInSection:s]; r++) {
            [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:r inSection:s]
                                        animated:NO
                                  scrollPosition:UITableViewScrollPositionNone];
        }
    }
    
    [self.rightBtn setTitle:[NSString stringWithFormat:@"发送(%d)",(int)self.tableView.indexPathsForSelectedRows.count] forState:UIControlStateNormal];
    
    
}
-(void)cancelMutliAction{
    
    for (NSInteger s = 0; s < self.tableView.numberOfSections; s++) {
        for (NSInteger r = 0; r < [self.tableView numberOfRowsInSection:s]; r++) {
            
            [self.tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:r inSection:s] animated:YES];
            
        }
    }
    
    [self.rightBtn setTitle:@"发送(0)" forState:UIControlStateNormal];    
}
#pragma mark -代理
#pragma mark -EDIT
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return YES;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView.editing==YES) {
        NSArray * array=[self.tableView indexPathsForSelectedRows];
        [self.rightBtn setTitle:[NSString stringWithFormat:@"发送(%d)",(int)array.count] forState:UIControlStateNormal];
        return;
    }
}
@end
