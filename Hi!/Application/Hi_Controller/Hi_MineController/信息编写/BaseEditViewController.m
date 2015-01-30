

#import "BaseEditViewController.h"
@interface BaseEditViewController ()

@end

@implementation BaseEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem=[UIBarButtonItem itemWithTitle:@"完成" themeColor:[UIColor whiteColor] target:self action:@selector(rightBtnAction:)];

}

@end
