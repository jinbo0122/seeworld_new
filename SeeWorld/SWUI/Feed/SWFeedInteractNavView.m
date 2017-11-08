//
//  SWFeedInteractNavView.m
//  SeeWorld
//
//  Created by Albert Lee on 9/2/15.
//  Copyright (c) 2015 SeeWorld. All rights reserved.
//

#import "SWFeedInteractNavView.h"

@implementation SWFeedInteractNavView
- (id)initWithFrame:(CGRect)frame items:(NSArray *)items{
  self = [super initWithFrame:frame];
  if (self) {
    _btnLeft = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.width/2.0, self.height)];
    [_btnLeft setTitle:[items safeStringObjectAtIndex:0] forState:UIControlStateNormal];
    [_btnLeft setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btnLeft.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [self addSubview:_btnLeft];
    
    [_btnLeft addTarget:self action:@selector(onCommentClick) forControlEvents:UIControlEventTouchUpInside];
    
    _btnRight = [[UIButton alloc] initWithFrame:CGRectMake(self.width/2.0, 0, self.width/2.0, self.height)];
    [_btnRight setTitle:[items safeStringObjectAtIndex:1] forState:UIControlStateNormal];
    [_btnRight setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btnRight.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [self addSubview:_btnRight];
    [_btnRight addTarget:self action:@selector(onLikeClick) forControlEvents:UIControlEventTouchUpInside];

    
    _slider = [[UIImageView alloc] initWithFrame:CGRectZero];
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

- (void)setSliderImage:(NSString *)imageName{
  _slider.image = [UIImage imageNamed:imageName];
  _slider.frame = CGRectMake((self.width/2.0-_slider.image.size.width)/2.0, self.height-3, _slider.image.size.width, 3);
}

- (void)setSelectedIndex:(NSInteger)selectedIndex{
  _selectedIndex = selectedIndex;
  
  _slider.hidden = NO;
  
  __weak typeof(_slider)wSlider = _slider;
  __weak typeof(self)wSelf = self;
  [UIView animateWithDuration:0.3 animations:^{
    wSlider.left = (wSelf.width/2.0-wSlider.image.size.width)/2.0 + selectedIndex *wSelf.width/2.0;
  }];
  
  if (self.delegate && [self.delegate respondsToSelector:@selector(feedInteractNavViewDidSelectIndex:)]) {
    [self.delegate feedInteractNavViewDidSelectIndex:selectedIndex];
  }
}
@end
