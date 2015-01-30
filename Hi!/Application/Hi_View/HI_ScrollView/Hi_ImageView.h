//
//  Hi_ImageView.h
//  hihi
//
//  Created by 伍松和 on 14/12/15.
//  Copyright (c) 2014年 伍松和. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Hi_ImageView : UIImageView

@property (nonatomic,strong)UIScrollView * scroll_imageView;
@property (nonatomic,strong)UIImageView * imageView;

@property (nonatomic,copy)  NSString * url_string;
@property (nonatomic,strong)UIImage * image;

-(instancetype)initWithFrame:(CGRect)frame
                  url_string:(NSString*)url_string
                       image:(NSString*)imageName;
@end
