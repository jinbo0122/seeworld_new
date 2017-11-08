
#import "SWColor.h"

#define kImageWidth  1
#define kImageHeight 1

@implementation UIColor(Ext)

+ (UIImage *)imageWithColor:(UIColor *)color {
    return [[self class] imageWithColor:color size:CGSizeMake(kImageWidth, kImageHeight)];
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(CGSizeMake(kImageWidth, kImageHeight));
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIColor *)hexChangeFloat:(NSString *) hexColor {
    unsigned int redInt_, greenInt_, blueInt_;
    NSRange rangeNSRange_;
    rangeNSRange_.length = 2;
    
    rangeNSRange_.location = 0;
    [[NSScanner scannerWithString:[hexColor substringWithRange:rangeNSRange_]]
     scanHexInt:&redInt_];
    
    rangeNSRange_.location = 2;
    [[NSScanner scannerWithString:[hexColor substringWithRange:rangeNSRange_]]
     scanHexInt:&greenInt_];
    
    rangeNSRange_.location = 4;
    [[NSScanner scannerWithString:[hexColor substringWithRange:rangeNSRange_]]
     scanHexInt:&blueInt_];
    
    return [UIColor colorWithRed:(float)(redInt_/255.0f)
                           green:(float)(greenInt_/255.0f)
                            blue:(float)(blueInt_/255.0f) 
                           alpha:1.0f];
}

@end
