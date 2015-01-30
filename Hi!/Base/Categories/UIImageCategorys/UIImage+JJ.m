//
//  UIImage+JJ.m
//  易商
//
//  Created by 伍松和 on 14/10/23.
//  Copyright (c) 2014年 Ruifeng. All rights reserved.
//

#import "UIImage+JJ.h"
#import "UIImageView+AFNetworking.h"
@implementation UIImage (JJ)
#pragma mark 可以自由拉伸的图片

/**
 *  返回一张随意拉伸的图片
 *
 *  @param imgName 本地图片名字
 *
 *  @return UIImage对象
 */

+ (UIImage *)resizedImage:(NSString *)imgName
{
    //return [self resizedImage:imgName xPos:0.5 yPos:0.5];
    
    UIImage * img=[UIImage imageNamed:imgName];
    CGFloat width=img.size.width*0.5;
    CGFloat height=img.size.height*0.5;
    
    return [img resizableImageWithCapInsets:UIEdgeInsetsMake(height, width, height, width)];
    
}

+ (UIImage *)resizedImage:(NSString *)imgName xPos:(CGFloat)xPos yPos:(CGFloat)yPos
{
    UIImage *image = [UIImage imageNamed:imgName];
    return [image stretchableImageWithLeftCapWidth:image.size.width * xPos topCapHeight:image.size.height * yPos];
}

//+(UIImage *)resizedImage:(NSString *)imgName


#pragma mark -圆角



//获得屏幕图像
- (UIImage *)imageFromView: (UIView *) theView
{
    
    UIGraphicsBeginImageContext(theView.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [theView.layer renderInContext:context];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}

//获得某个范围内的屏幕图像

+(UIImage*)getSubImage:(UIImage*)superImage inFrame:(CGRect)frame

{
    
    CGImageRef imgRef = superImage.CGImage;
    
    CGImageRef subImgRef = CGImageCreateWithImageInRect(imgRef, frame);
    
    UIImage *subImage = [UIImage imageWithCGImage:subImgRef];
    
    
    
    return subImage;
}

- (UIImage *)imageFromView: (UIView *) theView   atFrame:(CGRect)r
{
    UIGraphicsBeginImageContext(theView.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    UIRectClip(r);
    [theView.layer renderInContext:context];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return  theImage;//[self getImageAreaFromImage:theImage atFrame:r];
}


- (UIImage *)addImage:(UIImage *)image1 toImage:(UIImage *)image2 {
    UIGraphicsBeginImageContext(image1.size);
    
    // Draw image1
    [image1 drawInRect:CGRectMake(0, 0, image1.size.width, image1.size.height)];
    
    // Draw image2
    [image2 drawInRect:CGRectMake(0, 0, image2.size.width, image2.size.height)];
    
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return resultingImage;
}
#pragma mark 画文字

+ (UIImage*)drawTextWithStroke:(NSString*)string {
    
    // set rect, size, font
    
    CGRect rect = CGRectMake(10, 10, 40, 40);
    CGSize size = CGSizeMake(rect.size.width, rect.size.height);
    UIFont *font = [UIFont systemFontOfSize:18];
    
    // retina display, double resolution
    
    if ([UIScreen instancesRespondToSelector:@selector(scale)] && [[UIScreen mainScreen] scale] == 2.0f) {
        UIGraphicsBeginImageContextWithOptions(size, NO, 2.0f);
    } else {
        UIGraphicsBeginImageContext(size);
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // draw stroke
    
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextSetLineWidth(context,0.5);
    CGContextSetTextDrawingMode(context, kCGTextStroke);
    NSDictionary *att = @{NSFontAttributeName:font};
    [string drawInRect:rect withAttributes:att];
    
    // draw fill
    
    CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextSetTextDrawingMode(context, kCGTextFill);
    [string drawInRect:rect withAttributes:att];
    
    // convert to image and return
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
    
}

+(UIImage*) drawText:(NSString*) text
             inImage:(UIImage*)  image
             atPoint:(CGPoint)   point
{
    
    UIFont *font = [UIFont boldSystemFontOfSize:12];
    UIGraphicsBeginImageContext(image.size);
    [image drawInRect:CGRectMake(0,0,image.size.width,image.size.height)];
    CGRect rect = CGRectMake(point.x, point.y, image.size.width, image.size.height);
    [[UIColor whiteColor] set];
    
    //iOS 7
    NSDictionary *att = @{NSFontAttributeName:font};
    [text drawInRect:rect withAttributes:att];
   // [text drawInRect:CGRectIntegral(rect) withFont:font];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}
#pragma mark -缓存
+ (UIImage *)decode:(UIImage *)image {
    if(image == nil) {
        return nil;
    }
    
    UIGraphicsBeginImageContext(image.size);
    
    {
        [image drawAtPoint:CGPointMake(0, 0)];
        image = UIGraphicsGetImageFromCurrentImageContext();
    }
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)fastImageWithData:(NSData *)data {
    UIImage *image = [UIImage imageWithData:data];
    return [self decode:image];
}

+ (UIImage *)fastImageWithContentsOfFile:(NSString *)path {
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:path];
    return [self decode:image];
}
@end
