#define BaseUserDefaults [NSUserDefaults standardUserDefaults]
#define BaseSettingItemTitleFont @"BaseSettingItemTitleFont"
#define BaseSettingItemTitleColor @"BaseSettingItemTitleColor"

#define BaseSettingItemSubTitleFont @"BaseSettingItemSubTitleFont"
#define BaseSettingItemSubTitleColor @"BaseSettingItemSubTitleColor"


#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, BaseSettingItemSytle){

    BaseSettingItemSytleBasic=0, //基本类型
    BaseSettingItemSytleLabel, //label类型
    BaseSettingItemSytleArrow,//剪头
    BaseSettingItemSytleSwitch,//开关
    BaseSettingItemSytleAvator,//头像
    BaseSettingItemSytleCheck,//打勾
    BaseSettingItemSytleBadge,//数字
    BaseSettingItemSytleTextField,//输入框
    BaseSettingItemSytleOtherView,// 其他视图

};
typedef void (^BaseSettingItemOption)(id result);
typedef void (^BaseSettingItemTextDidChangeOption)(UITextField *textField);

/**
 *  设置Item对象模型,实际表现用cell来表示
 */
@interface BaseSettingItem : NSObject

/*
 样子 font,color等等
 
 组成如 @{@"BaseSettingItemSubTitleFont"=[UIFont xxx],
        @"BaseSettingItemSubTitleColor":[UIColor xxx]}
 */


@property(strong,nonatomic) NSDictionary * settingItemInfo;


///控件
@property (assign,nonatomic)NSInteger mineSettingType;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *subtitle;
@property (assign, nonatomic) CGSize subtitleSize;
@property (copy, nonatomic) NSString *icon;
@property (copy, nonatomic) NSString *badgeValue;
@property (assign,nonatomic)BaseSettingItemSytle settingItemSytle;
/**
 *  点击后的函数指针(block)
 */
@property (copy, nonatomic) BaseSettingItemOption option;
@property (copy, nonatomic) BaseSettingItemTextDidChangeOption baseSettingItemTextDidChangeOption ;

/**
 *  设置有输入框的cell
 *
 */
+ (instancetype)itemWithIcon:(NSString *)icon
                       title:(NSString *)title
                keyboardType:(UIKeyboardType)keyboardType
                    placeholder:(NSString*)placeholder
                    isSecure:(BOOL)isSecure
            isFirstResponser:(BOOL)isFirstResponser
                      option:(BaseSettingItemTextDidChangeOption)baseSettingItemTextDidChangeOption;



/**
 *  设置有开关,打勾的cell
    isOption(yes/no)
 */
+ (instancetype)itemWithIcon:(NSString *)icon
                       title:(NSString *)title
                    subTitle:(NSString*)subTitle
                      isOption:(BOOL)isOption
            settingItemSytle:(BaseSettingItemSytle)settingItemSytle
                      option:(BaseSettingItemOption)option;


///有其他视图的,如小红点,图片,其他
+ (instancetype)itemWithIcon:(NSString *)icon
                       title:(NSString *)title
                    subTitle:(NSString*)subTitle
                     otherView:(UIView*)otherView
            settingItemSytle:(BaseSettingItemSytle)settingItemSytle
                      option:(BaseSettingItemOption)option;

/**
 *  有图片有文字,子标题
 */
+ (instancetype)itemWithIcon:(NSString *)icon
                       title:(NSString *)title
                    subTitle:(NSString*)subTitle
            settingItemSytle:(BaseSettingItemSytle)settingItemSytle
                      option:(BaseSettingItemOption)option;


/**
 *  头像,简便方法
 */
+ (instancetype)itemWithTitle:(NSString *)title
                  avatorImage:(UIImage*)avatorImage
                       option:(BaseSettingItemOption)option;

+ (instancetype)item;


#pragma mark -7种以上类型

//其他视图
@property (strong,nonatomic)UIView * otherView;

//输入框
@property (assign,nonatomic,getter=isFirstResponser)BOOL firstResponser;
@property (assign,nonatomic)UIKeyboardType keyBoardType;
@property (copy,nonatomic)NSString* placeholder;
@property(nonatomic,getter=isSecure) BOOL secure;
// default is NO

//头像
@property (strong,nonatomic)UIImage *avatorImage;
@property (copy,nonatomic)NSString* avatorString;

//Label
@property (copy, nonatomic) NSString *text;
@property (copy, nonatomic) NSString *defaultText;
//打勾
@property (assign, nonatomic, getter = isChecked) BOOL checked;
//开关
@property (assign, nonatomic, getter = isOn) BOOL on;
@property (assign, nonatomic, getter = isDefaultOn) BOOL defaultOn;
@property (copy, nonatomic) NSString *key;

@end
