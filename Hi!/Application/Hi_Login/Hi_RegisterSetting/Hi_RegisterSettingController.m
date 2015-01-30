

#import "Hi_RegisterSettingController.h"
#import "Hi_RootControllerTool.h"
#import "PhotoPickerTool.h"
#import "UIWindow+JJ.h"

@interface Hi_RegisterSettingController ()
@property (nonatomic,strong)PhotoPickerTool * photoPickerTool;
@end

@implementation Hi_RegisterSettingController

- (void)viewDidLoad {
    
    
    self.account=[Hi_AccountTool getCurrentAccount];
    [super viewDidLoad];
    self.title=@"完善资料";
//

    _photoPickerTool =[PhotoPickerTool sharedPhotoPickerTool];

    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTitle:@"确认资料" themeColor:[UIColor whiteColor] target:self action: @selector(rightAction:)];
}
-(void)viewWillAppear:(BOOL)animated{
}
-(void)rightAction:(UIButton *)button{

    NSLog(@"%@..",self.account.image.accessibilityIdentifier);
    self.account = [Hi_AccountTool getCurrentAccount];
    if (!self.account.Head) {
        UIWINDOW_FAILURE(@"头像空空如也,不太好吧~~")
        return;
    }
    if ([self.account.NickName isEqualToString:AccountTIP]||[self.account.NickName isEqualToString:@"1"]) {
        UIWINDOW_FAILURE(@"做个无名氏真的好吗?");
        return;

    }
    
    [[Hi_RootControllerTool sharedHi_RootControllerTool]chooseRootController:Hi_RootControllerHelperStyleMain];

}



-(void)setupGroup0{
   
    BaseSettingItem *item0=[BaseSettingItem itemWithTitle:@"头像" avatorImage:self.account.image option:nil];
    BaseSettingItem *item1=[BaseSettingItem itemWithIcon:nil title:@"昵称" subTitle:self.account.NickName settingItemSytle:BaseSettingItemSytleArrow option:nil];
    BaseSettingItem *item2 =  [BaseSettingItem itemWithIcon:nil title:@"性别" subTitle:self.account.Sex settingItemSytle:BaseSettingItemSytleArrow option:nil];
    BaseSettingItem *item3 =  [BaseSettingItem itemWithIcon:nil title:@"生日" subTitle:self.account.Birthday settingItemSytle:BaseSettingItemSytleArrow option:nil];
   
    
    BaseSettingGroup *group = [BaseSettingGroup group];
    group.items=@[item0,item1,item2,item3];
    self.tableView.rowHeight=50;
    
    self.groups[0]=group;
    

}
//
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    
//    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
//
//}

#pragma mark -头像
-(void)changeImgView{
    
    UIActionSheet * actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"相册", nil];
    
    [actionSheet showInView:self.view withCompletionHandler:^(NSInteger buttonIndex) {
        if (buttonIndex==0) {
            [_photoPickerTool showOnPickerViewControllerSourceType:UIImagePickerControllerSourceTypeCamera onViewController:self compled:^(UIImage *image, NSDictionary *editingInfo) {
                
                [self dealWithImage:image info:editingInfo];
            }];
        }else if (buttonIndex==1){
            [_photoPickerTool showOnPickerViewControllerSourceType:UIImagePickerControllerSourceTypePhotoLibrary onViewController:self compled:^(UIImage *image, NSDictionary *editingInfo) {
                [self dealWithImage:image info:editingInfo];
                
            }];
            
        }
    }];
    

    
}
#pragma mark-UIImagePickerControllerDelegate
-(void)dealWithImage:(UIImage*)image
                info:(NSDictionary*)info{
    
    [self imageWithImageSimple:image scaledToSize:CGSizeMake(90, 90)];
    //名字
    int y = (arc4random() % 501) + 500;
    NSString *name =[NSString stringWithFormat:@"%d",y];
    [self saveImage:image WithName:name];
    // [self dismissViewControllerAnimated:YES completion:NULL];
    
    
}


- (void)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName
{
    if (!tempImage) {
        return;
    }
    [self upLoadImage:tempImage];
    
    
}
#pragma mark -上传图片
-(void)upLoadImage:(UIImage*)tempImage{
    //1.原来的
    UIImage * originImg= self.account.image;
    //2.换上新的
    BaseSettingCell * cell=(BaseSettingCell*)[self.tableView cellForRowAtIndexPath:self.curIndexPath];
    cell.item.avatorImage=tempImage;
    [self.tableView reloadRowsAtIndexPaths:@[self.curIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [UIWindow showWithHUDStatus:@"正在上传..."];
    [Hi_AccountTool upLoadPhoto:tempImage location:0 imageKey:@"head" Success:^(id result) {
        if (result) {
            self.account.image=tempImage;
            self.account.Head=result;
            [Hi_AccountTool saveCurrentAccount:self.account];
            cell.item.avatorImage=tempImage;
            UIWINDOW_SUCCESS(@"上传成功...");
        }else{
            UIWINDOW_FAILURE(@"上传失败...");
            cell.item.avatorImage=originImg;
            [self.tableView reloadRowsAtIndexPaths:@[self.curIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            
        }
    } failure:^(NSError *error) {
        UIWINDOW_FAILURE(@"上传失败...");
        cell.item.avatorImage=originImg;
        [self.tableView reloadRowsAtIndexPaths:@[self.curIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        //        [self.tableView reloadRowsAtIndexPaths:@[_curIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }];
    
    
    
}

- (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
    
}

#pragma mark -高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BaseSettingGroup *group = self.groups[indexPath.section];
    BaseSettingItem *item = group.items[indexPath.row];
    
    if (item.settingItemSytle==BaseSettingItemSytleAvator) {
        return 100;
    }
    return 50;
}


@end
