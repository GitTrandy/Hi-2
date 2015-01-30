//
//  UIImage+JJ.h
//  易商
//
//  Created by 伍松和 on 14/10/23.
//  Copyright (c) 2014年 Ruifeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImage+XHRounded.h"
#import "UIImageView+WebCache.h"

@interface UIImage (JJ)
/**
 *  可以自由拉伸的图片
 */
+ (UIImage *)resizedImage:(NSString *)imgName;
#pragma mark 可以自由拉伸的图片
+ (UIImage *)resizedImage:(NSString *)imgName xPos:(CGFloat)xPos yPos:(CGFloat)yPos;

#pragma mark -得到截图
- (UIImage *)imageFromView: (UIView *) theView;
- (UIImage *)imageFromView: (UIView *) theView   atFrame:(CGRect)r;
+(UIImage*)getSubImage:(UIImage*)superImage inFrame:(CGRect)frame;

#pragma mark -缓存
+ (UIImage *)fastImageWithData:(NSData *)data;
+ (UIImage *)fastImageWithContentsOfFile:(NSString *)path;
+(UIImage*) drawText:(NSString*)text
             inImage:(UIImage*)image
             atPoint:(CGPoint)point;
+ (UIImage*)drawTextWithStroke:(NSString*)string;
@end
