
typedef NS_ENUM(NSInteger, BaseInputControllerType) {
    
    BaseInputControllerTypeNone,
    BaseInputControllerTypeResgister,
    BaseInputControllerTypeVerify,
    BaseInputControllerTypeLogin,
    
};
#import "BaseSettingTableController.h"
#import "JDStatusBarNotification.h"
#import "Hi_AccountTool.h"

typedef void(^FooterBlock)(id sender);
@interface Hi_BaseInputController : BaseSettingTableController
@property (nonatomic,assign)BaseInputControllerType input_controllerType;
@property(nonatomic,copy)   NSString * phoneNum;
@property(nonatomic,copy)   NSString * passwordNum;
@property(nonatomic,strong) UIButton * leftButton;
@property(nonatomic,strong) UIButton * rightButton;
@property(nonatomic,strong) UIButton * bottomButton;
@property(nonatomic,strong) UITextView * bottomTextView;
@property(nonatomic,strong) UIView * bottomView;


-(void)dismiss;

/**
 *  底部控件
 *
 *  @param isButton    是否有按钮
 *  @param buttonTitle 按钮 title
 *  @param isText      是否有文字
 *  @param footerBlock 点击回调
 *
 *  @return 底部控件
 */
-(UIView*)get_bottomViewButton:(BOOL)isButton
                   buttonTitle:(NSString*)buttonTitle
                        isText:(BOOL)isText
                   footerBlock:(FooterBlock)footerBlock;


/**
 *  自定义富文本
 *
 *  @return 1.注册 2.登录 3.验证
 */
- (NSMutableAttributedString*)deal_attributedText;
/**
 *  点击了富文本的字段
 */
- (NSUInteger)deal_attributedText_tap:(UITapGestureRecognizer *)recognizer;
#pragma mark -底部提示语句
/**
 *  点击后动画
 */
-(void)button_start_animation_text:(NSString*)loading_text
                                  btn:(UIButton*)sender;
-(void)button_stop_animation_text:(NSString*)origin_text
                                 btn:(UIButton*)sender;

@end
