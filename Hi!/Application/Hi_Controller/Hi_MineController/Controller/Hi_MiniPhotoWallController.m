//
//  Hi_MiniPhotoWallController.m
//  hihi
//
//  Created by 伍松和 on 14/12/29.
//  Copyright (c) 2014年 伍松和. All rights reserved.
//

#import "Hi_MiniPhotoWallController.h"
#import "UIButton+WebCache.h"
//#import "UIButton+A"
#import "PhotoPickerTool.h"
#import "UIWindow+JJ.h"
#import "Hi_AccountTool.h"
#import "Hi_UserTool.h"
#import "MJPhotoBrowser.h"
@interface Hi_MiniPhotoWallController ()
@property (nonatomic,strong)PhotoPickerTool * photoPickerTool;
@property (nonatomic,strong)UIButton *curButton;
@property (nonatomic,strong)Hi_Account * account;
@property (nonatomic,strong)NSArray * photos;
@end
/**
 *    // 2.显示相册
 
 */
@implementation Hi_MiniPhotoWallController

-(NSArray*)user_imgs_array:(Hi_UserModel*)userModel{
    
    NSMutableArray * array_urls=[NSMutableArray array];
    //1.
    [array_urls addObject:userModel.head];
    
    //2.3.4
    if (userModel.photos) {
        [userModel.photos enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSDictionary * dic = obj;
            [array_urls addObject:dic[@"url"]];
        }];
    }
    
    
    return array_urls;
    
    
}
-(void)setup{

        self.account=[Hi_AccountTool getCurrentAccount];
    if (self.account.photos.count>0) {
        self.photos=self.account.photos;
    }else{
        self.photos= @[self.account.Head];
        [self.rightBtn showActivityOverView:self.rightBtn.bounds WithStyle:UIActivityIndicatorViewStyleWhite];
        [Hi_UserTool getMemberWithUID:MY_UID success:^(id result) {
            if (result) {
                Hi_UserModel * userModel = result;
                self.account.photos=[self user_imgs_array:userModel];
                self.photos=self.account.photos;
                [Hi_AccountTool saveCurrentAccount:self.account];
            }
            [self.rightBtn hideActivityOverView:@"完成"];
        } failure:^(NSError *error) {
            [self.rightBtn hideActivityOverView:@"完成"];
        }];
    }
    
    
    
    
    
    
    
   
}
- (IBAction)viewMyPhotoWall:(id)sender {
    
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    NSMutableArray * photos=[NSMutableArray array];
    if (!self.photos.count) {
        UIWINDOW_FAILURE(@"上传你的美照吧")
        return;
    }
    for (int i = 0; i<self.photos.count;i++) {
        // 替换为中等尺寸图片
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.srcImageView= self.oneBtn.imageView;
        photo.url = [NSURL URLWithString:self.photos[i]]; // 图片路径
        [photos addObject:photo];
    }

    
    browser.photos = photos; // 设置所有的图片
    [browser show];
}
-(void)setPhotos:(NSArray *)photos{
    
    
    WEAKSELF;
    [photos enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString * urlStr= obj;
        UIButton * button = (UIButton*)[weakSelf.view viewWithTag:idx];
      //  [button.imageView sd_setImageWithURL:[NSURL URLWithString:urlStr]  placeholderImage:[UIImage imageNamed:@"person_add_image"]];
        button.imageView.contentMode=UIViewContentModeScaleAspectFill;
        button.imageView.layer.cornerRadius=10;
        button.imageView.layer.borderColor=[[UIColor blackColor]CGColor];
        button.imageView.layer.borderWidth=0.5;
        button.imageView.layer.masksToBounds=YES;
        
        [button sd_setImageWithURL:[NSURL URLWithString:urlStr] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"person_add_image"]];
        
    }];
}

#pragma mark -视图启动
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"照片墙";
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTitle:@"完成" themeColor:[UIColor whiteColor] target:self action:@selector(dismiss)];
    self.rightBtn=self.navigationItem.rightBarButtonItem.barButton;
    
    self.photoPickerTool=[PhotoPickerTool sharedPhotoPickerTool];
    [self setup];
}
-(void)dismiss{[self.navigationController popViewControllerAnimated:YES];}
- (IBAction)btnAction:(id)sender {
    
    //1.选择
    self.curButton=sender;
    [self changeImgView];
    
}
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
//    UIImage * originImg= self.curButton.imageView.image;
   
    //2.换上新的
    [UIWindow showWithHUDStatus:@"正在上传..."];
    
    NSString * key = (_curButton.tag==0)?@"head":@"photo";
    
   [Hi_AccountTool upLoadPhoto:tempImage location:(int)_curButton.tag imageKey:key Success:^(id result) {
       if (result) {
           UIWINDOW_STATE_SHOW(@"成功上传");
           [self.curButton sd_setImageWithURL:[NSURL URLWithString:result] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"person_add_image"]];
           [self saveToAccount:_curButton.tag url:result image:tempImage];
           
           
       }else{
           UIWINDOW_FAILURE(@"上传失败");
//
       }
       
   } failure:^(NSError *error) {
       UIWINDOW_FAILURE(@"上传失败");
       
//
   
   }];
}
-(void)saveToAccount:(NSInteger)tag
               url:(NSString*)url
               image:(UIImage*)image{
    
    //1.存储
    NSMutableArray * arrayM =[NSMutableArray arrayWithArray:self.account.photos];
    if (arrayM.count>tag+1) {
        [arrayM replaceObjectAtIndex:tag withObject:url];
    }else{
        [arrayM addObject:url];
    }
    self.account.photos=arrayM;
    //2.
    if (tag==0) {
        self.account.image=image;
        self.account.Head=url;
    }
    
    [Hi_AccountTool saveCurrentAccount:self.account];
    

}
#pragma mark -图片处理
- (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
    
}


@end
