//
//  +Ext.h
//  
//
//  Created by  on 15/4/22.
//  
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ImageMarkPosition) {
    ImageMarkPositionTopRightCorner    = 0,
    ImageMarkPositionTopLeftCorner     = 1,
    ImageMarkPositionBottomRightCorner = 2,
    ImageMarkPositionBottomLeftCorner  = 3,
};


@interface UIImage(Ext)

//按rect尺寸重绘
- (UIImage *)imageAtRect:(CGRect)rect;
//按比例缩放最小尺寸
- (UIImage *)imageByScalingProportionallyToMinimumSize:(CGSize)targetSize;
- (UIImage *)imageByScalingProportionallyToMaximumSize:(CGSize)targetSize;
//按比例缩放
- (UIImage *)imageByScalingProportionallyToSize:(CGSize)targetSize;
//图像缩放大小
- (UIImage *)imageByScalingToSize:(CGSize)targetSize;
//图像旋转弧度
- (UIImage *)imageRotatedByRadians:(CGFloat)radians;
//图像旋转度
- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees;
//图片重合
- (UIImage *)addImage:(UIImage *)image1 toImage:(UIImage *)image2;
//改变属性
- (UIImage *) imageWithBackgroundColor:(UIColor *)bgColor
                           shadeAlpha1:(CGFloat)alpha1
                           shadeAlpha2:(CGFloat)alpha2
                           shadeAlpha3:(CGFloat)alpha3
                           shadowColor:(UIColor *)shadowColor
                          shadowOffset:(CGSize)shadowOffset
                            shadowBlur:(CGFloat)shadowBlur;
//图像阴影颜色
- (UIImage *)imageWithShadowColor:(UIColor *)shadowColor
                     shadowOffset:(CGSize)shadowOffset
                       shadowBlur:(CGFloat)shadowBlur;
//图像透明度
- (UIImage *)imageByApplyingAlpha:(CGFloat)alpha;

+ (UIImage*)imageWithColor:(UIColor*)color size:(CGSize)size;
+ (UIImage*)imageWithRandomColorOfSize:(CGSize)size;
+ (UIImage *)imageWithLocalPathOfUrl:(NSString *)imageURL;

/**
 *  图片拉伸
 *
 *  @param imageName 需要拉伸的图片名
 *
 *  @return 返回一张已经拉伸好的图片
 */
+ (UIImage *)resizableImageWithName:(NSString *)imageName;

/**
 *  将图片(根据图片名)截取成圆形图片
 *
 *  @param imageName   需要截取图片的图片名
 *  @param borderWidth 图片边框大小
 *  @param borderColor 图片边框的颜色
 *
 *  @return 返回一张圆形图片
 */
+ (UIImage *)circleImageWithName:(NSString *)imageName borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;

/**
 *  将图片(根据图片)截取成圆形图片
 *
 *  @param image       需要截取图片
 *  @param borderWidth 图片边框大小
 *  @param borderColor 图片边框的颜色
 *
 *  @return 返回一张圆形图片
 */
+ (UIImage *)circleImageWithImage:(UIImage *)image borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;
/**
 *  自定义位置生成水印图片
 *
 *  @param bgName        背景图片名称
 *  @param markImageName 水印图片名称
 *  @param markPosition  自定义水印图片显示的位置
 *
 *  @return 返回一张水印图片(两张图片合并在一起的图片)
 */
+ (UIImage *)imageMarkWithBackgroundImageName:(NSString *)bgName markImageName:(NSString *)markImageName markPosition:(CGPoint)markPosition;

/**
 *  根据markPosition的传入值生成指定位置上的水印图片
 *
 *  @param bgName        背景图片名称
 *  @param markImageName 水印图片名称
 *  @param markPosition  水印图片显示的位置
 *  @param padding       指定水印图片距离边框的距离
 *
 *  @return 返回一张水印图片(两张图片合并在一起的图片)
 */
+ (UIImage *)imageMarkWithBackgroundImageName:(NSString *)bgName markImageName:(NSString *)markImageName markPosition:(ImageMarkPosition)markPosition padding:(CGFloat)padding;

/**
 *  自定义位置生成文字水印图片
 *
 *  @param bgName       背景图片名称
 *  @param markString   水印文字内容
 *  @param attrs        水印文字的属性
 *  @param rect         自定义水印图片显示的位置
 *
 *  @return 返回一张自定义位置的文字水印图片
 */
+ (UIImage *)imageMarkWithBackgroundImageName:(NSString *)bgName markString:(NSString *)markString attributes:(NSDictionary *)attrs markRect:(CGRect)rect;

/**
 *  根据传入的背景图片名,水印图片的名字和位置,水印文字的内容和位置生成一张合成图片
 *
 *  @param bgName        背景图片名称
 *  @param markImageName 水印图片的名称
 *  @param markPosition  水印图片的位置
 *  @param markString    水印文字的内容
 *  @param attrs         水印文字的属性
 *  @param rect          水印图片的位置
 *
 *  @return 返回一张合成水印图片和水印文字的图片
 */
+ (UIImage *)imageMarkWithBackgroundImageName:(NSString *)bgName markImageName:(NSString *)markImageName markPosition:(CGPoint)markPosition markString:(NSString *)markString attributes:(NSDictionary *)attrs markRect:(CGRect)rect;

/**
 *  Create an UIImage from a UIView
 *
 *  @param view The view you want to use
 *
 *  @return an UIImage from the used UIView
 */
+ (UIImage *) screenshotFromView:(UIView *)view;

/**
 *  Crop the UIImage inside a CGRect
 *
 *  @param cropRect the CGRect that define the crop bounds
 *
 *  @return the new UIImage
 */
- (UIImage *) croppedImage:(CGRect)cropRect;

/**
 *  Rotate the UIImgae to the right position
 *
 *  @return the rotated UIImage
 */
- (UIImage *) rotateUIImage;

/**
 *  Create an UIImage with round bounds
 *
 *  @param image  the UIImage you want to use
 *  @param size   the crop CGRect
 *  @param radius the radius value
 *
 *  @return the new UIImage
 */
+ (UIImage *) createRoundedRectImage:(UIImage *)image size:(CGSize)size roundRadius:(CGFloat)radius;

/**
 *  Resize an UIImage with a precise CGSize
 *
 *  @param img       the UIImage you want to use
 *  @param finalSize the new CGSize
 *
 *  @return the new UIImage
 */
+ (UIImage *) returnImage:(UIImage *)img withSize:(CGSize)finalSize;

- (NSData *)imageWithCompression:(CGFloat)compression;

@end
