//
//  SWExploreSegView.m
//  SeeWorld
//
//  Created by Albert Lee on 6/5/16.
//  Copyright © 2016 SeeWorld. All rights reserved.
//

#import "SWExploreSegView.h"

@implementation SWExploreSegView
- (id)initWithFrame:(CGRect)frame items:(NSArray *)items images:(NSArray *)images{
  self = [super initWithFrame:frame];
  if (self) {
    _btnLeft = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.width/2.0, self.height)];
    _btnLeft.customImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[images safeStringObjectAtIndex:0]]];
    [_btnLeft.customImageView sizeToFit];
    [_btnLeft addSubview:_btnLeft.customImageView];
    _btnLeft.lblCustom = [UILabel initWithFrame:CGRectZero
                                        bgColor:[UIColor clearColor]
                                      textColor:[UIColor whiteColor]
                                           text:[items safeStringObjectAtIndex:0]
                                  textAlignment:NSTextAlignmentLeft
                                           font:[UIFont systemFontOfSize:13]];
    [_btnLeft.lblCustom sizeToFit];
    [_btnLeft addSubview:_btnLeft.lblCustom];
    CGFloat gapLeft = [[items safeStringObjectAtIndex:0] length]>0?10:0;
    _btnLeft.customImageView.left = (_btnLeft.width-_btnLeft.customImageView.width-_btnLeft.lblCustom.width-gapLeft)/2.0;
    _btnLeft.lblCustom.left = _btnLeft.customImageView.right+gapLeft;
    _btnLeft.lblCustom.top = (_btnLeft.height-_btnLeft.lblCustom.height)/2.0;
    _btnLeft.customImageView.top = (_btnLeft.height-_btnLeft.customImageView.height)/2.0;
    [self addSubview:_btnLeft];
    
    [_btnLeft addTarget:self action:@selector(onCommentClick) forControlEvents:UIControlEventTouchUpInside];
    
    _btnRight = [[UIButton alloc] initWithFrame:CGRectMake(self.width/2.0, 0, self.width/2.0, self.height)];
    _btnRight.customImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[images safeStringObjectAtIndex:1]]];
    [_btnRight.customImageView sizeToFit];
    [_btnRight addSubview:_btnRight.customImageView];
    _btnRight.lblCustom = [UILabel initWithFrame:CGRectZero
                                         bgColor:[UIColor clearColor]
                                       textColor:[UIColor whiteColor]
                                            text:[items safeStringObjectAtIndex:1]
                                   textAlignment:NSTextAlignmentLeft
                                            font:[UIFont systemFontOfSize:13]];
    [_btnRight.lblCustom sizeToFit];
    [_btnRight addSubview:_btnRight.lblCustom];
    CGFloat gapRight = [[items safeStringObjectAtIndex:1] length]>0?10:0;
    _btnRight.customImageView.left = (_btnRight.width-_btnRight.customImageView.width-_btnRight.lblCustom.width-gapRight)/2.0;
    _btnRight.lblCustom.left = _btnRight.customImageView.right+gapRight;
    _btnRight.lblCustom.top = (_btnRight.height-_btnRight.lblCustom.height)/2.0;
    _btnRight.customImageView.top = (_btnRight.height-_btnRight.customImageView.height)/2.0;
    [self addSubview:_btnRight];
    [_btnRight addTarget:self action:@selector(onLikeClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:[ALLineView lineWithFrame:CGRectMake(0, self.height-2, self.width, 2) colorHex:0xffffff]];
    [self addSubview:[ALLineView lineWithFrame:CGRectMake(self.width/2.0, (self.height-20)/2.0, 1.0, 20) colorHex:0x596d80]];

    
    _slider = [[UIView alloc] initWithFrame:CGRectMake(0, self.height-2, self.width/2.0, 2)];
    _slider.backgroundColor = [UIColor colorWithRGBHex:0x596d80];
    [self addSubview:_slider];
    
    _slider.hidden = YES;
  }
  return self;
}


- (void)onCommentClick{
  self.selectedIndex = 0;
}

- (void)onLikeClick{
  self.selectedIndex = 1;
}

- (void)setSelectedIndex:(NSInteger)selectedIndex{
  _selectedIndex = selectedIndex;
  
  _slider.hidden = NO;
  
  __weak typeof(_slider)wSlider = _slider;
  __weak typeof(self)wSelf = self;
  [UIView animateWithDuration:0.3 animations:^{
    wSlider.left = selectedIndex *wSelf.width/2.0;
  }];
  
  if (self.delegate && [self.delegate respondsToSelector:@selector(feedInteractNavViewDidSelectIndex:)]) {
    [self.delegate feedInteractNavViewDidSelectIndex:selectedIndex];
  }
}
@end
