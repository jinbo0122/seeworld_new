//
//  PDVideoWhisperRecordProgressView.m
//  pandora
//
//  Created by Albert Lee on 27/10/2016.
//  Copyright © 2016 Albert Lee. All rights reserved.
//

#import "PDVideoWhisperRecordProgressView.h"
@implementation PDVideoWhisperRecordProgressView{
  UIView *_bgProgress;
  UIView *_progressView;
}

- (id)initWithFrame:(CGRect)frame{
  if (self = [super initWithFrame:frame]) {
    _bgProgress = [[UIView alloc] initWithFrame:CGRectMake(0, self.height-2, self.width, 2)];
    _bgProgress.backgroundColor = [UIColor colorWithRGBHex:0x000000 alpha:0.6];
    [self addSubview:_bgProgress];
    
    _progressView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height-2, 0, 2)];
    _progressView.backgroundColor = [UIColor colorWithRGBHex:0x00aaee];
    [self addSubview:_progressView];
  }
  return self;
}

- (void)setDuration:(NSTimeInterval)duration{
  _duration = duration;
  
  if (_duration == 0) {
    _bgProgress.hidden = _progressView.hidden =YES;
  }else{
    _bgProgress.hidden = _progressView.hidden = NO;
    _progressView.width = self.width * duration/180.0;
  }
}
@end
