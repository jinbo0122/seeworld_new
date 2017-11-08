//
//  SWReportView.m
//  SeeWorld
//
//  Created by Albert Lee on 1/22/16.
//  Copyright © 2016 SeeWorld. All rights reserved.
//

#import "SWReportView.h"
@interface SWReportView()<UIGestureRecognizerDelegate>
@property(nonatomic, strong)UIView    *bgView;
@property(nonatomic, strong)UIButton  *btnConfirm;
@property(nonatomic, strong)UIButton  *btnCancel;
@end
@implementation SWReportView
- (id)initWithTitle:(NSString *)title{
  if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
    self.backgroundColor = [UIColor colorWithRGBHex:0x000000 alpha:0.44];
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height, self.width, 103)];
    _bgView.backgroundColor = [UIColor colorWithRGBHex:0xe7e7ee];
    [self addSubview:_bgView];
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    gesture.delegate = self;
    [self addGestureRecognizer:gesture];
    
    _btnCancel = [[UIButton alloc] initWithFrame:CGRectMake(0, _bgView.height-50, self.width, 50)];
    [_btnCancel setBackgroundColor:[UIColor whiteColor]];
    [_btnCancel setTitle:SWStringCancel forState:UIControlStateNormal];
    [_btnCancel setTitleColor:[UIColor colorWithRGBHex:0x494949] forState:UIControlStateNormal];
    [_btnCancel.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [_bgView addSubview:_btnCancel];
    [_btnCancel addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    
    _btnConfirm = [[UIButton alloc] initWithFrame:CGRectMake(0, _btnCancel.top-53, self.width, 50)];
    [_btnConfirm setBackgroundColor:[UIColor whiteColor]];
    [_btnConfirm setTitle:title forState:UIControlStateNormal];
    [_btnConfirm setTitleColor:[UIColor colorWithRGBHex:0xe64340] forState:UIControlStateNormal];
    [_btnConfirm.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [_bgView addSubview:_btnConfirm];
    [_btnConfirm addTarget:self action:@selector(onConfirmClicked:) forControlEvents:UIControlEventTouchUpInside];    
  }
  return self;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
  if ([touch.view isDescendantOfView:_bgView]) {
    return NO;
  }
  return YES;
}

- (void)show{
  [[UIApplication sharedApplication].delegate.window addSubview:self];
  
  if (_bgView.top==self.height) {
    __weak typeof(self)wSelf = self;
    [UIView animateWithDuration:0.3
                     animations:^{
                       wSelf.bgView.top = wSelf.height-wSelf.bgView.height;
                     }];
  }
}

- (void)dismiss{
  [self dismissWithBlock:nil];
}

- (void)dismissWithBlock:(COMPLETION_BLOCK)block{
  if (_bgView.top==self.height-self.bgView.height) {
    __weak typeof(self)wSelf = self;
    [UIView animateWithDuration:0.3
                     animations:^{
                       wSelf.bgView.top = wSelf.height;
                     } completion:^(BOOL finished) {
                       if (block) {
                         block();
                       }
                       [wSelf removeFromSuperview];
                     }];
  }
}

- (void)onConfirmClicked:(UIButton *)button{
  __weak typeof(self)wSelf = self;
  [self dismissWithBlock:^{
    if (wSelf.block) {
      wSelf.block();
    }
  }];
}
@end
