
#import "Hi_ProfileController.h"
#import "Hi_AccountTool.h"
@interface Hi_ProfileController ()
@end
@implementation Hi_ProfileController


#pragma mark -视图周期


-(void)viewWillAppear:(BOOL)animated{
    
    if(![Hi_AccountTool getCurrentAccount]){
    }else{
        _account=[Hi_AccountTool getCurrentAccount];
    }
   
    
}
- (void)viewDidLoad
{
    
    [super viewDidLoad];
    self.tableView.backgroundColor=kColor(251, 251, 251);
    self.tableView.separatorColor=kColor(218, 218, 218);
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    _account=[Hi_AccountTool getCurrentAccount];
    
       

  
}

-(void)setupHeader{
    
    //2.
    

    _profileView = [Hi_ProfileView instancetypeWithXib];
    self.tableView.tableHeaderView=_profileView;
    
    
}
-(void)setupFooter{}
-(void)setupGroup1{}

#pragma mark -cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BaseSettingCell* cell=(BaseSettingCell*)[super tableView:tableView cellForRowAtIndexPath:indexPath];
    cell.bg.image =nil;
    cell.contentView.backgroundColor=[UIColor clearColor];
    return cell;
}

@end
