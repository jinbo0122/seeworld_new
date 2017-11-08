//
//  SWMineHeaderView.m
//  SeeWorld
//
//  Created by Albert Lee on 5/16/16.
//  Copyright © 2016 SeeWorld. All rights reserved.
//

#import "SWMineHeaderView.h"

@implementation SWMineHeaderView{
  UIImageView *_iconStatus;
  UILabel     *_lblStatus;
}
- (id)initWithFrame:(CGRect)frame{
  if (self = [super initWithFrame:frame]) {
    _btnCover = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, 208)];
    _btnCover.customImageView = [[UIImageView alloc] initWithFrame:_btnCover.bounds];
    [_btnCover addSubview:_btnCover.customImageView];
    _btnCover.customImageView.contentMode = UIViewContentModeScaleAspectFill;
    UIView *cover = [[UIView alloc] initWithFrame:_btnCover.customImageView.bounds];
    cover.backgroundColor = [UIColor colorWithRGBHex:0x000000 alpha:0.2];
    [_btnCover.customImageView addSubview:cover];
    
    UIBezierPath *path = [UIBezierPath new];
    [path moveToPoint:(CGPoint){0, 0}];
    [path addLineToPoint:(CGPoint){_btnCover.width, 0}];
    [path addLineToPoint:(CGPoint){_btnCover.width, 124}];
    [path addLineToPoint:(CGPoint){0, _btnCover.height}];
    
    CAShapeLayer *mask = [CAShapeLayer new];
    mask.frame = _btnCover.customImageView.bounds;
    mask.path = path.CGPath;
    _btnCover.customImageView.layer.mask = mask;
    
    _btnAvatar = [[UIButton alloc] initWithFrame:CGRectMake(UIScreenWidth-98-24, 84, 98, 98)];
    _btnAvatar.customImageView = [[UIImageView alloc] initWithFrame:_btnAvatar.bounds];
    _btnAvatar.customImageView.layer.masksToBounds = YES;
    _btnAvatar.customImageView.layer.cornerRadius = _btnAvatar.customImageView.width/2.0;
    _btnAvatar.customImageView.layer.borderWidth = 1.0;
    _btnAvatar.customImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    [_btnAvatar addSubview:_btnAvatar.customImageView];
    
    
    _btnEditCover = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 53)];
    _btnEditCover.customImageView = [[UIImageView alloc] initWithFrame:CGRectMake(14, 15, 22, 22)];
    _btnEditCover.customImageView.image = [UIImage imageNamed:@"profile_btn_edit"];
    [_btnEditCover addSubview:_btnEditCover.customImageView];
    _btnEditCover.lblCustom = [UILabel initWithFrame:CGRectMake(_btnEditCover.customImageView.right+4, 18, 55, 16)
                                             bgColor:[UIColor clearColor]
                                           textColor:[UIColor colorWithRGBHex:0xfbfcfc]
                                                text:@"編輯封面"
                                       textAlignment:NSTextAlignmentLeft
                                                font:[UIFont systemFontOfSize:12]];
    [_btnEditCover addSubview:_btnEditCover.lblCustom];
    
    _btnEditAvatar = [[UIButton alloc] initWithFrame:CGRectMake(UIScreenWidth-100-30, _btnAvatar.bottom, 100, 33)];
    _btnEditAvatar.customImageView = [[UIImageView alloc] initWithFrame:CGRectMake(14, 15, 22, 22)];
    _btnEditAvatar.customImageView.image = [UIImage imageNamed:@"profile_btn_edit"];
    [_btnEditAvatar addSubview:_btnEditAvatar.customImageView];
    _btnEditAvatar.lblCustom = [UILabel initWithFrame:CGRectMake(_btnEditAvatar.customImageView.right+4, 18, 65, 16)
                                              bgColor:[UIColor clearColor]
                                            textColor:[UIColor colorWithRGBHex:0xfbfcfc]
                                                 text:@"編輯大頭照"
                                        textAlignment:NSTextAlignmentLeft
                                                 font:[UIFont systemFontOfSize:12]];
    [_btnEditAvatar addSubview:_btnEditAvatar.lblCustom];
    
    _lblName = [UILabel initWithFrame:CGRectMake(30, 93, UIScreenWidth-155, 20)
                              bgColor:[UIColor clearColor]
                            textColor:[UIColor colorWithRGBHex:0xffffff]
                                 text:@""
                        textAlignment:NSTextAlignmentLeft
                                 font:[UIFont systemFontOfSize:18]];
    
    _lblIntro = [UILabel initWithFrame:CGRectMake(30, _lblName.bottom+10, UIScreenWidth-155, 13)
                               bgColor:[UIColor clearColor]
                             textColor:[UIColor colorWithRGBHex:0xffffff]
                                  text:@""
                         textAlignment:NSTextAlignmentLeft
                                  font:[UIFont systemFontOfSize:11]];
    
    _iconStatus = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self addSubview:_iconStatus];
    
    _lblStatus = [UILabel initWithFrame:CGRectZero
                               bgColor:[UIColor clearColor]
                             textColor:[UIColor colorWithRGBHex:0xffffff]
                                  text:@""
                         textAlignment:NSTextAlignmentLeft
                                  font:[UIFont systemFontOfSize:11]];
    [self addSubview:_lblStatus];
    
    [self addSubview:_btnCover];
    [self addSubview:_btnAvatar];
    [self addSubview:_btnEditCover];
    [self addSubview:_btnEditAvatar];
    [self addSubview:_lblIntro];
    [self addSubview:_lblName];
    
    [_btnCover addTarget:self action:@selector(onEditCoverClicked) forControlEvents:UIControlEventTouchUpInside];
    [_btnAvatar addTarget:self action:@selector(onEditAvatarClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_btnEditCover addTarget:self action:@selector(onEditCoverClicked) forControlEvents:UIControlEventTouchUpInside];
    [_btnEditAvatar addTarget:self action:@selector(onEditAvatarClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    _lblPost = [UILabel initWithFrame:CGRectMake(18.5, 215, 0, 0)
                              bgColor:[UIColor clearColor]
                            textColor:[UIColor colorWithRGBHex:0x8b9cad]
                                 text:@"" textAlignment:NSTextAlignmentLeft
                                 font:[UIFont systemFontOfSize:13]];
    [self addSubview:_lblPost];
    
    _btnFollowing = [[UIButton alloc] initWithFrame:CGRectZero];
    _btnFollowing.lblCustom = [UILabel initWithFrame:CGRectZero
                                             bgColor:[UIColor clearColor]
                                           textColor:[UIColor colorWithRGBHex:0x8b9cad]
                                                text:@"" textAlignment:NSTextAlignmentLeft
                                                font:[UIFont systemFontOfSize:13]];
    [_btnFollowing addSubview:_btnFollowing.lblCustom];
    [self addSubview:_btnFollowing];
    
    _btnFollower = [[UIButton alloc] initWithFrame:CGRectZero];
    _btnFollower.lblCustom = [UILabel initWithFrame:CGRectZero
                                            bgColor:[UIColor clearColor]
                                          textColor:[UIColor colorWithRGBHex:0x8b9cad]
                                               text:@"" textAlignment:NSTextAlignmentLeft
                                               font:[UIFont systemFontOfSize:13]];
    [_btnFollower addSubview:_btnFollower.lblCustom];
    [self addSubview:_btnFollower];
    
    
    CGFloat width = UIScreenWidth==320?30:46;
    CGFloat height = 48;
    
    _btnMore = [[UIButton alloc] initWithFrame:CGRectMake(UIScreenWidth-5-width, 198, width, height)];
    [_btnMore setImage:[UIImage imageNamed:@"profile_btn_other"] forState:UIControlStateNormal];
    [self addSubview:_btnMore];
    
    _btnMode = [[UIButton alloc] initWithFrame:CGRectMake(_btnMore.left-width, _btnMore.top, width, height)];
    [_btnMode setImage:[UIImage imageNamed:@"profile_btn_thumbnail"] forState:UIControlStateNormal];
    [self addSubview:_btnMode];
    _btnMode.tag = 0;
    
    _btnEdit = [[UIButton alloc] initWithFrame:CGRectMake(_btnMode.left-width, _btnMore.top, width, height)];
    [_btnEdit setImage:[UIImage imageNamed:@"profile_btn_edit"] forState:UIControlStateNormal];
    [self addSubview:_btnEdit];
    
    _btnChat = [[UIButton alloc] initWithFrame:CGRectMake(_btnMode.left-width, _btnMore.top, width, height)];
    [_btnChat setImage:[UIImage imageNamed:@"profile_btn_chat"] forState:UIControlStateNormal];
    [self addSubview:_btnChat];
    
    [_btnEdit addTarget:self action:@selector(onEdit) forControlEvents:UIControlEventTouchUpInside];
    [_btnChat addTarget:self action:@selector(onChat) forControlEvents:UIControlEventTouchUpInside];
    [_btnMore addTarget:self action:@selector(onMore) forControlEvents:UIControlEventTouchUpInside];
    [_btnMode addTarget:self action:@selector(onMode) forControlEvents:UIControlEventTouchUpInside];
    
    
    _privateView = [[UIView alloc] initWithFrame:CGRectMake((UIScreenWidth-114)/2.0, self.height+62, 114, 113)];
    [self addSubview:_privateView];
    
    UIImageView *iconPrivate = [[UIImageView alloc] initWithFrame:CGRectMake(18, 0, 78, 78)];
    iconPrivate.image = [UIImage imageNamed:@"profile_img_private"];
    [_privateView addSubview:iconPrivate];
    
    UILabel *lblPrivate = [UILabel initWithFrame:CGRectMake(0, iconPrivate.bottom+17, _privateView.width, 16)
                                         bgColor:[UIColor clearColor]
                                       textColor:[UIColor colorWithRGBHex:0x8b9cad]
                                            text:@"此賬號為私人賬號"
                                   textAlignment:NSTextAlignmentCenter
                                            font:[UIFont systemFontOfSize:14]];
    [_privateView addSubview:lblPrivate];
  }
  return self;
}

- (void)refreshWithUser:(SWFeedUserItem *)user{
  
  if (user.bghead.length>0) {
    [_btnCover.customImageView sd_setImageWithURL:[NSURL URLWithString:user.bghead]];
  }else{
    _btnCover.customImageView.image = [UIImage imageNamed:@"profile_img_fontcover_default"];
  }
  
  [_btnAvatar.customImageView sd_setImageWithURL:[NSURL URLWithString:[user.picUrl stringByAppendingString:@"-avatar210"]]];
  
  _lblName.text = user.name;
  _lblIntro.text = user.intro;
  [_lblName sizeToFit];

  _lblPost.text = [@"貼文 " stringByAppendingString:[user.feedCount?user.feedCount:@0 stringValue]];
  [_lblPost sizeToFit];
  
  _btnFollowing.lblCustom.text = [@"追蹤 " stringByAppendingString:[user.followedCount?user.followedCount:@0 stringValue]];
  [_btnFollowing.lblCustom sizeToFit];
  
  _btnFollowing.frame = CGRectMake(_lblPost.right+15, 200, _btnFollowing.lblCustom.width, 43);
  _btnFollowing.lblCustom.top = 15;
  [_btnFollowing addTarget:self action:@selector(onFollowingClick) forControlEvents:UIControlEventTouchUpInside];
  
  _btnFollower.lblCustom.text = [@"粉絲 " stringByAppendingString:[user.followerCount?user.followerCount:@0 stringValue]];
  [_btnFollower.lblCustom sizeToFit];
  
  _btnFollower.frame = CGRectMake(_btnFollowing.right+15, 200, _btnFollower.lblCustom.width, 43);
  _btnFollower.lblCustom.top = 15;
  [_btnFollower addTarget:self action:@selector(onFollowerClick) forControlEvents:UIControlEventTouchUpInside];

  
  if ([user.uId integerValue] == [[SWFeedUserItem myself].uId integerValue]) {
    _btnMore.hidden = YES;
    _btnChat.hidden = YES;
    _btnEdit.hidden = NO;
    _iconStatus.hidden = _lblStatus.hidden = YES;
  }else{
    _btnMore.hidden = NO;
    _btnChat.hidden = NO;
    _btnEdit.hidden = YES;
    _iconStatus.hidden = _lblStatus.hidden = NO;
    
    SWUserRelationType relation = [user.relation integerValue];
    NSString *resource = relation==SWUserRelationTypeFollowing?@"profile_status_follwing":(relation==SWUserRelationTypeInterFollow?@"profile_status_mutual_follwing":@"");
    NSString *status = relation==SWUserRelationTypeFollowing?@"追蹤中":(relation==SWUserRelationTypeInterFollow?@"互相追蹤":@"");
    _iconStatus.image = [UIImage imageNamed:resource];
    _lblStatus.text = status;
    
    _iconStatus.frame = CGRectMake(_lblName.right+8, _lblName.top+5, 0, 0);
    [_iconStatus sizeToFit];
    
    [_lblStatus sizeToFit];
    _lblStatus.left = _iconStatus.right+4;
    _lblStatus.top = _iconStatus.top;
    [self bringSubviewToFront:_iconStatus];
    [self bringSubviewToFront:_lblStatus];
  }
  
  if ([user.relation integerValue] != SWUserRelationTypeInterFollow &&
      [user.relation integerValue] != SWUserRelationTypeSelf &&
      [user.relation integerValue] != SWUserRelationTypeFollowed &&
      [user.issecret boolValue]) {
    _privateView.hidden = NO;
  }else{
    _privateView.hidden = YES;
  }
}


- (void)setIsEditMode:(BOOL)isEditMode{
  _isEditMode = isEditMode;
  _lblIntro.hidden = _lblName.hidden = _lblPost.hidden = _btnFollowing.hidden = _btnFollower.hidden = _btnChat.hidden = _btnEdit.hidden = _btnMode.hidden = _btnMore.hidden = isEditMode;
  _btnEditAvatar.hidden = _btnEditCover.hidden = !isEditMode;
  _btnEdit.hidden = isEditMode;
}

- (void)onEditCoverClicked{
  if (self.delegate && [self.delegate respondsToSelector:@selector(mineHeaderViewDidNeedEditCover:)]) {
    [self.delegate mineHeaderViewDidNeedEditCover:self];
  }
}

- (void)onEditAvatarClicked:(UIButton *)button{
  if (self.delegate && [self.delegate respondsToSelector:@selector(mineHeaderViewDidNeedEditAvatar:)]) {
    [self.delegate mineHeaderViewDidNeedEditAvatar:self];
  }
}

- (void)onFollowingClick{
  if (self.delegate && [self.delegate respondsToSelector:@selector(mineHeaderDidNeedGoFollowing:)]) {
    [self.delegate mineHeaderDidNeedGoFollowing:self];
  }
}

- (void)onFollowerClick{
  if (self.delegate && [self.delegate respondsToSelector:@selector(mineHeaderDidNeedGoFollower:)]) {
    [self.delegate mineHeaderDidNeedGoFollower:self];
  }
}

- (void)onEdit{
  if (self.delegate && [self.delegate respondsToSelector:@selector(mineHeaderDidPressEdit:)]) {
    [self.delegate mineHeaderDidPressEdit:self];
  }
}

- (void)onMore{
  if (self.delegate && [self.delegate respondsToSelector:@selector(mineHeaderDidPressMore:)]) {
    [self.delegate mineHeaderDidPressMore:self];
  }
}

- (void)onMode{
  _btnMode.tag = 1- _btnMode.tag;
  [_btnMode setImage:[UIImage imageNamed:_btnMode.tag?@"profile_btn_zoom":@"profile_btn_thumbnail"] forState:UIControlStateNormal];
  if (self.delegate && [self.delegate respondsToSelector:@selector(mineHeaderDidPressMode:)]) {
    [self.delegate mineHeaderDidPressMode:self];
  }
}

- (void)onChat{
  if (self.delegate && [self.delegate respondsToSelector:@selector(mineHeaderDidPressChat:)]) {
    [self.delegate mineHeaderDidPressChat:self];
  }
}
@end
