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
  UIButton    *_btnFeed;
  UIImageView *_dot;
  UIImageView *_imageViewLike;

  SWNoticeMsgItem *_msgItem;
  
  UIView      *_bgView;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
  if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    self.contentView.backgroundColor = [UIColor colorWithRGBHex:0xffffff];
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, 85)];
    [self.contentView addSubview:_bgView];
    
    _iconAvatar = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 45, 45)];
    _iconAvatar.layer.masksToBounds = YES;
    _iconAvatar.layer.cornerRadius  = _iconAvatar.width/2.0;
    [_bgView addSubview:_iconAvatar];
    _iconAvatar.userInteractionEnabled = YES;
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onAvatarClick)];
    [_iconAvatar addGestureRecognizer:gesture];
    _lblName = [UILabel initWithFrame:CGRectMake(_iconAvatar.right+10, 10, UIScreenWidth-75-_iconAvatar.right-10, 17)
                              bgColor:[UIColor clearColor]
                            textColor:[UIColor colorWithRGBHex:0x34414e]
                                 text:@""
                        textAlignment:NSTextAlignmentLeft
                                 font:[UIFont boldSystemFontOfSize:15]];
    [_bgView addSubview:_lblName];
    
    _lblContent = [UILabel initWithFrame:CGRectMake(_lblName.left, _lblName.bottom+8.5, _lblName.width, 17)
                                 bgColor:[UIColor clearColor]
                               textColor:[UIColor colorWithRGBHex:0x666666]
                                    text:@""
                           textAlignment:NSTextAlignmentLeft
                                    font:[UIFont systemFontOfSize:15] numberOfLines:0];
    [_bgView addSubview:_lblContent];
    
    _imageViewLike = [[UIImageView alloc] initWithFrame:CGRectMake(_lblName.left, _lblName.bottom+10, 17, 17)];
    [_bgView addSubview:_imageViewLike];
    
    
    _btnFeed = [[UIButton alloc] initWithFrame:CGRectMake(UIScreenWidth-75, 10, 65, 65)];
    _btnFeed.customImageView = [[UIImageView alloc] initWithFrame:_btnFeed.bounds];
    [_btnFeed addSubview:_btnFeed.customImageView];
    _btnFeed.customImageView.contentMode = UIViewContentModeScaleAspectFill;
    _btnFeed.customImageView.clipsToBounds = YES;
    [_bgView addSubview:_btnFeed];
    
    
    _lblTime = [UILabel initWithFrame:CGRectZero
                              bgColor:[UIColor clearColor]
                            textColor:[UIColor colorWithRGBHex:0x999999 alpha:0.8]
                                 text:@""
                        textAlignment:NSTextAlignmentLeft
                                 font:[UIFont systemFontOfSize:13]];
    [_bgView addSubview:_lblTime];
    
    _dot = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"notice_icon_unread"]];
    _dot.frame = CGRectMake(10, 10, 10.3, 10.3);
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
  return 85;
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
    _lblContent.text = SWStringFollowedYou;
    _lblContent.hidden = NO;
    _imageViewLike.hidden = YES;
  }else{
    _btnFeed.hidden = NO;
    if ([msgItem.mType integerValue] == SWNoticeTypeComment){
      _imageViewLike.hidden = YES;
      _lblContent.hidden = NO;
      if ([msgItem.comment rangeOfString:@"7xlsvh.com1.z0.glb.clouddn.com"].location!=NSNotFound) {
        _lblContent.text = SWStringMsgPic;
      }else{
        _lblContent.text = msgItem.comment;
      }
    }else if ([msgItem.mType integerValue] == SWNoticeTypeLike){
      _lblContent.text = SWStringLikedYou;
      _imageViewLike.hidden = NO;
      _lblContent.hidden = YES;
      _imageViewLike.image = [UIImage imageNamed:@"like_export_export_greylight"];
    }else{
      _lblContent.hidden = YES;
      _imageViewLike.hidden = YES;
    }
    [_btnFeed addTarget:self action:@selector(onFeedClick) forControlEvents:UIControlEventTouchUpInside];
        
    [_btnFeed.customImageView sd_setImageWithURL:[NSURL URLWithString:[[msgItem.feed firstPicUrl] stringByAppendingString:FEED_THUMB]]];
  }
  _lblTime.text = [NSString time:[msgItem.time doubleValue] format:MHPrettyDateShortRelativeTime];
  [_lblTime sizeToFit];
  _lblTime.left = _lblName.left;
  _lblTime.top   = _lblContent.bottom+7;
  
}

- (void)onAvatarClick{
  _dot.hidden = YES;
  
  if (self.delegate && [self.delegate respondsToSelector:@selector(noticeCellDidPressAvatar:)]) {
    [self.delegate noticeCellDidPressAvatar:_msgItem];
  }
}

- (void)onFeedClick{
  _dot.hidden = YES;
  if (self.delegate && [self.delegate respondsToSelector:@selector(noticeCellDidPressFeed:)]) {
    [self.delegate noticeCellDidPressFeed:_msgItem];
  }
}
@end
