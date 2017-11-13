//
//  SWNoticeCell.m
//  SeeWorld
//
//  Created by Albert Lee on 9/25/15.
//  Copyright © 2015 SeeWorld. All rights reserved.
//

#import "SWNoticeCell.h"

@implementation SWNoticeCell{
  UIImageView *_iconAvatar;
  UILabel     *_lblName;
  UILabel     *_lblContent;
  UILabel     *_lblTime;
  UIButton    *_btnFollow;
  UIButton    *_btnFeed;
  UIImageView *_dot;
  
  SWNoticeMsgItem *_msgItem;
  
  UIView      *_bgView;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
  if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    self.contentView.backgroundColor = [UIColor colorWithRGBHex:0xffffff];
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, 70)];
    [self.contentView addSubview:_bgView];
    
    _iconAvatar = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 40, 40)];
    _iconAvatar.layer.masksToBounds = YES;
    _iconAvatar.layer.cornerRadius  = _iconAvatar.width/2.0;
    [_bgView addSubview:_iconAvatar];
    _iconAvatar.userInteractionEnabled = YES;
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onAvatarClick)];
    [_iconAvatar addGestureRecognizer:gesture];
    _lblName = [UILabel initWithFrame:CGRectMake(_iconAvatar.right+10, 15, UIScreenWidth-140, 17)
                              bgColor:[UIColor clearColor]
                            textColor:[UIColor colorWithRGBHex:0x8A9BAC]
                                 text:@""
                        textAlignment:NSTextAlignmentLeft
                                 font:[UIFont systemFontOfSize:14]];
    [_bgView addSubview:_lblName];
    
    _lblContent = [UILabel initWithFrame:CGRectMake(_lblName.left, _lblName.bottom+10, _lblName.width, 13.5)
                                 bgColor:[UIColor clearColor]
                               textColor:[UIColor colorWithRGBHex:0x8A9BAC]
                                    text:@""
                           textAlignment:NSTextAlignmentLeft
                                    font:[UIFont systemFontOfSize:12] numberOfLines:0];
    [_bgView addSubview:_lblContent];
    
    _btnFollow = [[UIButton alloc] initWithFrame:CGRectMake(UIScreenWidth-148, 21, 106, 28)];
    [_bgView addSubview:_btnFollow];
    
    _btnFeed = [[UIButton alloc] initWithFrame:CGRectMake(UIScreenWidth-60, 13, 44, 44)];
    _btnFeed.customImageView = [[UIImageView alloc] initWithFrame:_btnFeed.bounds];
    [_btnFeed addSubview:_btnFeed.customImageView];
    _btnFeed.customImageView.layer.masksToBounds = YES;
    _btnFeed.customImageView.layer.cornerRadius  = 3.0;
    _btnFeed.customImageView.contentMode = UIViewContentModeScaleAspectFill;
    _btnFeed.customImageView.clipsToBounds = YES;
    [_bgView addSubview:_btnFeed];
    
    
    _lblTime = [UILabel initWithFrame:CGRectZero
                              bgColor:[UIColor clearColor]
                            textColor:[UIColor colorWithRGBHex:0x8b9cad]
                                 text:@""
                        textAlignment:NSTextAlignmentLeft
                                 font:[UIFont systemFontOfSize:9]];
    [_bgView addSubview:_lblTime];
    
    _dot = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"notice_icon_unread"]];
    _dot.frame = CGRectMake(8, 8, 10, 10);
    [_bgView addSubview:_dot];
  }
  return self;
}

- (void)awakeFromNib {
  [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

+ (CGFloat)heightOfNotice:(SWNoticeMsgItem *)msgItem{
  return 70;
}

- (UIEdgeInsets)layoutMargins{
  return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (void)hideDot{
  _dot.hidden = YES;
}

- (void)refreshNotice:(SWNoticeMsgItem *)msgItem{
  self.selectionStyle = UITableViewCellSelectionStyleNone;
  _msgItem = msgItem;
  [_iconAvatar sd_setImageWithURL:[NSURL URLWithString:[msgItem.user.picUrl stringByAppendingString:@"-avatar120"]]];
  _lblName.text = msgItem.user.name;
  NSDictionary *msgDic = [[NSUserDefaults standardUserDefaults] safeDicObjectForKey:@"msgReadDic"];
  _dot.hidden = [msgItem.status boolValue]||[[msgDic safeNumberObjectForKey:[msgItem.mId stringValue]] boolValue];
  
  if ([msgItem.mType integerValue]==SWNoticeTypeFollow) {
    _btnFeed.hidden = YES;
    _btnFollow.hidden = NO;
    [self refreshButton];
    _lblContent.text = SWStringFollowedYou;
    _lblContent.textColor = [UIColor colorWithRGBHex:0x8A9BAC];
    [_btnFollow addTarget:self action:@selector(onFollowClick) forControlEvents:UIControlEventTouchUpInside];
  }else{
    _btnFeed.hidden = NO;
    _btnFollow.hidden = YES;
    if ([msgItem.mType integerValue] == SWNoticeTypeComment){
      if ([msgItem.comment rangeOfString:@"7xlsvh.com1.z0.glb.clouddn.com"].location!=NSNotFound) {
        _lblContent.text = SWStringMsgPic;
      }else{
        _lblContent.text = msgItem.comment;
      }
      _lblContent.textColor = [UIColor colorWithRGBHex:0x8A9BAC];
    }else if ([msgItem.mType integerValue] == SWNoticeTypeLike){
      _lblContent.text = SWStringLikedYou;
      _lblContent.textColor = [UIColor colorWithRGBHex:0x8A9BAC];
    }
    [_btnFeed addTarget:self action:@selector(onFeedClick) forControlEvents:UIControlEventTouchUpInside];
    
    [_btnFeed.customImageView sd_setImageWithURL:[NSURL URLWithString:[msgItem.feed.picUrl stringByAppendingString:FEED_THUMB]]];
  }
  _lblTime.text = [NSString time:[msgItem.time doubleValue] format:MHPrettyDateShortRelativeTime];
  [_lblTime sizeToFit];
  _lblTime.right = _btnFeed.hidden?(UIScreenWidth-11):(_btnFeed.left-11);
  _lblTime.top   = 8;
  
}

- (void)onAvatarClick{
  _dot.hidden = YES;
  
  if (self.delegate && [self.delegate respondsToSelector:@selector(noticeCellDidPressAvatar:)]) {
    [self.delegate noticeCellDidPressAvatar:_msgItem];
  }
}

- (void)onFollowClick{
  _dot.hidden = YES;
  
  SWUserRelationType relationType = [_msgItem.user.relation integerValue];
  
  switch (relationType) {
    case SWUserRelationTypeSelf:{
      return;
    }
      break;
    case SWUserRelationTypeUnrelated:{
      relationType = SWUserRelationTypeFollowing;
    }
      break;
    case SWUserRelationTypeFollowing:{
      return;
      //      relationType = SWUserRelationTypeUnrelated;
    }
      break;
    case SWUserRelationTypeFollowed:{
      relationType = SWUserRelationTypeInterFollow;
    }
      break;
    case SWUserRelationTypeInterFollow:{
      return;
      //      relationType = SWUserRelationTypeFollowed;
    }
      break;
      
    default:
      break;
  }
  
  _msgItem.user.relation = [NSNumber numberWithInteger:relationType];
  [self refreshButton];
  
  if (self.delegate && [self.delegate respondsToSelector:@selector(noticeCellDidPressFollow:)]) {
    [self.delegate noticeCellDidPressFollow:_msgItem];
  }
}

- (void)onFeedClick{
  _dot.hidden = YES;
  if (self.delegate && [self.delegate respondsToSelector:@selector(noticeCellDidPressFeed:)]) {
    [self.delegate noticeCellDidPressFeed:_msgItem];
  }
}

- (void)refreshButton{
  SWUserRelationType relationType = [_msgItem.user.relation integerValue];
  if (relationType == 0 || [_msgItem.user.uId isEqualToNumber:@0]) {
    _btnFollow.hidden = YES;
  }else{
    switch (relationType) {
      case SWUserRelationTypeFollowing:{
        _btnFollow.hidden = YES;
      }break;
      case SWUserRelationTypeFollowed:{
        _btnFollow.hidden = NO;
        [_btnFollow setImage:[UIImage imageNamed:@"notice_btn_follow"] forState:UIControlStateNormal];
      }break;
      case SWUserRelationTypeInterFollow:{
        _btnFollow.hidden = YES;
      }break;
      case SWUserRelationTypeUnrelated:{
        _btnFollow.hidden = NO;
        [_btnFollow setImage:[UIImage imageNamed:@"notice_btn_follow"] forState:UIControlStateNormal];
      }break;
        
      default:{
        _btnFollow.hidden = NO;
        [_btnFollow setImage:[UIImage imageNamed:@"notice_btn_follow"] forState:UIControlStateNormal];
      }break;
    }
  }
  _btnFollow.tag = relationType;
}
@end
