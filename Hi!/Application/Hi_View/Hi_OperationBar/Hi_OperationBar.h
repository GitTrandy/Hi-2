

#import "BaseOperationView.h"
#define HI_IMAGE_SET_URL            [[NSBundle mainBundle]URLForResource:@"Hi_OperationBar" withExtension:@"plist"]
#define HI_IMAGE_SET_INFO           [NSDictionary dictionaryWithContentsOfURL:HI_IMAGE_SET_URL]

#define HI_IMAGE_SHOP_DETAIL_ARRAY  HI_IMAGE_SET_INFO[@"Hi_Shop_Detail_Bar"]
#define HI_IMAGE_SOCIAL_SHARE_ARRAY  HI_IMAGE_SET_INFO[@"Hi_Social_Share_Bar"]

@interface Hi_OperationBar : BaseOperationView

@end
