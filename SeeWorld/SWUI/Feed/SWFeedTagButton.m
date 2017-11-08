//
//  SWFeedTagButton.m
//  SeeWorld
//
//  Created by Albert Lee on 9/1/15.
//  Copyright (c) 2015 SeeWorld. All rights reserved.
//

#import "SWFeedTagButton.h"
typedef enum {
  DirectAuto = -2,
  DirectNone = -1,
  DirectRight = 1,
  DirectLeft = 0,
}DirectType;

#define BUTTON_HEIGHT 22

@interface SWFeedTagButton(){
  BOOL isWhitePointOntheLeft;
}
@end

@implementation SWFeedTagButton
@synthesize tagObject = _tagObject,tagNameImageView,lblBrandName,whitePoint;
- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    // Initialization code
    self.tagObject = [[SWFeedTagItem alloc] init];
    self.tagHoverImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 6, 8, 8)];
    self.tagHoverImageView.image = [UIImage imageNamed:@"tag_point_black"];
    self.tagHoverImageView.alpha = .3;
    [self addSubview:self.tagHoverImageView];
    
    self.tagHoverImageView2 = [[UIImageView alloc] initWithFrame:self.tagHoverImageView.frame];
    self.tagHoverImageView2.image = [UIImage imageNamed:@"tag_point_black"];
    self.tagHoverImageView2.alpha = .3;
    [self addSubview:self.tagHoverImageView2];
    
    self.whitePoint = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tag_point_white"]];
    self.whitePoint.center = self.tagHoverImageView.center;
    [self addSubview:self.whitePoint];
    
    self.tagNameImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.tagHoverImageView.frame)+2, 0, 73, BUTTON_HEIGHT)];
    self.tagNameImageView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.tagNameImageView];
    
    self.lblBrandName = [[UILabel alloc] initWithFrame:CGRectMake(18, 0, 47, 23)];
    self.lblBrandName.font = [UIFont systemFontOfSize:13];
    self.lblBrandName.backgroundColor = [UIColor clearColor];
    self.lblBrandName.textAlignment = NSTextAlignmentLeft;
    self.lblBrandName.textColor = [UIColor whiteColor];
    
    self.limitPicWidth = 320;
  }
  return self;
}
- (void)refreshUI{
  self.tagNameImageView.transform = CGAffineTransformMake(1, 0, 0, 1, 0, 0);
  self.lblBrandName.transform = CGAffineTransformMake(1, 0, 0, 1, 0, 0);
  
  self.tagHoverImageView.transform = CGAffineTransformIdentity;
  self.tagHoverImageView2.transform = CGAffineTransformIdentity;
  self.whitePoint.transform = CGAffineTransformIdentity;
  
  CGFloat whitePointWidth = 10;//CGRectGetWidth(self.tagHoverImageView.frame);
  CGFloat whitePointSubWidth = whitePointWidth/2;
  
  //tempFrame 是 当前view的tempFrame
  CGFloat width = [self calcWidth];
  CGRect tempFrame = CGRectMake([self.tagObject.coord.x floatValue]-whitePointSubWidth,
                                [self.tagObject.coord.y floatValue]-self.tagHoverImageView.center.y,
                                width, BUTTON_HEIGHT);
  
  //设置品牌名字标签透明度
  self.tagNameImageView.alpha = 0.8;
  
  //  isWhitePointOntheLeft = YES;//白点儿在左边
  
  //超长，并且靠右，翻转tag，让品牌名靠左显示
  if (((CGRectGetMaxX(tempFrame)>self.limitPicWidth &&
        CGRectGetMinX(tempFrame)+whitePointSubWidth>(self.limitPicWidth/2)) && [self.tagObject.direction integerValue] == DirectAuto) ||
      ((CGRectGetMaxX(tempFrame)>self.limitPicWidth &&
        CGRectGetMinX(tempFrame)+whitePointSubWidth>(self.limitPicWidth/2)) && [self.tagObject.direction integerValue] == DirectNone)
      || [self.tagObject.direction integerValue] == DirectLeft){
    if ([self.tagObject.direction integerValue] != DirectAuto) {
      self.tagObject.direction = [NSNumber numberWithInteger:DirectLeft];
    }
    
    tempFrame.origin.x = [self.tagObject.coord.x floatValue]+whitePointSubWidth-width;
    
    //如果翻转标签后，标签左侧超出图片范围，则跳转标签左侧为图片范围，这时品牌名字超长部分显示...
    if (CGRectGetMinX(tempFrame) < 0) {
      tempFrame.origin.x = 0;
      tempFrame.size.width = [self.tagObject.coord.x floatValue]+whitePointSubWidth;
    }
    
    self.tagNameImageView.frame = CGRectMake(0, 0, CGRectGetWidth(tempFrame)-whitePointWidth-2, BUTTON_HEIGHT);
    
    CGRect tempFrame2 = self.tagHoverImageView.frame;
    tempFrame2.origin.x = CGRectGetWidth(tempFrame)-whitePointWidth;
    self.tagHoverImageView.frame = tempFrame2;
    self.tagHoverImageView2.frame = tempFrame2;
    self.whitePoint.center = self.tagHoverImageView.center;
    
    CGAffineTransform trans = self.tagNameImageView.transform;
    trans = CGAffineTransformScale(trans, -1, 1);
    //    trans = CGAffineTransformTranslate(trans, CGRectGetMaxX(self.tagNameImageView.frame)+2, 0);
    self.tagNameImageView.transform = trans;
    
    self.lblBrandName.transform = CGAffineTransformMakeScale(-1, 1);
    //    isWhitePointOntheLeft = NO;//白点儿在右边
    self.lblBrandName.frame = CGRectMake(10, 0, CGRectGetWidth(self.tagNameImageView.frame)-16, BUTTON_HEIGHT);
    
  }
  else{
    if ([self.tagObject.direction integerValue] != DirectAuto) {
      self.tagObject.direction = [NSNumber numberWithInteger:DirectRight];
    }
    
    //如果标签靠右，超出图片范围
    if (CGRectGetMaxX(tempFrame) > self.limitPicWidth) {
      tempFrame.size.width = self.limitPicWidth-CGRectGetMinX(tempFrame);
    }
    
    self.tagNameImageView.frame = CGRectMake(whitePointWidth+2, 0, CGRectGetWidth(tempFrame)-whitePointWidth-2, BUTTON_HEIGHT);
    self.tagHoverImageView.frame = CGRectMake(0, 6, 8, 8);
    self.tagHoverImageView2.frame = self.tagHoverImageView.frame;
    self.whitePoint.center = self.tagHoverImageView.center;
    self.lblBrandName.frame = CGRectMake(12, 0, CGRectGetWidth(self.tagNameImageView.frame)-16, BUTTON_HEIGHT);
    
  }
  //用老方法，解决renderInContext时有重影的问题 resizableImageWithCapInsets:UIEdgeInsetsMake(8, 18, 8, 6)
  [self.tagNameImageView setImage:[[UIImage imageNamed:@"tag_btn_black"] stretchableImageWithLeftCapWidth:15 topCapHeight:8]];
  
  self.lblBrandName.text = self.tagObject.tagName;
  [self.tagNameImageView addSubview:self.lblBrandName];
  
  self.frame = tempFrame;
  
  self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:2.5
                                                         target:self
                                                       selector:@selector(showAnimation)
                                                       userInfo:nil
                                                        repeats:YES];
  [self.animationTimer fire];
}
- (void)reverseTag{
  [self.animationTimer invalidate];
  self.tagNameImageView.transform = CGAffineTransformMake(1, 0, 0, 1, 0, 0);
  self.lblBrandName.transform = CGAffineTransformMake(1, 0, 0, 1, 0, 0);
  
  self.tagHoverImageView.transform = CGAffineTransformIdentity;
  self.tagHoverImageView2.transform = CGAffineTransformIdentity;
  self.whitePoint.transform = CGAffineTransformIdentity;
  
  CGFloat whitePointWidth = 10;//CGRectGetWidth(self.tagHoverImageView.frame);
  CGFloat whitePointSubWidth = whitePointWidth/2;
  
  //tempFrame 是 当前view的tempFrame
  CGFloat width = [self calcWidth];
  CGRect tempFrame = CGRectMake([self.tagObject.coord.x floatValue]-whitePointSubWidth,
                                [self.tagObject.coord.y floatValue]-self.tagHoverImageView.center.y,
                                width, BUTTON_HEIGHT);
  
  //设置品牌名字标签透明度
  self.tagNameImageView.alpha = 0.8;
  if ([self.tagObject.direction integerValue] == DirectRight) {
    tempFrame.origin.x = [self.tagObject.coord.x floatValue]+whitePointSubWidth-width;
    
    //如果翻转标签后，标签左侧超出图片范围，则跳转标签左侧为图片范围，这时品牌名字超长部分显示...
    if (CGRectGetMinX(tempFrame) < 0) {
      self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:2.5
                                                             target:self
                                                           selector:@selector(showAnimation)
                                                           userInfo:nil
                                                            repeats:YES];
      [self.animationTimer fire];
      return;
    }
    
    self.tagNameImageView.frame = CGRectMake(0, 0, CGRectGetWidth(tempFrame)-whitePointWidth-2, BUTTON_HEIGHT);
    
    CGRect tempFrame2 = self.tagHoverImageView.frame;
    tempFrame2.origin.x = CGRectGetWidth(tempFrame)-whitePointWidth;
    self.tagHoverImageView.frame = tempFrame2;
    self.tagHoverImageView2.frame = tempFrame2;
    self.whitePoint.center = self.tagHoverImageView.center;
    
    CGAffineTransform trans = self.tagNameImageView.transform;
    trans = CGAffineTransformScale(trans, -1, 1);
    //    trans = CGAffineTransformTranslate(trans, CGRectGetMaxX(self.tagNameImageView.frame)+2, 0);
    self.tagNameImageView.transform = trans;
    
    self.lblBrandName.transform = CGAffineTransformMakeScale(-1, 1);
    self.tagObject.direction = [NSNumber numberWithInteger:DirectLeft];//白点儿在右边
    self.lblBrandName.frame = CGRectMake(10, 0, CGRectGetWidth(self.tagNameImageView.frame)-16, BUTTON_HEIGHT);
    
  }
  else{
    if (CGRectGetMaxX(tempFrame)>self.limitPicWidth) {
      CGAffineTransform trans = self.tagNameImageView.transform;
      trans = CGAffineTransformScale(trans, -1, 1);
      //    trans = CGAffineTransformTranslate(trans, CGRectGetMaxX(self.tagNameImageView.frame)+2, 0);
      self.tagNameImageView.transform = trans;
      self.lblBrandName.transform = CGAffineTransformMakeScale(-1, 1);
      self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:2.5
                                                             target:self
                                                           selector:@selector(showAnimation)
                                                           userInfo:nil
                                                            repeats:YES];
      [self.animationTimer fire];
      return;
    }
    
    self.tagNameImageView.frame = CGRectMake(whitePointWidth+2, 0, CGRectGetWidth(tempFrame)-whitePointWidth-2, BUTTON_HEIGHT);
    self.tagHoverImageView.frame = CGRectMake(0, 6, 8, 8);
    self.tagHoverImageView2.frame = self.tagHoverImageView.frame;
    self.whitePoint.center = self.tagHoverImageView.center;
    self.tagObject.direction = [NSNumber numberWithInteger:DirectRight];
    self.lblBrandName.frame = CGRectMake(12, 0, CGRectGetWidth(self.tagNameImageView.frame)-16, BUTTON_HEIGHT);
    
  }
  
  //用老方法，解决renderInContext时有重影的问题 resizableImageWithCapInsets:UIEdgeInsetsMake(8, 18, 8, 6)
  [self.tagNameImageView setImage:[[UIImage imageNamed:@"tag_btn_black"] stretchableImageWithLeftCapWidth:15 topCapHeight:8]];
  
  self.lblBrandName.text = self.tagObject.tagName;
  [self.tagNameImageView addSubview:self.lblBrandName];
  
  self.frame = tempFrame;
  
  self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:2.5
                                                         target:self
                                                       selector:@selector(showAnimation)
                                                       userInfo:nil
                                                        repeats:YES];
  [self.animationTimer fire];
}
- (CGFloat)calcWidth{
  CGSize size = [self.tagObject.tagName sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]}];
  return 10+2+14+size.width+6;//CGRectGetWidth(self.tagHoverImageView.frame)
}

- (void)showAnimation
{
  __weak typeof(self)wSelf = self;
  [UIView animateWithDuration:.20 delay:0 options:UIViewAnimationOptionCurveEaseInOut
                   animations:^{
                     CGAffineTransform trans = CGAffineTransformMakeScale(.8, .8);
                     wSelf.whitePoint.transform = trans;
                     wSelf.tagHoverImageView.transform = trans;
                     wSelf.tagHoverImageView2.transform = trans;
                   } completion:^(BOOL finished) {
                     [UIView animateWithDuration:.20 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                       CGAffineTransform trans = CGAffineTransformMakeScale(1.25, 1.25);
                       wSelf.whitePoint.transform = trans;
                       wSelf.tagHoverImageView.transform = trans;
                       wSelf.tagHoverImageView2.transform = trans;
                     } completion:^(BOOL finished) {
                       
                       [UIView animateWithDuration:.20 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                         
                         CGAffineTransform trans = CGAffineTransformIdentity;
                         wSelf.whitePoint.transform = trans;
                         wSelf.tagHoverImageView.transform = trans;
                         wSelf.tagHoverImageView2.transform = trans;
                       } completion:^(BOOL finished) {
                         [UIView animateWithDuration:.9 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                           wSelf.tagHoverImageView.transform = CGAffineTransformMakeScale(30/8.0, 30/8.0);
                           wSelf.tagHoverImageView.alpha = .05;
                         } completion:^(BOOL finished) {
                           wSelf.tagHoverImageView.transform = CGAffineTransformIdentity;
                           wSelf.tagHoverImageView.alpha = .75;
                         }];
                         
                         [UIView animateWithDuration:.9 delay:.45 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                           wSelf.tagHoverImageView2.transform = CGAffineTransformMakeScale(30/8.0, 30/8.0);
                           wSelf.tagHoverImageView2.alpha = .05;
                         } completion:^(BOOL finished) {
                           wSelf.tagHoverImageView2.transform = CGAffineTransformIdentity;
                           wSelf.tagHoverImageView2.alpha = .75;
                         }];
                       }];
                     }];
                   }];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
