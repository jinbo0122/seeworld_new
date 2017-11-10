//
//  UIButton+ALExtension.h
//  ALExtension
//
//  Created by Albert Lee on 8/25/14.
//  Copyright (c) 2014 Albert Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (ALExtension)
@property (nonatomic, strong)NSString *tagString;
@property (nonatomic, strong)UIImageView *customImageView;
@property (nonatomic, strong)UILabel *lblCustom;
- (void)arrangeCustomSubviewToCenterWithGap:(CGFloat)gap;
- (void)setImage:(UIImage *)image
            text:(NSString *)text
    textColorHex:(UInt32)textColorHex
        fontSize:(NSInteger)fontSize
             gap:(CGFloat)gap;
@end
