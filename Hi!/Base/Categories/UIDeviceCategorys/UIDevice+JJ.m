

#import "UIDevice+JJ.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import "OpenUDID.h"
@implementation UIDevice (JJ)

+(UIColor*)colorExchangeByColorString:(NSString*)colorString{

    
    NSString * rbgs=colorString;
    NSArray *array=[rbgs componentsSeparatedByString:@","];
    
    CGColorSpaceRef RGBSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat RGBValue[array.count];
    for (int i=0; i<array.count; i++) {
        
        CGFloat params= 0;
        if ([[array objectAtIndex:i] floatValue]<=1) {
            params=[[array objectAtIndex:i] floatValue];
        }else{
            params=[[array objectAtIndex:i] floatValue]/255.0;
        }
        RGBValue[i] =params;
    }
    CGColorRef colorRGB = CGColorCreate(RGBSpace, RGBValue);
    CGColorSpaceRelease(RGBSpace);
   // NSLog(@"colorCMYK: %@", colorRGB);
    
    // color with CGColor, uicolor will just retain it
    UIColor *color = [UIColor colorWithCGColor:colorRGB];
    return color;

}

#pragma mark -获取 AVID(推送标识)
+(NSString*)getAVOSDeviceID{

    
    return MY_AVID;

}
//#pragma mark -获取设备 UDID
+ (NSString *)getDeviceUDID{

    return [OpenUDID value];
}
#pragma mark- 是否静音状态
+ (BOOL)isDeviceSilence{
    return YES;
}
#pragma mark -判断网络是否可行
//+ (BOOL)isNetWorkReachable{
//    
//    
//    AFNetworkReachabilityManager *afNetworkReachabilityManager = [AFNetworkReachabilityManager sharedManager];
//    [afNetworkReachabilityManager startMonitoring];  //开启网络监视器；
//    
//    [afNetworkReachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
//        
//        switch (status) {
//            case AFNetworkReachabilityStatusNotReachable:{
//                break;
//            }
//            case AFNetworkReachabilityStatusReachableViaWiFi:{
//                
//                break;
//            }
//                
//            case AFNetworkReachabilityStatusReachableViaWWAN:{
//                break;
//            }
//            default:
//                break;
//        }
//        
//        
//        
//    }];
//    
//    
//    return [AFNetworkReachabilityManager sharedManager].isReachable;
//}
#pragma mark -得到可爱的WifiMac地址

+(NSString*)getWifiMacAddress{
    
    
    NSString *macIp = @"";
    CFArrayRef myArray = CNCopySupportedInterfaces();
    if (myArray != nil) {
        CFDictionaryRef myDict = CNCopyCurrentNetworkInfo(CFArrayGetValueAtIndex(myArray, 0));
        if (myDict != nil) {
            NSDictionary *dict = (NSDictionary*)CFBridgingRelease(myDict);
            
            //  ssid = [dict valueForKey:@"SSID"];
            macIp = [dict valueForKey:@"BSSID"];
            
            
            NSArray * array= [macIp componentsSeparatedByString:@":"];
            NSMutableArray *strArray =[NSMutableArray array];
            for (NSString * s in array) {
                NSString *str=nil;
                if (s.length<2) {
                    str=[NSString stringWithFormat:@"0%@",s];
                }else{
                    str=s;
                }
                [strArray addObject:str];
            }//OK
            
            return [strArray componentsJoinedByString:@":"];
        }
    }
    
    return nil;
}
//    return macIp;



//    NSString *key = @"CFBundleVersion";
//
//    // 取出沙盒中存储的上次使用软件的版本号
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSString *lastVersion = [defaults stringForKey:key];
//
//    // 获得当前软件的版本号
//    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[key];
//    if ([currentVersion isEqualToString:lastVersion]) {
//        // 显示状态栏
//        [UIApplication sharedApplication].statusBarHidden = NO;
//        [UIApplication sharedApplication].keyWindow.rootViewController = [[IWTabBarViewController alloc] init];
//    } else { // 新版本
//        [UIApplication sharedApplication].keyWindow.rootViewController = [[IWNewfeatureViewController alloc] init];
//        // 存储新版本
//        [defaults setObject:currentVersion forKey:key];
//        [defaults synchronize];
//    }

@end
