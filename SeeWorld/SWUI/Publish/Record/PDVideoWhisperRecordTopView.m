//
//  PDVideoWhisperRecordTopView.m
//  pandora
//
//  Created by Albert Lee on 27/10/2016.
//  Copyright © 2016 Albert Lee. All rights reserved.
//

#import "PDVideoWhisperRecordTopView.h"

@implementation PDVideoWhisperRecordTopView

- (id)initWithFrame:(CGRect)frame{
  if (self = [super initWithFrame:frame]) {
    self.backgroundColor = [UIColor blackColor];
    
    _btnClose = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 48, self.height)];
    [_btnClose setImage:[UIImage imageNamed:PDResourceBtnVideoWhisperRecordClose] forState:UIControlStateNormal];
    [self addSubview:_btnClose];
    
    _btnFlash = [[UIButton alloc] initWithFrame:CGRectMake(self.width-54, 0, 54, self.height)];
    [self addSubview:_btnFlash];
  }
  return self;
}

@end
