//
//  NSMutableAttributedString+CTFrameRef.h
//  TLMove
//
//  Created by andezhou on 15/7/29.
//  Copyright (c) 2015年 andezhou
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

@interface NSMutableAttributedString (CTFrameRef)


#pragma mark - CoreText CTLine/CTRun utils

CGRect CTRunGetTypographicBoundsForLinkRect(CTLineRef line, NSRange range, CGPoint lineOrigin);

// 获取文字高度height
- (CGFloat)prepareDisplayViewHeightWithWidth:(CGFloat)width;

// 获取CTFrameRef
- (CTFrameRef)prepareFrameRefWithWidth:(CGFloat)width;

@end
