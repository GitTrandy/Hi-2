#import "BaseOperationView.h"
#import "UIView+JJ.h"
@interface BaseOperationView ()

@end

@implementation BaseOperationView
#pragma mark -直接利用配置文件创建的


#pragma mark -公有方法
///创建一列的普通按钮，单一颜色，font 默认14
-(instancetype)initWithFrame:(CGRect)frame
        operationBarDicArray:(NSArray*)operationBarDicArray
                  titleColor:(UIColor*)titleColor
          ButtonPositionType:(ButtonPositionType)type{

       return [self initWithFrame:frame operationBarDicArray:operationBarDicArray titleColor:titleColor selectedTitleColor:nil font:nil  ButtonPositionType:type nextRowForm:-1];
}
///创建一列的普通按钮，单一颜色，font自定义
-(instancetype)initWithFrame:(CGRect)frame
        operationBarDicArray:(NSArray*)operationBarDicArray
                  titleColor:(UIColor*)titleColor
                        font:(UIFont*)font
          ButtonPositionType:(ButtonPositionType)type{

     return [self initWithFrame:frame operationBarDicArray:operationBarDicArray titleColor:titleColor selectedTitleColor:nil font:font ButtonPositionType:type nextRowForm:-1];
}


///创建一列的普通按钮，两种颜色，font 默认14
-(instancetype)initWithFrame:(CGRect)frame
        operationBarDicArray:(NSArray*)operationBarDicArray
                  titleColor:(UIColor*)titleColor
          selectedTitleColor:(UIColor*)selectedTitleColor
          ButtonPositionType:(ButtonPositionType)type{

      return [self initWithFrame:frame operationBarDicArray:operationBarDicArray titleColor:titleColor selectedTitleColor:selectedTitleColor font:nil  ButtonPositionType:type nextRowForm:-1];
}

///创建一列的普通按钮，两种颜色， 两种font
-(instancetype)initWithFrame:(CGRect)frame
        operationBarDicArray:(NSArray*)operationBarDicArray
                  titleColor:(UIColor*)titleColor
          selectedTitleColor:(UIColor*)selectedTitleColor
                        font:(UIFont*)font
          ButtonPositionType:(ButtonPositionType)type{

    return [self initWithFrame:frame operationBarDicArray:operationBarDicArray titleColor:titleColor selectedTitleColor:selectedTitleColor font:font  ButtonPositionType:type nextRowForm:-1];
}

-(instancetype)initWithFrame:(CGRect)frame
        operationBarDicArray:(NSArray*)operationBarDicArray
                  titleColor:(UIColor*)titleColor
          selectedTitleColor:(UIColor*)selectedTitleColor
                        font:(UIFont*)font
          ButtonPositionType:(ButtonPositionType)type
                 nextRowForm:(NSInteger)num{


    if (self=[super initWithFrame:frame]) {
        

        //1.底部图片
        _bottomImageView=[[UIImageView alloc]initWithFrame:self.bounds];
        _bottomImageView.userInteractionEnabled=YES;
        [self addSubview:_bottomImageView];
        
        self.operationBarArray=operationBarDicArray;
        NSMutableArray * buttonArrayM=[NSMutableArray array];
        [self.operationBarArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSDictionary * dicInfo=( NSDictionary *)obj;
            
            BaseOperationButton *btn = [[BaseOperationButton alloc]initWithFrame:CGRectZero ButtonPositionType:type];
            btn.imageView.contentMode=UIViewContentModeScaleToFill;
            
            
            //0.图片
            if (dicInfo[@"image"]) {
                NSString * normalImage = [NSString stringWithFormat:@"%@",dicInfo[@"image"]];
                [btn setImage:[UIImage imageNamed:normalImage]  forState:UIControlStateNormal];
            }
           
            if (dicInfo[@"selectedImage"]) {
                NSString * selectedImage = [NSString stringWithFormat:@"%@",dicInfo[@"selectedImage"]];
                [btn setImage:[UIImage imageNamed:selectedImage] forState:UIControlStateSelected];
                [btn setImage:[UIImage imageNamed:selectedImage] forState:UIControlStateHighlighted];
            }
        
            
            //1.标题
            if(dicInfo[@"title"]){
                [btn setTitle:dicInfo[@"title"] forState:UIControlStateNormal];
                [btn setTitleColor:titleColor forState:UIControlStateNormal];
                [btn setTitleColor:selectedTitleColor forState:UIControlStateHighlighted];
                [btn setTitleColor:selectedTitleColor forState:UIControlStateSelected];
                btn.titleLabel.font=font;

                
            }else{
            
                btn.imageView.y+=5;
            }
              //2.已经选择标题
            if(dicInfo[@"selectedTitle"]){
                [btn setTitle:dicInfo[@"selectedTitle"] forState:UIControlStateSelected];
                [btn setTitleColor:titleColor forState:UIControlStateNormal];
                [btn setTitleColor:selectedTitleColor forState:UIControlStateHighlighted];
                [btn setTitleColor:selectedTitleColor forState:UIControlStateSelected];
                btn.titleLabel.font=font;
                
                
            }
   
#pragma mark -WIDTH
            double _width = self.width / operationBarDicArray.count;

            if (num==-1) {
                //就是不分行
                btn.frame = CGRectMake(idx*_width,0, _width-0.5,self.height);
               

            }else{

                NSInteger rows = operationBarDicArray.count/num;//num=4.，总数12 ，三列
                CGFloat btnHeight =self.height/rows; //300,有3行，高度100
                CGFloat width = self.width/num;
//                btn.imageView.width=width-2;
//                btn.imageView.height=btnHeight;
                btn.backgroundColor=[UIColor yellowColor];

                if (idx>=num) {
                    btn.frame = CGRectMake((idx%num)*width,(idx/num)*btnHeight, width-5,btnHeight-5);
                  //  [self buttonPositionTypeBothCenter:btn];
                }else{
                    btn.frame = CGRectMake(idx*width,(idx/num)*btnHeight, width-5,btnHeight-5);

                }
          }
            
                
            
            
        
            [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = idx;
            [buttonArrayM addObject:btn];
            [_bottomImageView addSubview:btn];
            
        }];
        
        _operationButtons=buttonArrayM;
        
    }
    
    return self;




}
//-(void)buttonPositionTypeBothCenter:(BaseOperationButton*)btn{
//    //0.image
//    
//    btn.imageView.frame =CGRectMake(0, 0, 55, 55);
////    btn.imageView.center=CGPointMake(btn.bounds.size.width/2, btn.center.y-6);
//
//    
//    //1.title
//    CGRect frame = [btn titleLabel].frame;
//    frame.origin.x = 0;
//    frame.origin.y = btn.imageView.bottom + 2;
//    frame.size.width = btn.frame.size.width;
//    btn.titleLabel.frame = frame;
//    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
//    [btn.titleLabel setFont:[UIFont boldSystemFontOfSize:10.0f]];
//}



#pragma mark -动作
-(void)addActionBlock:(OperationBtnActionBlock)operationBtnActionBlock{

    self.operationBtnActionBlock=operationBtnActionBlock;
}
-(void)btnAction:(UIButton*)sender{
    
    if (self.operationBtnActionBlock) {
        self.operationBtnActionBlock(sender,sender.tag);
    }
    
}
-(void)dealloc{
    
    self.btnActionBlock=nil;
}


@end
