typedef NS_ENUM(NSInteger, JJShareActionType){
    
    
    JJShareActionTypeSMS =0,
    JJShareActionTypeWeChat ,
    JJShareActionTypeWeChatTimeline  ,
    JJShareActionTypeSina ,
    JJShareActionTypeQQ  ,
    JJShareActionTypeQQZone  ,
    JJShareActionTypeEmail  ,
    
    JJShareActionTypeCopy  ,
};
#import <Foundation/Foundation.h>

@interface Hi_ShareTool : NSObject
+(void)ShareActionDidClickOnButtonIndex:(NSInteger)buttonIndex
                                      url:(NSString*)aUrl
                                    image:(UIImage*)aImage
                                    title:(NSString*)aTitle
                                 desTitle:(NSString*)aDesTitle
                                     ctrl:(UIViewController*)ctrl;

//+(void)shareShortSMS:(NSArray*)sends
//                 url:(NSString*)url
//                ctrl:(UIViewController*)ctrl;
@end
