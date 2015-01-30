//
//  WeChatTool.h
//  Meimei
//
//  Created by namebryant on 14-7-16.
//  Copyright (c) 2014年 Meimei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"
#import "Singleton.h"

@interface JJWeChatTool : NSObject<WXApiDelegate>
{
    enum WXScene _scene;
}

single_interface(JJWeChatTool)

- (void) changeScene:(int)scene;
//- (void) sendTextContent:(NSString*)text;
- (void) sendImageContent:(UIImage*)image
               thumbImage:(UIImage*)thumbImage;
//发送链接
- (void) sendLinkContentUrl:(NSString*)url
                   Title:(NSString*)title
                     des:(NSString*)des
                   image:(UIImage*)image;

- (void) sendMusicContentUrl:(NSString*)url
                       Title:(NSString*)title
                         des:(NSString*)des
                       image:(UIImage*)image;

- (void) sendVideoContentUrl:(NSString*)url
                       Title:(NSString*)title
                         des:(NSString*)des
                       image:(UIImage*)image;


- (void) sendAppContentUrl:(NSString*)url
                     Title:(NSString*)title
                       des:(NSString*)des
                     image:(UIImage*)image
                   extInfo:(NSString*)extInfo;

- (void) sendGifContentUrl:(NSString*)url
                     Title:(NSString*)title
                       des:(NSString*)des
                     image:(UIImage*)image;

- (void) sendFileContentUrl:(NSString*)url
                      Title:(NSString*)title
                        des:(NSString*)des
                      image:(UIImage*)image;
@end
