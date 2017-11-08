//
//  SWPostEnterView.m
//  GuiGu
//
//  Created by Albert Lee on 5/19/15.
//  Copyright (c) 2015 GuiGuDi. All rights reserved.
//

#import "SWPostEnterView.h"
@interface SWPostEnterView()
@property(nonatomic, strong)UIView   *photoView;
@property(nonatomic, strong)UIView   *chatView;
@property(nonatomic, strong)UIButton *btnPhoto;
@property(nonatomic, strong)UIButton *btnChat;
@property(nonatomic, strong)UIButton *btnClose;
@property(nonatomic, strong)UIImageView *imageBgView;
@property(nonatomic, strong)UIImage  *bgImage;
@end

@implementation SWPostEnterView
+ (void)showWithDelegate:(id<SWPostEnterViewDelegate>)delegate{
  SWPostEnterView *temp = (SWPostEnterView *)[SWUtility isViewOfClassOnMainView:[SWPostEnterView class]];
  if (temp) {
    [temp removeFromSuperview];
  }
  
  SWPostEnterView *view = [[SWPostEnterView alloc] initWithFrame:[UIScreen mainScreen].bounds];
  view.delegate = delegate;
  view.bgImage = [UIImage imageWithView:[UIApplication sharedApplication].delegate.window];
  [view show];
}

- (id)initWithFrame:(CGRect)frame{
  if (self = [super initWithFrame:frame]) {
    self.imageBgView = [[UIImageView alloc] initWithFrame:frame];
    [self addSubview:self.imageBgView];
    
    self.backgroundColor = [UIColor colorWithRGBHex:0x000000 alpha:0.6];
    
    self.btnClose = [[UIButton alloc] initWithFrame:CGRectMake((UIScreenWidth-26)/2.0, self.height-41, 26, 26)];
    [self.btnClose setImage:[UIImage imageNamed:@"add_photo_btn_close"] forState:UIControlStateNormal];
    [self addSubview:self.btnClose];
    [self.btnClose addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat x = UIScreenWidth==320?40:67;
    self.photoView = [[UIView alloc] initWithFrame:CGRectMake(x, UIScreenHeight-147+300, 72, 72)];
    [self addSubview:self.photoView];
    
    self.btnPhoto = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    [self.btnPhoto setImage:[UIImage imageNamed:@"add_btn_photo"] forState:UIControlStateNormal];
    [self.photoView addSubview:self.btnPhoto];
    [self.btnPhoto addTarget:self action:@selector(onPhotoClicked) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.chatView = [[UIView alloc] initWithFrame:CGRectMake(UIScreenWidth-x-72, self.photoView.top, 72, 72)];
    [self addSubview:self.chatView];
    
    self.btnChat = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    [self.btnChat setImage:[UIImage imageNamed:@"add_btn_chat"] forState:UIControlStateNormal];
    [self.chatView addSubview:self.btnChat];
    [self.btnChat addTarget:self action:@selector(onChatClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [self addGestureRecognizer:gesture];
    __weak typeof(self)wSelf = self;
    [UIView animateWithDuration:0.3
                     animations:^{
                       wSelf.photoView.top-=315;
                     } completion:^(BOOL finished) {
                       [UIView animateWithDuration:0.1
                                        animations:^{
                                          wSelf.photoView.top+=30;
                                        } completion:^(BOOL finished) {
                                          [UIView animateWithDuration:0.3
                                                           animations:^{
                                                             wSelf.photoView.top-=15;
                                                           } completion:^(BOOL finished) {
                                                             
                                                           }];
                                        }];
                     }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
      [UIView animateWithDuration:0.3
                       animations:^{
                         wSelf.chatView.top-=315;
                       } completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.1
                                          animations:^{
                                            wSelf.chatView.top+=30;
                                          } completion:^(BOOL finished) {
                                            [UIView animateWithDuration:0.3
                                                             animations:^{
                                                               wSelf.chatView.top-=15;
                                                             } completion:^(BOOL finished) {
                                                               
                                                             }];
                                          }];
                       }];
    });
  }
  return self;
}

- (void)setBgImage:(UIImage *)bgImage{
  _bgImage = bgImage;
  self.imageBgView.image = _bgImage;
  __weak typeof(self)wSelf = self;
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    UIImage *image = [bgImage applyBlurWithRadius:20 tintColor:[UIColor colorWithRGBHex:0x000000 alpha:0.6] saturationDeltaFactor:1.3 maskImage:nil];
    dispatch_async(dispatch_get_main_queue(), ^{
      wSelf.imageBgView.alpha = 0;
      wSelf.imageBgView.image = image;
      [UIView animateWithDuration:0.3
                       animations:^{
                         wSelf.imageBgView.alpha = 1.0;
                       }];
    });
  });
}

- (void)show{
  [SWUtility addWindowSubview:self];
}

- (void)dismiss{
  __weak typeof(self)wSelf = self;
  
  [UIView animateWithDuration:0.3
                   animations:^{
                     wSelf.chatView.top+=300;
                   }];
  
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    [UIView animateWithDuration:0.3
                     animations:^{
                       wSelf.alpha = 0;
                       wSelf.photoView.top+=300;
                     } completion:^(BOOL finished) {
                       [wSelf removeFromSuperview];
                     }];
    
  });
}

- (void)onPhotoClicked{
  self.isNeedPhoto = YES;
  self.isNeedChat = NO;
  if (self.delegate && [self.delegate respondsToSelector:@selector(postEnterViewDidReturnAction:)]) {
    [self.delegate postEnterViewDidReturnAction:self];
  }
  __weak typeof(self)wSelf = self;
  [UIView animateWithDuration:0.3
                   animations:^{
                     wSelf.photoView.transform = CGAffineTransformMakeScale(2.0, 2.0);
                     wSelf.photoView.alpha = 0;
                     wSelf.chatView.hidden = YES;
                   } completion:^(BOOL finished) {
                     [wSelf dismiss];
                   }];
  
}

- (void)onChatClicked{
  self.isNeedPhoto = NO;
  self.isNeedChat = YES;
  if (self.delegate && [self.delegate respondsToSelector:@selector(postEnterViewDidReturnAction:)]) {
    [self.delegate postEnterViewDidReturnAction:self];
  }
  
  __weak typeof(self)wSelf = self;
  [UIView animateWithDuration:0.3
                   animations:^{
                     wSelf.chatView.transform = CGAffineTransformMakeScale(2.0, 2.0);
                     wSelf.chatView.alpha = 0;
                     wSelf.photoView.hidden = YES;
                   } completion:^(BOOL finished) {
                     [wSelf dismiss];
                   }];}

- (void)dealloc{

}

@end
