//
//  SWAlertView.m
//  SeeWorld
//
//  Created by Albert Lee on 6/6/16.
//  Copyright © 2016 SeeWorld. All rights reserved.
//

#import "SWAlertView.h"

@implementation SWAlertView{
  UIView    *_bgView;
  UILabel   *_lblTitle;
  
  UIButton  *_btnCancel;
  UIButton  *_btnOKay;
  
  COMPLETION_BLOCK _cancelBlock;
  COMPLETION_BLOCK _okayBlock;
}

- (id)initWithTitle:(NSString *)title
         cancelText:(NSString *)cancelText
        cancelBlock:(COMPLETION_BLOCK)cancelBlock
             okText:(NSString *)okText
            okBlock:(COMPLETION_BLOCK)okBlock{
  if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
    self.backgroundColor = [UIColor colorWithRGBHex:0x000000 alpha:0.6];
    _bgView = [[UIView alloc] initWithFrame:CGRectMake((self.width-300)/2.0, self.centerY-92, 300, 148)];
    _bgView.backgroundColor = [UIColor whiteColor];
    _bgView.layer.masksToBounds = YES; _bgView.layer.cornerRadius=4.0;
    [self addSubview:_bgView];
    
    [_bgView addSubview:[ALLineView lineWithFrame:CGRectMake(20, 94, self.width-40, 1.0) colorHex:0xe4e9ec]];
    
    _lblTitle = [UILabel initWithFrame:CGRectMake(20, 20, _bgView.width-40, 54)
                               bgColor:[UIColor clearColor]
                             textColor:[UIColor colorWithRGBHex:0x596d80]
                                  text:title
                         textAlignment:NSTextAlignmentCenter
                                  font:[UIFont systemFontOfSize:16] numberOfLines:0];
    [_bgView addSubview:_lblTitle];
    
    _btnCancel = [[UIButton alloc] initWithFrame:CGRectMake(0, 94, _bgView.width/(okText?2.0:1.0), _bgView.height-94)];
    [_btnCancel setTitle:cancelText forState:UIControlStateNormal];
    [_btnCancel setTitleColor:[UIColor colorWithRGBHex:0x596d80] forState:UIControlStateNormal];
    [_btnCancel.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [_bgView addSubview:_btnCancel];
    [_btnCancel addTarget:self action:@selector(onCancelClicked) forControlEvents:UIControlEventTouchUpInside];
    _cancelBlock = cancelBlock;
    if (okText) {
      [_bgView addSubview:[ALLineView lineWithFrame:CGRectMake(_bgView.width/2.0, 106.5, 1, 32) colorHex:0xe4e9ec]];
      _btnOKay = [[UIButton alloc] initWithFrame:CGRectMake(_btnCancel.right, 94, _bgView.width/2.0, _bgView.height-94)];
      [_btnOKay setTitle:okText forState:UIControlStateNormal];
      [_btnOKay setTitleColor:[UIColor colorWithRGBHex:0x596d80] forState:UIControlStateNormal];
      [_btnOKay.titleLabel setFont:[UIFont systemFontOfSize:16]];
      [_bgView addSubview:_btnOKay];
      [_btnOKay addTarget:self action:@selector(onOkayClicked) forControlEvents:UIControlEventTouchUpInside];
      _okayBlock = okBlock;
    }
  }
  return self;
}


- (void)show{
  [SWUtility addWindowSubview:self];
  __weak typeof(_bgView)bgView = _bgView;
  [UIView animateWithDuration:0.05
                   animations:^{
                     bgView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.05, 1.05);
                   } completion:^(BOOL finished) {
                     [UIView animateWithDuration:0.1
                                      animations:^{
                                        bgView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.95, 0.95);
                                      } completion:^(BOOL finished) {
                                        [UIView animateWithDuration:0.05
                                                         animations:^{
                                                           bgView.transform = CGAffineTransformIdentity;
                                                         } completion:^(BOOL finished) {
                                                           
                                                         }];
                                      }];
                   }];
}

- (void)dismiss{
  __weak typeof(_bgView)bgView = _bgView;
  __weak typeof(self)wSelf = self;
  [UIView animateWithDuration:0.3
                   animations:^{
                     bgView.alpha = 0.0;
                     wSelf.backgroundColor = [UIColor clearColor];
                   } completion:^(BOOL finished) {
                     [wSelf removeFromSuperview];
                   }];
  
}

- (void)onCancelClicked{
  if (_cancelBlock) {
    _cancelBlock();
  }
  [self dismiss];
}

- (void)onOkayClicked{
  if (_okayBlock) {
    _okayBlock();
  }
  [self dismiss];
}
@end
