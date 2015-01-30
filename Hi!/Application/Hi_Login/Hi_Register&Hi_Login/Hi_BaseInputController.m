
#import "Hi_BaseInputController.h"

@interface Hi_BaseInputController ()

@end

@implementation Hi_BaseInputController

- (void)viewDidLoad {
    [super viewDidLoad];
}
/**
 *  返回
 */
-(void)dismiss{[self.navigationController popViewControllerAnimated:YES];}
#pragma mark -下一步
-(void)footerButtonAction:(UIButton*)sender {[self.view endEditing:YES];}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{ return 15;}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{return 80;}
-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{return NO;}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{return 48;}
-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
    
}
#pragma mark - 底部视图
-(UIView *)bottomView{
    
    if (!_bottomView) {
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 0)];
    }
    return _bottomView;
    
}
-(UIView*)get_bottomViewButton:(BOOL)isButton
                   buttonTitle:(NSString*)buttonTitle
                        isText:(BOOL)isText
                   footerBlock:(FooterBlock)footerBlock{
    
    CGFloat height = 0;
    if (isButton) {
        [self.bottomView addSubview:[self get_bottomButtonTitle:buttonTitle backImage:@"green_bg" footerBlock:footerBlock]];
        height+=self.bottomButton.height;
        self.bottomButton.enabled=NO;
    }
    if (isText) {
        [self.bottomView addSubview:self.bottomTextView];
        height+=self.bottomTextView.height;
        
    }
    self.bottomView.height=height;
    return self.bottomView;
}

#pragma mark -底部字符串处理

-(UITextView *)bottomTextView{
    
    if (!_bottomTextView) {
        UITextView * textView =[[UITextView alloc]initWithFrame:CGRectMake(0, self.bottomButton.bottom, self.view.width-20, 60)];
        textView.editable=NO;textView.selectable=NO;
        textView.backgroundColor = [UIColor clearColor];
        textView.attributedText=[self deal_attributedText];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(deal_attributedText_tap:)];
        textView.userInteractionEnabled=YES;
        [textView addGestureRecognizer:tap];
        _bottomTextView=textView;
        
    }
    return _bottomTextView;
    
    
}
#define BOTTOM_BUTTON_X_MARGIN 7
#define BOTTOM_BUTTON_HEIGHT 50
-(UIButton *)get_bottomButtonTitle:(NSString *)title
                         backImage:(NSString*)backImageName
                       footerBlock:(FooterBlock)footerBlock{
    
    if (!_bottomButton) {
        UIButton *logoutButton = [[UIButton alloc] initWithFrame:CGRectMake(BOTTOM_BUTTON_X_MARGIN, 10, self.view.width-2*BOTTOM_BUTTON_X_MARGIN, 50)];
        [logoutButton setBackgroundImage:[UIImage resizedImage:backImageName] forState:UIControlStateNormal];
        [logoutButton setBackgroundImage:[UIImage resizedImage:backImageName] forState:UIControlStateHighlighted];
        
        //根据类型设置字体
        [logoutButton setTitle:title forState:UIControlStateNormal];
        logoutButton.titleLabel.font = [UIFont systemFontOfSize:17];
        [logoutButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [logoutButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        
        [logoutButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            if (footerBlock) {
                footerBlock(sender);
            }
        }];
        
        
        _bottomButton=logoutButton;
    }
    return _bottomButton;
}


// 注册即表示同意 <易商协议>,如帐号无法注册或者登录，请检测你的网络或者联系我们:es.wisdomeng.com/aboutMe.html
#pragma mark -文档
#define RESGITER_STATE @[\
@"    注册即表示同意",\
@{@"title":@"《开心果用户协议》",@"attributes":@"account_guide"},\
@"如帐号无法注册或者登录，请检测你的网络或者联系我们:",\
@{@"title":@"peter@wisdomeng.com",@"attributes":@"email_guide"}]

#define LOGIN_STATE @[@"    如帐号无法注册或者登录，请检测你的网络或者联系我们", @{@"title":@"peter@wisdomeng.com",@"attributes":@"email_guide"}]
#define VERIFY_STATE @[@"   如帐号无法注册或者登录，请检测你的网络或者联系我们",@{@"title":@"peter@wisdomeng.com",@"attributes":@"email_guide"}]

-(NSMutableAttributedString*)deal_attributedText{
    
    switch (self.input_controllerType) {
        case BaseInputControllerTypeNone:
        {
            break;
        }
        case BaseInputControllerTypeResgister:
        {
            return [self deal_attributedTextArray:RESGITER_STATE];
            break;
        }
        case BaseInputControllerTypeVerify:
        {
            return [self deal_attributedTextArray:VERIFY_STATE];
            break;
        }
        case BaseInputControllerTypeLogin:
        {
            return [self deal_attributedTextArray:LOGIN_STATE];
            break;
        }
            
            
        default:
            break;
    }
    return nil;
}

-(NSMutableAttributedString*)deal_attributedTextArray:(NSArray*)array{
    
    //1.UI
    NSMutableAttributedString * sss=[[NSMutableAttributedString alloc]init];
    
    
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            
            NSDictionary * dic =(NSDictionary*)obj;
            NSMutableAttributedString *attrSecond = [[NSMutableAttributedString alloc] initWithString:dic[@"title"] attributes:@{dic[@"attributes"]:dic[@"attributes"]}];
            [attrSecond addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(0, attrSecond.length)];
            [sss appendAttributedString:attrSecond];
            
        }else{
            
            NSMutableAttributedString *attrOne = [[NSMutableAttributedString alloc] initWithString:(NSString*)obj];
            [attrOne addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0, attrOne.length)];
            [sss appendAttributedString:attrOne];
            
        }
    }];
    
    [sss addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, sss.length)];
    return sss;
    
}

#pragma mark -点击
- (NSUInteger)deal_attributedText_tap:(UITapGestureRecognizer *)recognizer
{
    
    UITextView *textView = (UITextView *)recognizer.view;
    
    // Location of the tap in text-container coordinates
    
    NSLayoutManager *layoutManager = textView.layoutManager;
    CGPoint location = [recognizer locationInView:textView];
    location.x -= textView.textContainerInset.left;
    location.y -= textView.textContainerInset.top;
    
    // Find the character that's been tapped on
    
    NSUInteger characterIndex;
    characterIndex = [layoutManager characterIndexForPoint:location
                                           inTextContainer:textView.textContainer
                  fractionOfDistanceBetweenInsertionPoints:NULL];
    
    return characterIndex;
    
}


#pragma mark -点击后动画
-(void)button_start_animation_text:(NSString*)loading_text
                                  btn:(UIButton*)sender{
    
    sender.enabled=NO;
    [sender setTitle:loading_text forState:UIControlStateDisabled];
    [sender setImage:[UIImage imageNamed:@"tt_1"] forState:UIControlStateDisabled];
    NSMutableArray * imgArray = [NSMutableArray array];
    for (int i =0; i<7; i++) {
        NSString * imgName = [NSString stringWithFormat:@"tt_%d",i+1];
        UIImage * img = [UIImage imageNamed:imgName];
        [imgArray addObject:img];
    }
    sender.imageView.animationImages=imgArray;
    [sender.imageView setAnimationDuration:0.5];
    [sender.imageView startAnimating];
    
}
#pragma mark -停止动画
-(void)button_stop_animation_text:(NSString*)origin_text
                                 btn:(UIButton*)sender{
    
    [sender.imageView stopAnimating];
    [sender setTitle:origin_text forState:UIControlStateDisabled];
    [sender setImage:nil forState:UIControlStateDisabled];
    sender.enabled=YES;
    
    
}

@end
