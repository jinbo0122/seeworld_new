//
//  +Ext.m
//
//
//  Created by  on 15/4/22.
//
//

#import "UIImage+Ext.h"
#import "SDWebImageManager.h"

CGFloat DegreesToRadians(CGFloat degrees) {return degrees * M_PI / 180;};
CGFloat RadiansToDegrees(CGFloat radians) {return radians * 180/M_PI;};

@implementation UIImage(Ext)

-(UIImage *)imageAtRect:(CGRect)rect
{
  
  CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], rect);
  UIImage* subImage = [UIImage imageWithCGImage: imageRef];
  CGImageRelease(imageRef);
  
  return subImage;
  
}
- (UIImage *)imageByScalingProportionallyToMinimumSize:(CGSize)targetSize {
  
  UIImage *sourceImage = self;
  UIImage *newImage = nil;
  
  CGSize imageSize = sourceImage.size;
  CGFloat width = imageSize.width;
  CGFloat height = imageSize.height;
  
  CGFloat targetWidth = targetSize.width;
  CGFloat targetHeight = targetSize.height;
  
  CGFloat scaleFactor = 0.0;
  CGFloat scaledWidth = targetWidth;
  CGFloat scaledHeight = targetHeight;
  
  CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
  
  if (CGSizeEqualToSize(imageSize, targetSize) == NO) {
    
    CGFloat widthFactor = targetWidth / width;
    CGFloat heightFactor = targetHeight / height;
    
    if (widthFactor > heightFactor)
      scaleFactor = widthFactor;
    else
      scaleFactor = heightFactor;
    
    scaledWidth  = width * scaleFactor;
    scaledHeight = height * scaleFactor;
    
    // center the image
    
    if (widthFactor > heightFactor) {
      thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
    } else if (widthFactor < heightFactor) {
      thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
    }
  }
  
  
  // this is actually the interesting part:
  
  UIGraphicsBeginImageContext(targetSize);
  
  CGRect thumbnailRect = CGRectZero;
  thumbnailRect.origin = thumbnailPoint;
  thumbnailRect.size.width  = scaledWidth;
  thumbnailRect.size.height = scaledHeight;
  
  [sourceImage drawInRect:thumbnailRect];
  
  newImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  
  if(newImage == nil) NSLog(@"could not scale image");
  
  
  return newImage ;
}

- (UIImage *)imageByScalingProportionallyToMaximumSize:(CGSize)targetSize {
  
  UIImage *sourceImage = self;
  UIImage *newImage = nil;
  
  CGSize imageSize = sourceImage.size;
  CGFloat width = imageSize.width;
  CGFloat height = imageSize.height;
  
  CGFloat targetWidth = targetSize.width;
  CGFloat targetHeight = targetSize.height;
  
  CGFloat scaleFactor = 0.0;
  CGFloat scaledWidth = width;
  CGFloat scaledHeight = height;
  
  CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
  
  if (CGSizeEqualToSize(imageSize, targetSize) == NO) {
    
    if (targetWidth > width && targetHeight > height) {
    }
    else
    {
      CGFloat widthFactor = targetWidth / width;
      CGFloat heightFactor = targetHeight / height;
      
      if (widthFactor > heightFactor)
        scaleFactor = heightFactor;
      else
        scaleFactor = widthFactor;
      
      scaledWidth  = width * scaleFactor;
      scaledHeight = height * scaleFactor;
    }
  }
  
  
  CGRect thumbnailRect = CGRectZero;
  thumbnailRect.origin = thumbnailPoint;
  thumbnailRect.size.width  = scaledWidth;
  thumbnailRect.size.height = scaledHeight;
  
  UIGraphicsBeginImageContext(thumbnailRect.size);
  
  [sourceImage drawInRect:thumbnailRect];
  
  newImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  
  if(newImage == nil) NSLog(@"could not scale image");
  
  
  return newImage ;
}

- (UIImage *)imageByScalingProportionallyToSize:(CGSize)targetSize {
  
  UIImage *sourceImage = self;
  UIImage *newImage = nil;
  
  CGSize imageSize = sourceImage.size;
  CGFloat width = imageSize.width;
  CGFloat height = imageSize.height;
  
  CGFloat targetWidth = targetSize.width;
  CGFloat targetHeight = targetSize.height;
  
  CGFloat scaleFactor = 0.0;
  CGFloat scaledWidth = targetWidth;
  CGFloat scaledHeight = targetHeight;
  
  CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
  
  if (CGSizeEqualToSize(imageSize, targetSize) == NO) {
    
    CGFloat widthFactor = targetWidth / width;
    CGFloat heightFactor = targetHeight / height;
    
    if (widthFactor < heightFactor)
      scaleFactor = widthFactor;
    else
      scaleFactor = heightFactor;
    
    scaledWidth  = width * scaleFactor;
    scaledHeight = height * scaleFactor;
    
    // center the image
    
    if (widthFactor < heightFactor) {
      thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
    } else if (widthFactor > heightFactor) {
      thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
    }
  }
  
  
  // this is actually the interesting part:
  
  UIGraphicsBeginImageContext(targetSize);
  
  CGRect thumbnailRect = CGRectZero;
  thumbnailRect.origin = thumbnailPoint;
  thumbnailRect.size.width  = scaledWidth;
  thumbnailRect.size.height = scaledHeight;
  
  [sourceImage drawInRect:thumbnailRect];
  
  newImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  
  if(newImage == nil) NSLog(@"could not scale image");
  
  
  return newImage ;
}
- (UIImage *)imageByScalingToSize:(CGSize)targetSize {
  
  UIImage *sourceImage = self;
  UIImage *newImage = nil;
  
  //   CGSize imageSize = sourceImage.size;
  //   CGFloat width = imageSize.width;
  //   CGFloat height = imageSize.height;
  
  CGFloat targetWidth = targetSize.width;
  CGFloat targetHeight = targetSize.height;
  
  //   CGFloat scaleFactor = 0.0;
  CGFloat scaledWidth = targetWidth;
  CGFloat scaledHeight = targetHeight;
  
  CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
  
  // this is actually the interesting part:
  
  UIGraphicsBeginImageContext(targetSize);
  
  CGRect thumbnailRect = CGRectZero;
  thumbnailRect.origin = thumbnailPoint;
  thumbnailRect.size.width  = scaledWidth;
  thumbnailRect.size.height = scaledHeight;
  
  [sourceImage drawInRect:thumbnailRect];
  
  newImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  
  if(newImage == nil) NSLog(@"could not scale image");
  
  
  return newImage ;
}
- (UIImage *)imageRotatedByRadians:(CGFloat)radians
{
  return [self imageRotatedByDegrees:RadiansToDegrees(radians)];
}
- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees
{
  // calculate the size of the rotated view's containing box for our drawing space
  UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.size.width, self.size.height)];
  CGAffineTransform t = CGAffineTransformMakeRotation(DegreesToRadians(degrees));
  rotatedViewBox.transform = t;
  CGSize rotatedSize = rotatedViewBox.frame.size;
  
  // Create the bitmap context
  UIGraphicsBeginImageContext(rotatedSize);
  CGContextRef bitmap = UIGraphicsGetCurrentContext();
  
  // Move the origin to the middle of the image so we will rotate and scale around the center.
  CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
  
  //   // Rotate the image context
  CGContextRotateCTM(bitmap, DegreesToRadians(degrees));
  
  // Now, draw the rotated/scaled image into the context
  CGContextScaleCTM(bitmap, 1.0, -1.0);
  CGContextDrawImage(bitmap, CGRectMake(-self.size.width / 2, -self.size.height / 2, self.size.width, self.size.height), [self CGImage]);
  
  UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return newImage;
  
}

- (UIImage *)addImage:(UIImage *)image1 toImage:(UIImage *)image2 {
  UIGraphicsBeginImageContext(image2.size);
  
  // Draw image1
  [image1 drawInRect:CGRectMake(0, 0, image1.size.width, image1.size.height)];
  
  // Draw image2
  [image2 drawInRect:CGRectMake(0, 0, image2.size.width, image2.size.height)];
  
  UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return resultingImage;
}

- (UIImage *) imageWithBackgroundColor:(UIColor *)bgColor
                           shadeAlpha1:(CGFloat)alpha1
                           shadeAlpha2:(CGFloat)alpha2
                           shadeAlpha3:(CGFloat)alpha3
                           shadowColor:(UIColor *)shadowColor
                          shadowOffset:(CGSize)shadowOffset
                            shadowBlur:(CGFloat)shadowBlur {
  UIImage *image = self;
  CGColorRef cgColor = [bgColor CGColor];
  CGColorRef cgShadowColor = [shadowColor CGColor];
  CGFloat components[16] = {1,1,1,alpha1,1,1,1,alpha1,1,1,1,alpha2,1,1,1,alpha3};
  CGFloat locations[4] = {0,0.5,0.6,1};
  CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
  CGGradientRef colorGradient = CGGradientCreateWithColorComponents(colorSpace, components, locations, (size_t)4);
  CGRect contextRect;
  contextRect.origin.x = 0.0f;
  contextRect.origin.y = 0.0f;
  contextRect.size = [image size];
  //contextRect.size = CGSizeMake([image size].width+5,[image size].height+5);
  // Retrieve source image and begin image context
  UIImage *itemImage = image;
  CGSize itemImageSize = [itemImage size];
  CGPoint itemImagePosition;
  itemImagePosition.x = ceilf((contextRect.size.width - itemImageSize.width) / 2);
  itemImagePosition.y = ceilf((contextRect.size.height - itemImageSize.height) / 2);
  UIGraphicsBeginImageContext(contextRect.size);
  CGContextRef c = UIGraphicsGetCurrentContext();
  // Setup shadow
  CGContextSetShadowWithColor(c, shadowOffset, shadowBlur, cgShadowColor);
  // Setup transparency layer and clip to mask
  CGContextBeginTransparencyLayer(c, NULL);
  CGContextScaleCTM(c, 1.0, -1.0);
  CGContextClipToMask(c, CGRectMake(itemImagePosition.x, -itemImagePosition.y, itemImageSize.width, -itemImageSize.height), [itemImage CGImage]);
  // Fill and end the transparency layer
  CGContextSetFillColorWithColor(c, cgColor);
  contextRect.size.height = -contextRect.size.height;
  CGContextFillRect(c, contextRect);
  CGContextDrawLinearGradient(c, colorGradient,CGPointZero,CGPointMake(contextRect.size.width*1.0/4.0,contextRect.size.height),0);
  CGContextEndTransparencyLayer(c);
  //CGPointMake(contextRect.size.width*3.0/4.0, 0)
  // Set selected image and end context
  UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  CGColorSpaceRelease(colorSpace);
  CGGradientRelease(colorGradient);
  return resultImage;
}

- (UIImage *)imageWithShadowColor:(UIColor *)shadowColor
                     shadowOffset:(CGSize)shadowOffset
                       shadowBlur:(CGFloat)shadowBlur
{
  CGColorRef cgShadowColor = [shadowColor CGColor];
  CGColorSpaceRef colourSpace = CGColorSpaceCreateDeviceRGB();
  CGContextRef shadowContext = CGBitmapContextCreate(NULL, self.size.width, self.size.height,
                                                     CGImageGetBitsPerComponent(self.CGImage), 0,
                                                     colourSpace, kCGImageAlphaPremultipliedLast);
  CGColorSpaceRelease(colourSpace);
  
  // Setup shadow
  CGContextSetShadowWithColor(shadowContext, shadowOffset, shadowBlur, cgShadowColor);
  CGRect drawRect = CGRectMake(-shadowBlur, -shadowBlur, self.size.width + shadowBlur, self.size.height + shadowBlur);
  CGContextDrawImage(shadowContext, drawRect, self.CGImage);
  
  CGImageRef shadowedCGImage = CGBitmapContextCreateImage(shadowContext);
  CGContextRelease(shadowContext);
  
  UIImage * shadowedImage = [UIImage imageWithCGImage:shadowedCGImage];
  CGImageRelease(shadowedCGImage);
  
  return shadowedImage;
}

- (UIImage *)imageByApplyingAlpha:(CGFloat)alpha {
  UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
  
  CGContextRef ctx = UIGraphicsGetCurrentContext();
  CGRect area = CGRectMake(0, 0, self.size.width, self.size.height);
  
  CGContextScaleCTM(ctx, 1, -1);
  CGContextTranslateCTM(ctx, 0, -area.size.height);
  
  CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
  
  CGContextSetAlpha(ctx, alpha);
  
  CGContextDrawImage(ctx, area, self.CGImage);
  
  UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
  
  UIGraphicsEndImageContext();
  
  return newImage;
}

+ (UIImage*)imageWithColor:(UIColor*)color size:(CGSize)size {
  
  size_t bitsPerComponent = 8;
  size_t bytesPerPixel    = 4;
  size_t bytesPerRow      = (size.width * bitsPerComponent * bytesPerPixel + 7) / 8;
  size_t dataSize         = bytesPerRow * size.height;
  
  CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
  
  int *data = malloc(dataSize);
  memset(data, 0, dataSize);
  
  CGContextRef contextRef = CGBitmapContextCreate(data,
                                                  size.width,
                                                  size.height,
                                                  bitsPerComponent,
                                                  bytesPerRow, colorSpaceRef,
                                                  kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
  
  CGContextSetFillColorWithColor(contextRef, color.CGColor);
  
  CGContextFillRect(contextRef,
                    CGRectMake(
                               0,
                               0,
                               size.width,
                               size.height));
  
  CGColorSpaceRelease(colorSpaceRef);
  CGImageRef imageRef = CGBitmapContextCreateImage(contextRef);
  UIImage *image = [UIImage imageWithCGImage:imageRef];
  CGImageRelease(imageRef);
  CGContextRelease(contextRef);
  free(data);
  
  return image;
}

+ (UIImage*)imageWithRandomColorOfSize:(CGSize)size {
  UIColor *randomColor = [UIColor colorWithRed:drand48() green:drand48() blue:drand48() alpha:1.0];
  return [self imageWithColor:randomColor size:size];
}

-(UIImage *)imageFromText:(NSString *)text fontSize:(CGFloat)fontSize{
  // set the font type and size
  UIFont *font = [UIFont systemFontOfSize:fontSize];
  CGSize size  = [text sizeWithAttributes:@{NSFontAttributeName:font}];
  
  // check if UIGraphicsBeginImageContextWithOptions is available (iOS is 4.0+)
  UIGraphicsBeginImageContextWithOptions(size,NO,0.0);
  
  // optional: add a shadow, to avoid clipping the shadow you should make the context size bigger
  //
  // CGContextRef ctx = UIGraphicsGetCurrentContext();
  // CGContextSetShadowWithColor(ctx, CGSizeMake(1.0, 1.0), 5.0, [[UIColor grayColor] CGColor]);
  
  // draw in context, you can use also drawInRect:withFont:
  [text drawAtPoint:CGPointMake(0.0, 0.0) withAttributes:@{NSFontAttributeName:font}];
  
  // transfer image
  UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  
  return image;
}

+ (UIImage *)resizableImageWithName:(NSString *)imageName
{
  UIImage *oldImage = [UIImage imageNamed:imageName];
  CGFloat imageW = oldImage.size.width * 0.5;
  CGFloat imageH = oldImage.size.height * 0.5;
  UIImage *newImage = [oldImage resizableImageWithCapInsets:UIEdgeInsetsMake(imageH, imageW, imageH, imageW) resizingMode:UIImageResizingModeStretch];
  return newImage;
}

+ (UIImage *)circleImageWithName:(NSString *)imageName borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor
{
  UIImage *oldImage = [UIImage imageNamed:imageName];
  CGFloat imageW = oldImage.size.width + 2 * borderWidth;
  CGFloat imageH = oldImage.size.height + 2 * borderWidth;
  CGSize imageSize = CGSizeMake(imageW, imageH);
  UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.0);
  
  CGContextRef ctx = UIGraphicsGetCurrentContext();
  [borderColor set];
  
  CGFloat bigRadius = imageW * 0.5;
  CGFloat centerX = bigRadius;
  CGFloat centerY = bigRadius;
  CGContextAddArc(ctx, centerX, centerY, bigRadius, 0, M_PI * 2, 0);
  CGContextFillPath(ctx);
  
  CGFloat smallRadius = bigRadius - borderWidth;
  CGContextAddArc(ctx, centerX, centerY, smallRadius, 0, M_PI * 2, 0);
  CGContextClip(ctx);
  
  [oldImage drawInRect:CGRectMake(borderWidth, borderWidth, oldImage.size.width, oldImage.size.height)];
  UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  
  return newImage;
}

+ (UIImage *)circleImageWithImage:(UIImage *)image borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor
{
  CGFloat imageW = image.size.width + 2 * borderWidth;
  CGFloat imageH = image.size.height + 2 * borderWidth;
  CGSize imageSize = CGSizeMake(imageW, imageH);
  UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.0);
  
  CGContextRef ctx = UIGraphicsGetCurrentContext();
  [borderColor set];
  
  CGFloat bigRadius = imageW * 0.5;
  CGFloat centerX = bigRadius;
  CGFloat centerY = bigRadius;
  CGContextAddArc(ctx, centerX, centerY, bigRadius, 0, M_PI * 2, 0);
  CGContextFillPath(ctx);
  
  CGFloat smallRadius = bigRadius - borderWidth;
  CGContextAddArc(ctx, centerX, centerY, smallRadius, 0, M_PI * 2, 0);
  CGContextClip(ctx);
  
  [image drawInRect:CGRectMake(borderWidth, borderWidth, image.size.width, image.size.height)];
  UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  
  return newImage;
}

+ (UIImage *)imageMarkWithBackgroundImageName:(NSString *)bgName markImageName:(NSString *)markImageName markPosition:(CGPoint)markPosition
{
  UIImage *bgImage = [UIImage imageNamed:bgName];
  UIGraphicsBeginImageContextWithOptions(bgImage.size, NO, 0);
  [bgImage drawAtPoint:CGPointZero];
  
  UIImage *markImage = [UIImage imageNamed:markImageName];
  [markImage drawAtPoint:markPosition];
  
  return UIGraphicsGetImageFromCurrentImageContext();
}

+ (UIImage *)imageMarkWithBackgroundImageName:(NSString *)bgName markImageName:(NSString *)markImageName markPosition:(ImageMarkPosition)markPosition padding:(CGFloat)padding
{
  UIImage *bgImage = [UIImage imageNamed:bgName];
  UIGraphicsBeginImageContextWithOptions(bgImage.size, NO, 0);
  [bgImage drawAtPoint:CGPointZero];
  
  UIImage *markImage = [UIImage imageNamed:markImageName];
  CGFloat logoTopX = bgImage.size.width - markImage.size.width;
  CGFloat logoBottomY = bgImage.size.height - markImage.size.height;
  
  switch (markPosition) {
    case ImageMarkPositionTopRightCorner:
      [markImage drawAtPoint:CGPointMake(logoTopX - padding, 0)];
      break;
    case ImageMarkPositionTopLeftCorner:
      [markImage drawAtPoint:CGPointMake(0, 0)];
      break;
    case ImageMarkPositionBottomRightCorner:
      [markImage drawAtPoint:CGPointMake(logoTopX - padding, logoBottomY - padding)];
      break;
    case ImageMarkPositionBottomLeftCorner:
      [markImage drawAtPoint:CGPointMake(0, logoBottomY - padding)];
      break;
    default:
      break;
  }
  
  return UIGraphicsGetImageFromCurrentImageContext();
}

+ (UIImage *)imageMarkWithBackgroundImageName:(NSString *)bgName markString:(NSString *)markString attributes:(NSDictionary *)attrs markRect:(CGRect)rect
{
  UIImage *bgImage = [UIImage imageNamed:bgName];
  UIGraphicsBeginImageContextWithOptions(bgImage.size, NO, 0);
  [bgImage drawAtPoint:CGPointZero];
  [markString drawInRect:rect withAttributes:attrs];
  
  return UIGraphicsGetImageFromCurrentImageContext();
}

+ (UIImage *)imageMarkWithBackgroundImageName:(NSString *)bgName markImageName:(NSString *)markImageName markPosition:(CGPoint)markPosition markString:(NSString *)markString attributes:(NSDictionary *)attrs markRect:(CGRect)rect
{
  UIImage *bgImage = [UIImage imageNamed:bgName];
  UIGraphicsBeginImageContextWithOptions(bgImage.size, NO, 0);
  [bgImage drawAtPoint:CGPointZero];
  
  UIImage *markImage = [UIImage imageNamed:markImageName];
  [markImage drawAtPoint:markPosition];
  
  [markString drawInRect:rect withAttributes:attrs];
  
  return UIGraphicsGetImageFromCurrentImageContext();
}

+ (UIImage *) screenshotFromView:(UIView *)view
{
  CGFloat width = view.frame.size.width * 2.0f;
  CGFloat height = view.frame.size.height * 2.0f;
  UIGraphicsBeginImageContextWithOptions((CGSize){ width, height }, YES, 0.0);
  [view.layer renderInContext:UIGraphicsGetCurrentContext()];
  UIImage *fullScreenshot = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  
  return fullScreenshot;
}

- (UIImage *) croppedImage:(CGRect)cropRect
{
  CGImageRef imageRef = CGImageCreateWithImageInRect( [self CGImage], cropRect );
  UIImage *croppedImage = [UIImage imageWithCGImage:imageRef scale:1.0 orientation:self.imageOrientation];
  CGImageRelease(imageRef);
  return croppedImage;
}

- (UIImage *) rotateUIImage
{
  // No-op if the orientation is already correct
  if (self.imageOrientation == UIImageOrientationUp) return self;
  
  // We need to calculate the proper transformation to make the image upright.
  // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
  CGAffineTransform transform = CGAffineTransformIdentity;
  
  switch (self.imageOrientation) {
    case UIImageOrientationDown:
    case UIImageOrientationDownMirrored:
      transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
      transform = CGAffineTransformRotate(transform, M_PI);
      break;
      
    case UIImageOrientationLeft:
    case UIImageOrientationLeftMirrored:
      transform = CGAffineTransformTranslate(transform, self.size.width, 0);
      transform = CGAffineTransformRotate(transform, M_PI_2);
      break;
      
    case UIImageOrientationRight:
    case UIImageOrientationRightMirrored:
      transform = CGAffineTransformTranslate(transform, 0, self.size.height);
      transform = CGAffineTransformRotate(transform, -M_PI_2);
      break;
    case UIImageOrientationUp:
    case UIImageOrientationUpMirrored:
      break;
  }
  
  switch (self.imageOrientation) {
    case UIImageOrientationUpMirrored:
    case UIImageOrientationDownMirrored:
      transform = CGAffineTransformTranslate(transform, self.size.width, 0);
      transform = CGAffineTransformScale(transform, -1, 1);
      break;
      
    case UIImageOrientationLeftMirrored:
    case UIImageOrientationRightMirrored:
      transform = CGAffineTransformTranslate(transform, self.size.height, 0);
      transform = CGAffineTransformScale(transform, -1, 1);
      break;
    case UIImageOrientationUp:
    case UIImageOrientationDown:
    case UIImageOrientationLeft:
    case UIImageOrientationRight:
      break;
  }
  
  // Now we draw the underlying CGImage into a new context, applying the transform
  // calculated above.
  CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height,
                                           CGImageGetBitsPerComponent(self.CGImage), 0,
                                           CGImageGetColorSpace(self.CGImage),
                                           CGImageGetBitmapInfo(self.CGImage));
  CGContextConcatCTM(ctx, transform);
  switch (self.imageOrientation) {
    case UIImageOrientationLeft:
    case UIImageOrientationLeftMirrored:
    case UIImageOrientationRight:
    case UIImageOrientationRightMirrored:
      // Grr...
      CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage);
      break;
      
    default:
      CGContextDrawImage(ctx, CGRectMake(0,0,self.size.width,self.size.height), self.CGImage);
      break;
  }
  
  // And now we just create a new UIImage from the drawing context
  CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
  UIImage *img = [UIImage imageWithCGImage:cgimg];
  CGContextRelease(ctx);
  CGImageRelease(cgimg);
  return img;
}

static void addRoundedRectToPath(CGContextRef context, CGRect rect, CGFloat ovalWidth, CGFloat ovalHeight)
{
  CGFloat fw, fh;
  if ( ovalWidth == 0 || ovalHeight == 0 ) {
    CGContextAddRect(context, rect);
    return;
  }
  
  CGContextSaveGState(context);
  CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
  CGContextScaleCTM(context, ovalWidth, ovalHeight);
  fw = CGRectGetWidth(rect) / ovalWidth;
  fh = CGRectGetHeight(rect) / ovalHeight;
  
  CGContextMoveToPoint(context, fw, fh/2);  // Start at lower right corner
  CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);  // Top right corner
  CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1); // Top left corner
  CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1); // Lower left corner
  CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1); // Back to lower right
  
  CGContextClosePath(context);
  CGContextRestoreGState(context);
}

+ (UIImage *) createRoundedRectImage:(UIImage *)image size:(CGSize)size roundRadius:(CGFloat)radius
{
  if ( !radius )
    radius = 8;
  // the size of CGContextRef
  NSUInteger w = image.size.width;
  NSUInteger h = image.size.height;
  
  UIImage *img = image;
  CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
  CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, (CGBitmapInfo)kCGImageAlphaPremultipliedFirst);
  CGRect rect = CGRectMake(0, 0, w, h);
  
  if (context == nil) {
    CGColorSpaceRelease(colorSpace);//leak for unreleased colorSpace
    return nil;
  }
  
  CGContextBeginPath(context);
  addRoundedRectToPath(context, rect, radius, radius);
  CGContextClosePath(context);
  CGContextClip(context);
  CGContextDrawImage(context, CGRectMake(0, 0, w, h), img.CGImage);
  CGImageRef imageMasked = CGBitmapContextCreateImage(context);
  CGContextRelease(context);
  CGColorSpaceRelease(colorSpace);
  UIImage *masked = [UIImage imageWithCGImage:imageMasked];
  CGImageRelease(imageMasked);
  return masked;
}

+ (UIImage *) returnImage:(UIImage *)img withSize:(CGSize)finalSize
{
  UIGraphicsBeginImageContext(finalSize);
  [img drawInRect:CGRectMake(0, 0, finalSize.width, finalSize.height)];
  UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  
  return image;
}

- (NSData *)imageWithCompression:(CGFloat)compression
{
  UIImage *image = self;
  NSData *imageData = UIImageJPEGRepresentation(image, 0.3);
  CGSize resize = CGSizeMake(self.size.width * 0.8, self.size.height * 0.8);
  while (imageData.length > compression * 1024)
  {
    image = [image imageByScalingToSize:resize];
    imageData = UIImageJPEGRepresentation(image, 1);
    resize = CGSizeMake(self.size.width * 0.8, self.size.height * 0.8);
  }
  
  return imageData;
}

@end
