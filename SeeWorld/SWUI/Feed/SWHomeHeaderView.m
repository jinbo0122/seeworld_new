//
//  SWHomeHeaderView.m
//  SeeWorld
//
//  Created by Albert Lee on 10/11/2017.
//  Copyright © 2017 SeeWorld. All rights reserved.
//

#import "SWHomeHeaderView.h"

@implementation SWHomeHeaderView{
  UIView      *_bgView;
  UIButton    *_btnPost;
  UIButton    *_btnCamera;
  UIButton    *_btnAlbum;
  UIButton    *_btnLBS;
}

- (id)initWithFrame:(CGRect)frame{
  if (self = [super initWithFrame:frame]) {
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 7, self.width, self.height-7)];
    _bgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_bgView];
    
    _btnPost = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.width, 66)];
    _btnPost.customImageView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 10, 45, 45)];
    _btnPost.customImageView.layer.masksToBounds = YES;
    _btnPost.customImageView.layer.cornerRadius  = _btnPost.customImageView.height/2.0;
    SWFeedUserItem *user = [SWConfigManager sharedInstance].user;
    [_btnPost.customImageView sd_setImageWithURL:[NSURL URLWithString:[user.picUrl stringByAppendingString:@"-avatar210"]]];
    [_btnPost addSubview:_btnPost.customImageView];
    _btnPost.lblCustom = [UILabel initWithFrame:CGRectMake(_btnPost.customImageView.right+12.5, 0, 0, 0)
                                        bgColor:[UIColor clearColor]
                                      textColor:[UIColor colorWithRGBHex:0x667887 alpha:0.7]
                                           text:@"這一刻的想法..."
                                  textAlignment:NSTextAlignmentLeft
                                           font:[UIFont systemFontOfSize:19]];
    [_btnPost addSubview:_btnPost.lblCustom];
    [_btnPost.lblCustom sizeToFit];
    _btnPost.lblCustom.top = (_btnPost.height - _btnPost.lblCustom.height)/2.0;
    [_bgView addSubview:_btnPost];
    
    [_bgView addSubview:[ALLineView lineWithFrame:CGRectMake(0, _btnPost.height-0.5, self.width, 0.5) colorHex:0xe9ebee]];
    
    _btnCamera = [[UIButton alloc] initWithFrame:CGRectMake(0, _btnPost.bottom, self.width/3.0, 36)];
    [_btnCamera setImage:[UIImage imageNamed:@"home_post_camera"] text:@"拍攝" textColorHex:NAV_BAR_COLOR_HEX fontSize:16 gap:5];
    [_bgView addSubview:_btnCamera];
    
    _btnAlbum = [[UIButton alloc] initWithFrame:CGRectMake(_btnCamera.right, _btnPost.bottom, self.width/3.0, 36)];
    [_btnAlbum setImage:[UIImage imageNamed:@"home_post_album"] text:@"相冊" textColorHex:NAV_BAR_COLOR_HEX fontSize:16 gap:5];
    [_bgView addSubview:_btnAlbum];
    
    _btnLBS = [[UIButton alloc] initWithFrame:CGRectMake(_btnAlbum.right, _btnPost.bottom, self.width/3.0, 36)];
    [_btnLBS setImage:[UIImage imageNamed:@"home_post_lbs"] text:@"打卡" textColorHex:NAV_BAR_COLOR_HEX fontSize:16 gap:5];
    [_bgView addSubview:_btnLBS];
    
    [_btnPost addTarget:self action:@selector(onPostClicked) forControlEvents:UIControlEventTouchUpInside];
    [_btnCamera addTarget:self action:@selector(onCameraClicked) forControlEvents:UIControlEventTouchUpInside];
    [_btnAlbum addTarget:self action:@selector(onAlbumClicked) forControlEvents:UIControlEventTouchUpInside];
    [_btnLBS addTarget:self action:@selector(onLBSClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [_bgView addSubview:[ALLineView lineWithFrame:CGRectMake(self.width/3.0, _btnPost.bottom+5.5, 0.5, 25) colorHex:0xe9ebee]];
    [_bgView addSubview:[ALLineView lineWithFrame:CGRectMake(2*self.width/3.0, _btnPost.bottom+5.5, 0.5, 25) colorHex:0xe9ebee]];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:@"SWNotificationUserUpdated" object:nil];
  }
  return self;
}

- (void)refresh{
  SWFeedUserItem *user = [SWConfigManager sharedInstance].user;
  [_btnPost.customImageView sd_setImageWithURL:[NSURL URLWithString:[user.picUrl stringByAppendingString:@"-avatar210"]]];
}

- (void)dealloc{
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)onPostClicked{
  if (self.delegate && [self.delegate respondsToSelector:@selector(homeHeaderViewDidPressPost:)]) {
    [self.delegate homeHeaderViewDidPressPost:self];
  }
}

- (void)onCameraClicked{
  if (self.delegate && [self.delegate respondsToSelector:@selector(homeHeaderViewDidPressCamera:)]) {
    [self.delegate homeHeaderViewDidPressCamera:self];
  }
}

- (void)onAlbumClicked{
  if (self.delegate && [self.delegate respondsToSelector:@selector(homeHeaderViewDidPressAlbum:)]) {
    [self.delegate homeHeaderViewDidPressAlbum:self];
  }
}

- (void)onLBSClicked{
  if (self.delegate && [self.delegate respondsToSelector:@selector(homeHeaderViewDidPressLBS:)]) {
    [self.delegate homeHeaderViewDidPressLBS:self];
  }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
