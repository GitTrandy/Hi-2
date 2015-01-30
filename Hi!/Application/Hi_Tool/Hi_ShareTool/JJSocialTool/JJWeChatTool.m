//
//  WeChatTool.m
//  Meimei
//
//  Created by namebryant on 14-7-16.
//  Copyright (c) 2014年 Meimei. All rights reserved.
//

#import "JJWeChatTool.h"

@implementation JJWeChatTool

single_implementation(JJWeChatTool)
-(void) changeScene:(int)scene
{
    _scene = scene;
}
- (void) sendTextContent
{
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.text = @"人文的东西并不是体现在你看得到的方面，它更多的体现在你看不到的那些方面，它会影响每一个功能，这才是最本质的。但是，对这点可能很多人没有思考过，以为人文的东西就是我们搞一个很小清新的图片什么的。”综合来看，人文的东西其实是贯穿整个产品的脉络，或者说是它的灵魂所在。";
    req.bText = YES;
    req.scene = _scene;
    
    [WXApi sendReq:req];
}

-(void) RespTextContent
{
    GetMessageFromWXResp* resp = [[GetMessageFromWXResp alloc] init];
    resp.text = @"人文的东西并不是体现在你看得到的方面，它更多的体现在你看不到的那些方面，它会影响每一个功能，这才是最本质的。但是，对这点可能很多人没有思考过，以为人文的东西就是我们搞一个很小清新的图片什么的。”综合来看，人文的东西其实是贯穿整个产品的脉络，或者说是它的灵魂所在。";
    resp.bText = YES;
    
    [WXApi sendResp:resp];
}

- (void) sendImageContent:(UIImage*)image
               thumbImage:(UIImage*)thumbImage
{
    WXMediaMessage *message = [WXMediaMessage message];
    [message setThumbImage:thumbImage];
     WXImageObject *ext = [WXImageObject object];
    ext.imageData = UIImageJPEGRepresentation(image, 1);

    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = _scene;
    
    [WXApi sendReq:req];
}

- (void) RespImageContent
{
   
}

- (void) sendLinkContentUrl:(NSString*)url
                      Title:(NSString*)title
                        des:(NSString*)des
                      image:(UIImage*)image
{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title =title;
    message.description = des;
    [message setThumbImage:image];
    
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = url;
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
   req.scene = _scene;
//    
   [WXApi sendReq:req];
}

-(void) RespLinkContent
{
//    WXMediaMessage *message = [WXMediaMessage message];
//    message.title = @"专访张小龙：产品之上的世界观";
//    message.description = @"微信的平台化发展方向是否真的会让这个原本简洁的产品变得臃肿？在国际化发展方向上，微信面临的问题真的是文化差异壁垒吗？腾讯高级副总裁、微信产品负责人张小龙给出了自己的回复。";
//    [message setThumbImage:[UIImage imageNamed:@"res2"]];
//    
//    WXWebpageObject *ext = [WXWebpageObject object];
//    ext.webpageUrl = @"http://tech.qq.com/zt2012/tmtdecode/252.htm";
//    
//    message.mediaObject = ext;
//    
//    GetMessageFromWXResp* resp = [[GetMessageFromWXResp alloc] init];
//    resp.message = message;
//    resp.bText = NO;
//    
//    [WXApi sendResp:resp];
}

-(void) sendMusicContentUrl:(NSString*)url
                      Title:(NSString*)title
                        des:(NSString*)des
                      image:(UIImage*)image
{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = title;
    message.description = des;
    [message setThumbImage:image];
    WXMusicObject *ext = [WXMusicObject object];
    ext.musicUrl = url;
    ext.musicDataUrl = url;
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = _scene;
    
    [WXApi sendReq:req];
}

-(void) RespMusicContent
{
//    WXMediaMessage *message = [WXMediaMessage message];
//    message.title = @"一无所有";
//    message.description = @"崔健";
//    [message setThumbImage:[UIImage imageNamed:@"res3.jpg"]];
//    WXMusicObject *ext = [WXMusicObject object];
//    ext.musicUrl = @"http://y.qq.com/i/song.html#p=7B22736F6E675F4E616D65223A22E4B880E697A0E68980E69C89222C22736F6E675F5761704C69766555524C223A22687474703A2F2F74736D7573696334382E74632E71712E636F6D2F586B30305156342F4141414130414141414E5430577532394D7A59344D7A63774D4C6735586A4C517747335A50676F47443864704151526643473444442F4E653765776B617A733D2F31303130333334372E6D34613F7569643D3233343734363930373526616D703B63743D3026616D703B636869643D30222C22736F6E675F5769666955524C223A22687474703A2F2F73747265616D31342E71716D757369632E71712E636F6D2F33303130333334372E6D7033222C226E657454797065223A2277696669222C22736F6E675F416C62756D223A22E4B880E697A0E68980E69C89222C22736F6E675F4944223A3130333334372C22736F6E675F54797065223A312C22736F6E675F53696E676572223A22E5B494E581A5222C22736F6E675F576170446F776E4C6F616455524C223A22687474703A2F2F74736D757369633132382E74632E71712E636F6D2F586C464E4D313574414141416A41414141477A4C36445039536A457A525467304E7A38774E446E752B6473483833344843756B5041576B6D48316C4A434E626F4D34394E4E7A754450444A647A7A45304F513D3D2F33303130333334372E6D70333F7569643D3233343734363930373526616D703B63743D3026616D703B636869643D3026616D703B73747265616D5F706F733D35227D";
//    ext.musicDataUrl = @"http://stream20.qqmusic.qq.com/32464723.mp3";
//    
//    message.mediaObject = ext;
//    
//    GetMessageFromWXResp* resp = [[GetMessageFromWXResp alloc] init];
//    resp.message = message;
//    resp.bText = NO;
//    
//    [WXApi sendResp:resp];
}

-(void) sendVideoContentUrl:(NSString*)url
                      Title:(NSString*)title
                        des:(NSString*)des
                      image:(UIImage*)image
{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = title;
    message.description = des;
    [message setThumbImage:image];//[UIImage imageNamed:@"res7.jpg"]];
    
    WXVideoObject *ext = [WXVideoObject object];
    ext.videoUrl = url;
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = _scene;
    
    [WXApi sendReq:req];
}

-(void) RespVideoContent
{
//    WXMediaMessage *message = [WXMediaMessage message];
//    message.title = @"楚门的世界";
//    message.description = @"一样的监牢，不一样的门";
//    [message setThumbImage:[UIImage imageNamed:@"res4.jpg"]];
//    
//    WXVideoObject *ext = [WXVideoObject object];
//    ext.videoUrl = @"http://video.sina.com.cn/v/b/65203474-2472729284.html";
//    
//    message.mediaObject = ext;
//    
//    GetMessageFromWXResp* resp = [[GetMessageFromWXResp alloc]init];
//    resp.message = message;
//    resp.bText = NO;
//    
//    [WXApi sendResp:resp];
}


///微信这里要深究
#define BUFFER_SIZE 1024 * 100
- (void) sendAppContentUrl:(NSString*)url
                     Title:(NSString*)title
                       des:(NSString*)des
                     image:(UIImage*)image
                   extInfo:(NSString*)extInfo
{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = title;
    message.description = des;
    [message setThumbImage:image];
    
    WXAppExtendObject *ext = [WXAppExtendObject object];
    ext.extInfo = extInfo;//@"<xml>extend ..info</xml>";
    ext.url = url;
    
    Byte* pBuffer = (Byte *)malloc(BUFFER_SIZE);
    memset(pBuffer, 0, BUFFER_SIZE);
    NSData* data = [NSData dataWithBytes:pBuffer length:BUFFER_SIZE];
    free(pBuffer);
    
    ext.fileData = data;
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = _scene;
    
    [WXApi sendReq:req];
}

-(void) RespAppContent
{
//    WXMediaMessage *message = [WXMediaMessage message];
//    message.title = @"App消息";
//    message.description = @"这种消息只有App自己才能理解，由App指定打开方式！";
//    [message setThumbImage:[UIImage imageNamed:@"res2.jpg"]];
//    
//    WXAppExtendObject *ext = [WXAppExtendObject object];
//    ext.extInfo = @"<xml>extend info</xml>";
//    ext.url = @"http://weixin.qq.com";
//    
//    Byte* pBuffer = (Byte *)malloc(BUFFER_SIZE);
//    memset(pBuffer, 0, BUFFER_SIZE);
//    NSData* data = [NSData dataWithBytes:pBuffer length:BUFFER_SIZE];
//    free(pBuffer);
//    
//    ext.fileData = data;
//    
//    message.mediaObject = ext;
//    
//    GetMessageFromWXResp* resp = [[GetMessageFromWXResp alloc] init];
//    resp.message = message;
//    resp.bText = NO;
//    
//    [WXApi sendResp:resp];
}




- (void) sendGifContentUrl:(NSString*)url
                     Title:(NSString*)title
                       des:(NSString*)des
                     image:(UIImage*)image
{
    WXMediaMessage *message = [WXMediaMessage message];
    [message setThumbImage:image];
    
    WXEmoticonObject *ext = [WXEmoticonObject object];
   // NSString *filePath = [[NSBundle mainBundle] pathForResource:@"res6" ofType:@"gif"];
    ext.emoticonData = UIImageJPEGRepresentation(image, 1.0);
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = _scene;
    
    [WXApi sendReq:req];
}

- (void)RespGifContent
{
//    WXMediaMessage *message = [WXMediaMessage message];
//    [message setThumbImage:[UIImage imageNamed:@"res6thumb.png"]];
//    WXEmoticonObject *ext = [WXEmoticonObject object];
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"res6" ofType:@"gif"];
//    ext.emoticonData = [NSData dataWithContentsOfFile:filePath] ;
//    message.mediaObject = ext;
//    
//    GetMessageFromWXResp* resp = [[GetMessageFromWXResp alloc] init];
//    resp.message = message;
//    resp.bText = NO;
//    
//    [WXApi sendResp:resp];
}

- (void) RespEmoticonContent
{
//    WXMediaMessage *message = [WXMediaMessage message];
//    [message setThumbImage:[UIImage imageNamed:@"res5thumb.png"]];
//    WXEmoticonObject *ext = [WXEmoticonObject object];
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"res5" ofType:@"jpg"];
//    ext.emoticonData = [NSData dataWithContentsOfFile:filePath];
//    message.mediaObject = ext;
//    
//    GetMessageFromWXResp* resp = [[GetMessageFromWXResp alloc] init];
//    resp.message = message;
//    resp.bText = NO;
//    
//    [WXApi sendResp:resp];
}

- (void)sendFileContentUrl:(NSString*)url
                     Title:(NSString*)title
                       des:(NSString*)des
                     image:(UIImage*)image
{
//    WXMediaMessage *message = [WXMediaMessage message];
//    message.title = @"ML.pdf";
//    message.description = @"Pro CoreData";
//    [message setThumbImage:[UIImage imageNamed:@"res2.jpg"]];
//    
//    WXFileObject *ext = [WXFileObject object];
//    ext.fileExtension = @"pdf";
//    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"ML" ofType:@"pdf"];
//    ext.fileData = [NSData dataWithContentsOfFile:filePath];
//    
//    message.mediaObject = ext;
//    
//    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
//    req.bText = NO;
//    req.message = message;
//    req.scene = _scene;
//    
//    [WXApi sendReq:req];
}

- (void)RespFileContent
{
//    WXMediaMessage *message = [WXMediaMessage message];
//    message.title = @"ML.pdf";
//    message.description = @"机器学习与人工智能学习资源导引";
//    [message setThumbImage:[UIImage imageNamed:@"res2.jpg"]];
//    
//    WXFileObject *ext = [WXFileObject object];
//    ext.fileExtension = @"pdf";
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"ML" ofType:@"pdf"];
//    ext.fileData = [NSData dataWithContentsOfFile:filePath];
//    
//    message.mediaObject = ext;
//    
//    GetMessageFromWXResp* resp = [[GetMessageFromWXResp alloc] init];
//    resp.message = message;
//    resp.bText = NO;
//    
//    [WXApi sendResp:resp];
}


@end
