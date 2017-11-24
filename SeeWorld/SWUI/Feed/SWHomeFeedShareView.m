//
//  SWHomeFeedShareView.m
//  SeeWorld
//
//  Created by Albert Lee on 9/2/15.
//  Copyright (c) 2015 SeeWorld. All rights reserved.
//

#import "SWHomeFeedShareView.h"
#import "WXApi.h"
#import "WeiboSDK.h"
#import <FBSDKShareKit/FBSDKShareKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
@interface SWHomeFeedShareView()<UIDocumentInteractionControllerDelegate,UIGestureRecognizerDelegate>
@property(nonatomic, strong)UIView    *bgView;
@property(nonatomic, strong)UIButton  *btnReport;
@property(nonatomic, strong)UIButton  *btnCancel;
@property(nonatomic, strong)UIButton  *btnFB;
@property(nonatomic, strong)UIButton  *btnInstagram;
@property(nonatomic, strong)UIButton  *btnWechat;
@property(nonatomic, strong)UIButton  *btnMoments;
@property(nonatomic, strong)UIButton  *btnWeibo;
@property(nonatomic, strong)UIButton  *btnLine;
@property(nonatomic, strong)UIDocumentInteractionController *docController;
@end

@implementation SWHomeFeedShareView
- (id)initWithFrame:(CGRect)frame{
  if (self = [super initWithFrame:frame]) {
    self.backgroundColor = [UIColor colorWithRGBHex:0x000000 alpha:0.44];
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height, self.width, 220+iphoneXBottomAreaHeight)];
    _bgView.backgroundColor = [UIColor colorWithRGBHex:0xffffff];
    [self addSubview:_bgView];
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    gesture.delegate = self;
    [self addGestureRecognizer:gesture];

    _btnCancel = [[UIButton alloc] initWithFrame:CGRectMake(0, _bgView.height-50-iphoneXBottomAreaHeight, self.width, 50)];
    [_btnCancel setBackgroundColor:[UIColor colorWithRGBHex:0xffffff]];
    [_btnCancel setTitle:SWStringCancel forState:UIControlStateNormal];
    [_btnCancel setTitleColor:[UIColor colorWithRGBHex:0x8A9BAC] forState:UIControlStateNormal];
    [_btnCancel.titleLabel setFont:[UIFont systemFontOfSize:17]];
    [_bgView addSubview:_btnCancel];
    [_btnCancel addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [_btnCancel addSubview:[ALLineView lineWithFrame:CGRectMake(0, 0.5, _btnCancel.width, 0.5) colorHex:0xcccccc]];
    
    _btnReport = [[UIButton alloc] initWithFrame:CGRectMake(0, _btnCancel.top-0.5-50, self.width, 50)];
    [_btnReport setBackgroundColor:[UIColor colorWithRGBHex:0xffffff]];
    [_btnReport setTitle:SWStringReport forState:UIControlStateNormal];
    [_btnReport setTitleColor:[UIColor colorWithRGBHex:0x8A9BAC] forState:UIControlStateNormal];
    [_btnReport.titleLabel setFont:[UIFont systemFontOfSize:17]];
    [_bgView addSubview:_btnReport];
    [_btnReport addTarget:self action:@selector(onReportClicked) forControlEvents:UIControlEventTouchUpInside];
    [_btnReport addSubview:[ALLineView lineWithFrame:CGRectMake(0, 0, _btnReport.width, 0.5) colorHex:0xcccccc]];

    UIView *shareBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 119)];
    shareBgView.backgroundColor = [UIColor colorWithRGBHex:0xffffff];
    [_bgView addSubview:shareBgView];
    
    UILabel *lblHint = [UILabel initWithFrame:CGRectMake((self.width-50)/2.0, 16, 50, 22.5)
                                      bgColor:[UIColor clearColor]
                                    textColor:[UIColor colorWithRGBHex:0x34414e]
                                         text:SWStringShare
                                textAlignment:NSTextAlignmentCenter
                                         font:[UIFont systemFontOfSize:15]];
    [_bgView addSubview:lblHint];
    
    CGFloat initX = (self.width-30*6-20)/7.0;
    CGFloat space = initX+5;
    _btnFB = [[UIButton alloc] initWithFrame:CGRectMake(initX, lblHint.bottom+23.4, 30, 30)];
    [_btnFB setImage:[UIImage imageNamed:@"home_btn_share_fb"] forState:UIControlStateNormal];
    [_bgView addSubview:_btnFB];
    [_btnFB addTarget:self action:@selector(onFBClicked) forControlEvents:UIControlEventTouchUpInside];
    
    _btnLine = [[UIButton alloc] initWithFrame:CGRectMake(_btnFB.right+space, _btnFB.top, 30, 30)];
    [_btnLine setImage:[UIImage imageNamed:@"home_btn_share_line"] forState:UIControlStateNormal];
    [_bgView addSubview:_btnLine];
    
    [_btnLine addTarget:self action:@selector(onLineClicked) forControlEvents:UIControlEventTouchUpInside];

    
    _btnInstagram = [[UIButton alloc] initWithFrame:CGRectMake(_btnLine.right+space, _btnFB.top, 30, 30)];
    [_btnInstagram setImage:[UIImage imageNamed:@"home_btn_share_ig"] forState:UIControlStateNormal];
    [_bgView addSubview:_btnInstagram];
    [_btnInstagram addTarget:self action:@selector(onInstagramClicked) forControlEvents:UIControlEventTouchUpInside];
    
    _btnMoments = [[UIButton alloc] initWithFrame:CGRectMake(_btnInstagram.right+space, _btnFB.top, 30, 30)];
    [_btnMoments setImage:[UIImage imageNamed:@"home_btn_share_wechat_friend"] forState:UIControlStateNormal];
    [_bgView addSubview:_btnMoments];
    _btnMoments.tag = 1;
    
    _btnWechat = [[UIButton alloc] initWithFrame:CGRectMake(_btnMoments.right+space, _btnFB.top, 30, 30)];
    [_btnWechat setImage:[UIImage imageNamed:@"home_btn_share_wechat"] forState:UIControlStateNormal];
    [_bgView addSubview:_btnWechat];
    
    [_btnWechat addTarget:self action:@selector(onWeixinClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_btnMoments addTarget:self action:@selector(onWeixinClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    _btnWeibo = [[UIButton alloc] initWithFrame:CGRectMake(_btnWechat.right+space, _btnFB.top, 30, 30)];
    [_btnWeibo setImage:[UIImage imageNamed:@"weibo_share"] forState:UIControlStateNormal];
    [_bgView addSubview:_btnWeibo];
    
    [_btnWeibo addTarget:self action:@selector(onWeiboClicked) forControlEvents:UIControlEventTouchUpInside];
  }
  return self;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
  if ([touch.view isDescendantOfView:_bgView]) {
    return NO;
  }
  return YES;
}

-(void)onFBClicked{
  if (self.fbBlock) {
    self.fbBlock(self.shareImage);
  }
  
  [self dismiss];
}

-(void)onInstagramClicked{
  
  if (self.instaBlock) {
    self.instaBlock(self.shareImage);
  }

}

- (void)onLineClicked{
  if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"line://"]]) {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setData:UIImageJPEGRepresentation(self.shareImage, 0.8) forPasteboardType:@"public.jpeg"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"line://msg/image/%@", pasteboard.name]]];
  }else{
    [MBProgressHUD showTip:@"未安裝Line"];
  }
}

- (void)onWeiboClicked{
  WBMessageObject *message = [WBMessageObject message];
  
  WBImageObject *imageObject = [WBImageObject object];
  imageObject.imageData = UIImageJPEGRepresentation(self.shareImage, 1.0);
  message.imageObject = imageObject;
  
  WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message];
  request.shouldOpenWeiboAppInstallPageIfNotInstalled = NO;
  
  
  if ([WeiboSDK isWeiboAppInstalled]) {
    [WeiboSDK sendRequest:request];
  }
  else{
    [MBProgressHUD showTip:@"未安装微博"];
  }
}

- (void)onWeixinClicked:(UIButton *)button{
#if TARGET_IPHONE_SIMULATOR
    return;
#else
    if ([WXApi isWXAppInstalled]&&[WXApi isWXAppSupportApi]) {
        SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
        req.bText = NO;
        WXMediaMessage *message = [WXMediaMessage message];
        NSData *data = UIImageJPEGRepresentation(self.shareImage, 1.0);
        [message setThumbImage:[UIImage thumbImage:data]];
        WXImageObject *obj = [WXImageObject object];
        obj.imageData = data;
        message.mediaObject = obj;
        message.title = @"";
        req.message = message;
        req.scene = button.tag?WXSceneTimeline:WXSceneSession;
        if (![WXApi sendReq:req]) {
            
        }
    }
    else{
        [MBProgressHUD showTip:@"未安装微信"];
    }
#endif
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

- (void)onReportClicked{
  [self dismissWithBlock:self.reportBlock];
}
@end
