//
//  SWExploreFeedItemView.m
//  SeeWorld
//
//  Created by Albert Lee on 4/24/15.
//  Copyright (c) 2015 SeeWorld. All rights reserved.
//

#import "SWExploreFeedItemView.h"
#import "SWFeedImageView.h"
@interface SWExploreFeedItemView()<SWFeedImageViewDelegate>
@property(nonatomic, strong)UIView      *bgView;

@property(nonatomic, strong)SWFeedImageView *imageView;

@property(nonatomic, strong)UIImageView *iconUserPhoto;
@property(nonatomic, strong)UILabel     *lblPhotoCount;
@end

@implementation SWExploreFeedItemView{
  UIButton *_btnAvatar;
}
- (id)initWithFrame:(CGRect)frame{
  self = [super initWithFrame:frame];
  if (self) {
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    self.bgView.backgroundColor = [UIColor colorWithRGBHex:0x171b21];
    self.bgView.layer.masksToBounds = YES;
    self.bgView.layer.cornerRadius = 10.0;
    self.bgView.layer.borderWidth = 0.5;
    self.bgView.layer.borderColor = [[UIColor colorWithRGBHex:0x323946] CGColor];
    [self addSubview:self.bgView];
    
    
    self.imageView = [[SWFeedImageView alloc] initWithFrame:CGRectMake(0, -1, self.bgView.width, self.bgView.width*0.85)];
    self.imageView.layer.masksToBounds = YES;
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.imageView.bounds
                                                   byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight)
                                                         cornerRadii:CGSizeMake(4.0, 4.0)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.imageView.bounds;
    maskLayer.path = maskPath.CGPath;
    [self.bgView addSubview:self.imageView];
    
    self.imageView.backgroundColor = [UIColor colorWithRGBHex:0xf3f5f8];
    
    self.iconDislike = [[UIImageView alloc] initWithFrame:CGRectMake(self.bgView.center.x-45, self.imageView.center.y-38, 90, 76)];
    [self.iconDislike setImage:[UIImage imageNamed:@"explore_slip_dislike"]];
    [self addSubview:self.iconDislike];
    self.iconDislike.alpha = 0;
    
    
    self.iconLike = [[UIImageView alloc] initWithFrame:CGRectMake(self.bgView.center.x-45, self.imageView.center.y-38, 90, 76)];
    [self.iconLike setImage:[UIImage imageNamed:@"explore_slip_like"]];
    [self addSubview:self.iconLike];
    self.iconLike.alpha = 0;
    
    
    _btnAvatar = [[UIButton alloc] initWithFrame:CGRectMake(self.imageView.left, self.imageView.bottom, self.imageView.width, 60)];
    [self.bgView addSubview:_btnAvatar];
    
    _btnAvatar.customImageView = [[UIImageView alloc] initWithFrame:CGRectMake(7.4, 7.4, 44.3, 43.3)];
    _btnAvatar.customImageView.layer.masksToBounds = YES;
    _btnAvatar.customImageView.layer.cornerRadius  = _btnAvatar.customImageView.width/2.0;
    _btnAvatar.customImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    _btnAvatar.customImageView.layer.borderWidth = 1.0;
    [_btnAvatar addSubview:_btnAvatar.customImageView];
    
    _btnAvatar.lblCustom = [UILabel initWithFrame:CGRectMake(_btnAvatar.customImageView.right+15.3,
                                                             0, _btnAvatar.width-_btnAvatar.customImageView.right-90, _btnAvatar.height)
                                          bgColor:[UIColor clearColor]
                                        textColor:[UIColor colorWithRGBHex:0x8b9cad]
                                             text:@""
                                    textAlignment:NSTextAlignmentLeft
                                             font:[UIFont systemFontOfSize:16.2]];
    [_btnAvatar addSubview:_btnAvatar.lblCustom];
    
    _iconUserPhoto = [[UIImageView alloc] initWithFrame:CGRectMake(_btnAvatar.width-59, 22, 16, 16)];
    [_btnAvatar addSubview:_iconUserPhoto];
    
    _lblPhotoCount = [UILabel initWithFrame:CGRectMake(_iconUserPhoto.right+7.5,
                                                       0, 45, _btnAvatar.height)
                                    bgColor:[UIColor clearColor]
                                  textColor:[UIColor colorWithRGBHex:0x596d80]
                                       text:@""
                              textAlignment:NSTextAlignmentLeft
                                       font:[UIFont systemFontOfSize:13]];
    [_btnAvatar addSubview:_lblPhotoCount];
    
    [_btnAvatar addTarget:self action:@selector(onAvatarClicked:) forControlEvents:UIControlEventTouchUpInside];
  }
  return self;
}

- (void)refreshReviewItemUI:(SWFeedItem *)feedItem{
  self.feedItem = feedItem;
  
  [_btnAvatar.customImageView sd_setImageWithURL:[NSURL URLWithString:[feedItem.user.picUrl stringByAppendingString:@"-avatar120"]]];
  _btnAvatar.lblCustom.text = feedItem.user.name;
  _lblPhotoCount.text = [feedItem.user.feedCount stringValue];
  _iconUserPhoto.image = [UIImage imageNamed:@"explore_icon_photo"];
  [_imageView refreshWithFeed:feedItem showTag:NO];
  _imageView.delegate = self;
}


- (void)onAvatarClicked:(UIButton *)button{
  if (self.delegate && [self.delegate respondsToSelector:@selector(feedItemViewDidPressAvatar:)]
      &&self.feedItem.user) {
    [self.delegate feedItemViewDidPressAvatar:self.feedItem.user];
  }
}

- (void)resetImage{
  self.imageView.tagView.backgroundImageView.image = nil;
}



- (void)animateLeftWithCompletionBlock:(COMPLETION_BLOCK)block{
  __weak typeof(self)wSelf = self;
  [UIView animateWithDuration:0.3
                   animations:^{
                     wSelf.left -=UIScreenWidth;
                   } completion:^(BOOL finished) {
                     wSelf.transform = CGAffineTransformIdentity;
                     wSelf.iconLike.alpha = 0;
                     wSelf.iconDislike.alpha = 0;
                     if (finished) {
                       if (block) {
                         block();
                       }
                     }
                   }];
}

- (void)animateRightWithCompletionBlock:(COMPLETION_BLOCK)block{
  __weak typeof(self)wSelf = self;
  [UIView animateWithDuration:0.3
                   animations:^{
                     wSelf.left +=UIScreenWidth;
                   } completion:^(BOOL finished) {
                     wSelf.iconLike.alpha = 0;
                     wSelf.iconDislike.alpha = 0;
                     if (finished) {
                       if (block) {
                         block();
                       }
                     }
                   }];
}

- (void)animateBackToRect:(CGRect)rect{
  __weak typeof(self)wSelf = self;
  
  [UIView animateWithDuration:0.3
                   animations:^{
                     wSelf.transform = CGAffineTransformIdentity;
                     wSelf.frame = rect;
                     wSelf.iconLike.alpha = 0;
                     wSelf.iconDislike.alpha = 0;
                   }];
}

#pragma mark Image View Delegate
- (void)feedImageViewDidPressImage:(SWFeedItem *)feedItem{
  CGRect rect = [_imageView convertRect:_imageView.bounds toView:[UIApplication sharedApplication].delegate.window];
  
  if (self.delegate && [self.delegate respondsToSelector:@selector(feedItemViewDidPressImage:rect:)]) {
    [self.delegate feedItemViewDidPressImage:feedItem rect:rect];
  }
}

- (void)feedImageViewDidPressTag:(SWFeedTagItem *)tagItem{
  if (self.delegate && [self.delegate respondsToSelector:@selector(feedItemViewDidPressTag:)]) {
    [self.delegate feedItemViewDidPressTag:tagItem];
  }
}
@end
