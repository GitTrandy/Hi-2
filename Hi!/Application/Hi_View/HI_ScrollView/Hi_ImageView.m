#import "Hi_ImageView.h"
#import "UIImage+JJ.h"

@interface Hi_ImageView()<UIScrollViewDelegate>

@end

@implementation Hi_ImageView

-(instancetype)initWithFrame:(CGRect)frame
                  url_string:(NSString*)url_string
                       image:(NSString*)imageName{

    if (self=[super initWithFrame:frame]) {
        //1.加入 scroll_imageView
//        [self addSubview:self.scroll_imageView];
        UIImage * image =[UIImage imageNamed:imageName];
        [self sd_setImageWithURL:[NSURL URLWithString:url_string] placeholderImage:image];

    }
    
    return self;
}
//-(UIImageView *)imageView{
//
//    if (!_imageView) {
//        _imageView =[[UIImageView alloc]initWithFrame:self.bounds];
//        _imageView.contentMode=UIViewContentModeScaleAspectFill;
//    }
//    return _imageView;
//}
//-(UIScrollView *)scroll_imageView{
//
//    if (!_scroll_imageView) {
//        _scroll_imageView = [[UIScrollView alloc]initWithFrame:self.bounds];
//        _scroll_imageView.delegate=self;
//        [_scroll_imageView addSubview:self.imageView];
//
//    }
//    return _scroll_imageView;
//}
@end
