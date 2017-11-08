//
//  NSString+Category.h
//  Pandora
//
//  Created by Albert Lee on 12/25/13.
//  Copyright (c) 2013 Albert Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import <UIKit/UIKit.h>
#import "MHPrettyDate/MHPrettyDate.h"
@interface NSString (ALExtension)
+ (NSString*)timeString:(NSTimeInterval)time;
+ (NSString*)timeString:(NSString *)unixTime format:(MHPrettyDateFormat)format;
+ (NSString*)time:(NSTimeInterval)unixTime format:(MHPrettyDateFormat)format;
+ (NSString *)stringByMD5Encoding:(NSString*)inputString;
+ (NSString *)stringByDecodingURLFormat:(NSString*)inputString;
+ (NSString *)stringByEncodingURLFormat:(NSString*)inputString;
+ (NSString *)pathByCacheDirection:(NSString*)customCacheDirectionName;
- (BOOL)containsTraditionalChinese;
- (NSString *)trimWhitespace;
- (NSNumber *)numberValue;
- (NSData *)UTF8Data;
- (NSArray *)getAtNames;
+ (BOOL)stringContainsEmoji:(NSString *)string;
+ (NSString *)timeCountStringByTime:(NSTimeInterval)time;
- (NSString *)convertSingleQuote;
#pragma mark Base64 Related
+ (NSString*)stringWithBase64EncodedString:(NSString *)string;
- (NSString*)base64EncodedStringWithWrapWidth:(NSUInteger)wrapWidth;
- (NSString*)base64EncodedString;
- (NSString*)base64DecodedString;
- (NSData  *)base64DecodedData;
#pragma mark MD5 Related
- (NSString *)MD5;
+ (NSString *)lineStringByLength:(CGFloat)length font:(CGFloat)fontSize;
#pragma mark 字数判断
+ (int)convertToInt:(NSString*)strtemp;
+ (NSString *)stringWithLimitedChineseCharacter:(NSInteger)length string:(NSString*)strtemp;

- (CGSize)sizeWithAttributes:(NSDictionary *)attrs constrainedToSize:(CGSize)size;
- (CGSize)sizeWithAttributes:(NSDictionary *)attrs constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)mode;
@end
