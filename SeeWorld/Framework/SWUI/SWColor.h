
#import <UIKit/UIKit.h>

@interface UIColor(Ext)

+ (UIImage *)imageWithColor:(UIColor *)color;
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;
+ (UIColor *)hexChangeFloat:(NSString *) hexColor;

@end
