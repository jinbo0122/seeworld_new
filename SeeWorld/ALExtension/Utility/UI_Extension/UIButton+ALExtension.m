//
//  UIButton+ALExtension.m
//  ALExtension
//
//  Created by Albert Lee on 8/25/14.
//  Copyright (c) 2014 Albert Lee. All rights reserved.
//

#import "UIButton+ALExtension.h"
#import <objc/runtime.h>
static char UIButtonALExtensionTagString;
static char UIButtonALExtensionCustomImageView;
static char UIButtonALExtensionCustomTitleLabel;
@implementation UIButton (ALExtension)
@dynamic tagString,lblCustom;
-(void)setTagString:(NSString *)tagString
{
  objc_setAssociatedObject(self, &UIButtonALExtensionTagString, tagString, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

-(NSString *)tagString
{
  return objc_getAssociatedObject(self, &UIButtonALExtensionTagString);
}

-(void)setCustomImageView:(UIImageView *)customImageView
{
  objc_setAssociatedObject(self, &UIButtonALExtensionCustomImageView, customImageView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(UIImageView *)customImageView
{
  return objc_getAssociatedObject(self, &UIButtonALExtensionCustomImageView);
}

- (void)setLblCustom:(UILabel *)lblCustom{
  objc_setAssociatedObject(self, &UIButtonALExtensionCustomTitleLabel, lblCustom, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UILabel *)lblCustom{
  return objc_getAssociatedObject(self, &UIButtonALExtensionCustomTitleLabel);
}

- (void)arrangeCustomSubviewToCenterWithGap:(CGFloat)gap{
  [self.customImageView sizeToFit];
  [self.lblCustom sizeToFit];
  self.customImageView.left = (self.width-self.customImageView.width-gap-self.lblCustom.width)/2.0;
  self.customImageView.top = (self.height-self.customImageView.height)/2.0;
  self.lblCustom.left = self.customImageView.right+gap;
  self.lblCustom.top = (self.height-self.lblCustom.height)/2.0;
}

- (void)setImage:(UIImage *)image text:(NSString *)text textColorHex:(UInt32)textColorHex fontSize:(NSInteger)fontSize gap:(CGFloat)gap{
  self.customImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
  self.customImageView.image = image;
  [self addSubview:self.customImageView];
  
  self.lblCustom = [UILabel initWithFrame:CGRectZero
                                  bgColor:[UIColor clearColor]
                                textColor:[UIColor colorWithRGBHex:textColorHex]
                                     text:text
                            textAlignment:NSTextAlignmentLeft
                                     font:[UIFont systemFontOfSize:fontSize]];
  [self addSubview:self.lblCustom];
  [self arrangeCustomSubviewToCenterWithGap:gap];
}

- (void)setImage:(UIImage *)image text:(NSString *)text textColorHex:(UInt32)textColorHex fontSize:(NSInteger)fontSize{
  self.customImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
  self.customImageView.image = image;
  [self addSubview:self.customImageView];
  
  self.lblCustom = [UILabel initWithFrame:CGRectZero
                                  bgColor:[UIColor clearColor]
                                textColor:[UIColor colorWithRGBHex:textColorHex]
                                     text:text
                            textAlignment:NSTextAlignmentLeft
                                     font:[UIFont systemFontOfSize:fontSize]];
  [self addSubview:self.lblCustom];
}
@end
