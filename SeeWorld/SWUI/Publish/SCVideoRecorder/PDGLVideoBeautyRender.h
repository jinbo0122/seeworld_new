//
//  PDGLVideoBeautyRender.h
//  pandora
//
//  Created by zhangzhifan on 16/10/31.
//  Copyright © 2016年 Albert Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LyGLRender.h"

@interface PDGLVideoBeautyRender : LyGLRender
{
    
}

// 设置美白等级 当前默认使用 4等级美白
// @level 美白等级 等级越高美白效果越好
//
- (void) setBeautyLevel:(int) level;

// 设置是否进行X坐标翻转
// 1. 前置摄像头时候需要进行X坐标翻转
// 2. 后置摄像头时候不要进行X坐标翻转
// @isNeedFlip 表示是否需要翻转X坐标
- (void) isFlipXPosition:(int) isNeedFlip;

// 美白
// @ref 摄像头采集的CVPixelBufferRef 格式需要时BGRA
// 渲染结果会通过FBO返回
- (void) doBeautyRender:(CVPixelBufferRef)ref;
@end
