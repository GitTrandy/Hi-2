

#import "UIViewController+JJ.h"
#define iPhone5 ([UIScreen mainScreen].bounds.size.height == 568)
#define IOS7 ([[[UIDevice currentDevice]systemVersion] floatValue] >= 7.0)
#define IOS8 ([[[UIDevice currentDevice]systemVersion] floatValue] >= 8.0)


@implementation UIViewController (JJ)

-(void)showAlertViewWithTitle:(NSString*)title
                  detailTitle:(NSString*)detailTitle
                  cancelTitle:(NSString*)cancelTitle
                   otherTitle:(NSArray*)otherTitles
               alertViewBlock:(AlertViewBlock)alertViewBlock{

    
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:detailTitle preferredStyle:UIAlertControllerStyleAlert];
    
    //1.取消按钮
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        if (alertViewBlock) {
            alertViewBlock(alertController,0);
        }
    }];
    [alertController addAction:cancelAction];

    //2.其他按钮
    [otherTitles enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        NSString * otherTitle =obj;
        UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherTitle  style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            if (alertViewBlock) {
                alertViewBlock(alertController,idx+1);
            }
        }];
        
        [alertController addAction:otherAction];
    }];
   
   
    
    // Add the actions.
    
    if (IOS8) {
        [self presentViewController:alertController animated:YES completion:nil];
    
    }else{
        
        
       
    
    }

}

@end
