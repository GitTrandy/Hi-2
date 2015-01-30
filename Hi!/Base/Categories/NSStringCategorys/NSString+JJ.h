



#import <Foundation/Foundation.h>

@interface NSString (JJ)
/**
 *  MD5Hash
 */
- (NSString *)MD5Hash;
/**
 *  stringByTrimingWhitespace
 */
- (NSString *)stringByTrimingWhitespace;
/**
 *  行数
 */
- (NSUInteger)numberOfLines;
/**
 *  计算文章size
 */
- (CGSize)sizeWithFont:(UIFont*)font
              maxSize:(CGSize)maxSize;

- (NSString *)URLEncodedString;
- (NSString *)URLDecodedString;
- (NSString *)fileAppend:(NSString *)append;

@end
