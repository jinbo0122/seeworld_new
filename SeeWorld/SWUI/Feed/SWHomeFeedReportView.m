//
//  SWHomeFeedReportView.m
//  SeeWorld
//
//  Created by Albert Lee on 9/2/15.
//  Copyright (c) 2015 SeeWorld. All rights reserved.
//

#import "SWHomeFeedReportView.h"
#import "SWFeedReportAPI.h"
#import "SWReportUserAPI.h"
@interface SWHomeFeedReportView()<UIGestureRecognizerDelegate>
@property(nonatomic, strong)UIView    *bgView;
@property(nonatomic, strong)UIButton  *btnPorn;
@property(nonatomic, strong)UIButton  *btnViolence;
@property(nonatomic, strong)UIButton  *btnOther;
@property(nonatomic, strong)UIButton  *btnCancel;
@end
@implementation SWHomeFeedReportView
- (id)initWithFrame:(CGRect)frame{
  if (self = [super initWithFrame:frame]) {
    self.backgroundColor = [UIColor colorWithRGBHex:0x000000 alpha:0.44];
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height, self.width, 200+iphoneXBottomAreaHeight)];
    _bgView.backgroundColor = [UIColor colorWithRGBHex:0xffffff];
    [self addSubview:_bgView];
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    gesture.delegate = self;
    [self addGestureRecognizer:gesture];

    _btnCancel = [[UIButton alloc] initWithFrame:CGRectMake(0, _bgView.height-50-iphoneXBottomAreaHeight, self.width, 50)];
    [_btnCancel setBackgroundColor:[UIColor colorWithRGBHex:0xffffff]];
    [_btnCancel setTitle:SWStringCancel forState:UIControlStateNormal];
    [_btnCancel setTitleColor:[UIColor colorWithRGBHex:0x8A9BAC] forState:UIControlStateNormal];
    [_btnCancel.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [_bgView addSubview:_btnCancel];
    [_btnCancel addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [_btnCancel addSubview:[ALLineView lineWithFrame:CGRectMake(0, 0, _btnCancel.width, 0.5) colorHex:0xcccccc]];

    _btnOther = [[UIButton alloc] initWithFrame:CGRectMake(0, _btnCancel.top-50, self.width, 50)];
    [_btnOther setBackgroundColor:[UIColor colorWithRGBHex:0xffffff]];
    [_btnOther setTitle:SWStringOther forState:UIControlStateNormal];
    [_btnOther setTitleColor:[UIColor colorWithRGBHex:0xFF3B30] forState:UIControlStateNormal];
    [_btnOther.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [_bgView addSubview:_btnOther];
    _btnOther.tag = SWFeedReportTypeOther;
    [_btnOther addTarget:self action:@selector(onReportClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_btnOther addSubview:[ALLineView lineWithFrame:CGRectMake(0, 0, _btnOther.width, 0.5) colorHex:0xcccccc]];

    _btnViolence = [[UIButton alloc] initWithFrame:CGRectMake(0, _btnOther.top-50, self.width, 50)];
    [_btnViolence setBackgroundColor:[UIColor colorWithRGBHex:0xffffff]];
    [_btnViolence setTitle:SWStringViolent forState:UIControlStateNormal];
    [_btnViolence setTitleColor:[UIColor colorWithRGBHex:0xFF3B30] forState:UIControlStateNormal];
    [_btnViolence.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [_bgView addSubview:_btnViolence];
    _btnViolence.tag = SWFeedReportTypeViolence;
    [_btnViolence addTarget:self action:@selector(onReportClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_btnViolence addSubview:[ALLineView lineWithFrame:CGRectMake(0, 0, _btnViolence.width, 0.5) colorHex:0xcccccc]];

    _btnPorn = [[UIButton alloc] initWithFrame:CGRectMake(0, _btnViolence.top-50, self.width, 50)];
    [_btnPorn setBackgroundColor:[UIColor colorWithRGBHex:0xffffff]];
    [_btnPorn setTitle:SWStringPorn forState:UIControlStateNormal];
    [_btnPorn setTitleColor:[UIColor colorWithRGBHex:0xFF3B30] forState:UIControlStateNormal];
    [_btnPorn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [_bgView addSubview:_btnPorn];

    _btnPorn.tag = SWFeedReportTypePorn;
    [_btnPorn addTarget:self action:@selector(onReportClicked:) forControlEvents:UIControlEventTouchUpInside];
    
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

- (void)onReportClicked:(UIButton *)button{
  __weak typeof(self)wSelf = self;
  [self dismissWithBlock:^{
    if (wSelf.userId) {
      SWReportUserAPI *api = [[SWReportUserAPI alloc] init];
      api.userId = wSelf.userId;
      [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
      } failure:^(YTKBaseRequest *request) {
      }];
    }else{
      SWFeedReportAPI *api = [[SWFeedReportAPI alloc] init];
      api.fId = wSelf.feedItem.feed.fId;
      [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
      } failure:^(YTKBaseRequest *request) {
      }];
    }
    [PDProgressHUD showTip:SWStringReportHandled];
  }];
}
@end
