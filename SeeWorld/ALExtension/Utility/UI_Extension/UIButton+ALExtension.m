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
@end
