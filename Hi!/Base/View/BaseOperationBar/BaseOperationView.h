

#import "BaseOperationButton.h"
typedef void(^OperationBtnActionBlock)(id button,NSInteger buttonTag);

///把3，4，8，9宫格的，通过一个类来统一处理
@interface BaseOperationView : UIView

@property (nonatomic,strong)UIImageView * bottomImageView;
@property (nonatomic,strong)NSArray * operationBarArray;
@property (nonatomic,strong)NSArray * operationButtons;
@property (copy, nonatomic)OperationBtnActionBlock operationBtnActionBlock;
@property (nonatomic,strong)BaseOperationButton * baseOperationButton;

-(void)addActionBlock:(OperationBtnActionBlock)operationBtnActionBlock;


///创建一列的普通按钮，单一颜色，font 默认14
-(instancetype)initWithFrame:(CGRect)frame
        operationBarDicArray:(NSArray*)operationBarDicArray
                  titleColor:(UIColor*)titleColor
          ButtonPositionType:(ButtonPositionType)type;
///创建一列的普通按钮，单一颜色，font自定义
-(instancetype)initWithFrame:(CGRect)frame
        operationBarDicArray:(NSArray*)operationBarDicArray
                  titleColor:(UIColor*)titleColor
                        font:(UIFont*)font
          ButtonPositionType:(ButtonPositionType)type;


///创建一列的普通按钮，两种颜色，font 默认14
-(instancetype)initWithFrame:(CGRect)frame
        operationBarDicArray:(NSArray*)operationBarDicArray
                  titleColor:(UIColor*)titleColor
          selectedTitleColor:(UIColor*)selectedTitleColor
          ButtonPositionType:(ButtonPositionType)type;

///创建一列的普通按钮，两种颜色， 两种font
-(instancetype)initWithFrame:(CGRect)frame
        operationBarDicArray:(NSArray*)operationBarDicArray
                  titleColor:(UIColor*)titleColor
          selectedTitleColor:(UIColor*)selectedTitleColor
                        font:(UIFont*)font
          ButtonPositionType:(ButtonPositionType)type;




///创建一列的普通按钮，两种颜色， 两种font,
/*
    1.num代表需要多少个作一行，如4个一行
    2.传入数组有20个，num=4，就是有5行
 
 */

-(instancetype)initWithFrame:(CGRect)frame
        operationBarDicArray:(NSArray*)operationBarDicArray
                  titleColor:(UIColor*)titleColor
          selectedTitleColor:(UIColor*)selectedTitleColor
                        font:(UIFont*)font
          ButtonPositionType:(ButtonPositionType)type
                 nextRowForm:(NSInteger)num;

@end
