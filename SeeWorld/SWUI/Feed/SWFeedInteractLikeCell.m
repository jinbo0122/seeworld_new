//
//  SWFeedInteractLikeCell.m
//  SeeWorld
//
//  Created by Albert Lee on 9/2/15.
//  Copyright (c) 2015 SeeWorld. All rights reserved.
//

#import "SWFeedInteractLikeCell.h"

@implementation SWFeedInteractLikeCell{
  UIImageView *_iconAvatar;
  UILabel     *_lblName;
  UILabel     *_lblTime;
  UIButton    *_btnFollow;
  SWFeedLikeItem *_likeItem;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
  if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    self.contentView.backgroundColor = [UIColor colorWithRGBHex:0x1a2531];
    _iconAvatar = [[UIImageView alloc] initWithFrame:CGRectMake(13, 13, 40, 40)];
    _iconAvatar.layer.masksToBounds = YES;
    _iconAvatar.layer.borderColor = [UIColor whiteColor].CGColor;
    _iconAvatar.layer.borderWidth = 2.0;
    _iconAvatar.layer.cornerRadius  = _iconAvatar.width/2.0;
    [self.contentView addSubview:_iconAvatar];
    
    _lblName = [UILabel initWithFrame:CGRectMake(_iconAvatar.right+10, 15, UIScreenWidth-140, 19.5)
                              bgColor:[UIColor clearColor]
                            textColor:[UIColor colorWithRGBHex:0x838cda]
                                 text:@""
                        textAlignment:NSTextAlignmentLeft
                                 font:[UIFont systemFontOfSize:14]];
    [self.contentView addSubview:_lblName];
    
    _lblTime = [UILabel initWithFrame:CGRectMake(_lblName.left, _lblName.bottom+10, _lblName.width, 11.5)
                              bgColor:[UIColor clearColor]
                            textColor:[UIColor colorWithRGBHex:0x9b9b9b alpha:0.6]
                                 text:@""
                        textAlignment:NSTextAlignmentLeft
                                 font:[UIFont systemFontOfSize:11]];
    [self.contentView addSubview:_lblTime];
    
    _btnFollow = [[UIButton alloc] initWithFrame:CGRectMake(UIScreenWidth-121, 19, 106, 28)];
    [self.contentView addSubview:_btnFollow];
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

- (UIEdgeInsets)layoutMargins{
  return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (void)refreshLike:(SWFeedLikeItem *)likeItem{
  _likeItem = likeItem;
  
  [_iconAvatar sd_setImageWithURL:[NSURL URLWithString:[likeItem.user.picUrl stringByAppendingString:@"-avatar120"]]];
  _lblName.text = likeItem.user.name;
  _lblTime.text = [NSString time:[likeItem.time doubleValue] format:MHPrettyDateShortRelativeTime];
  
  [self refreshButton];
  [_btnFollow addTarget:self action:@selector(onFollowClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)refreshUser:(SWFeedUserItem *)userItem{
  _likeItem = [[SWFeedLikeItem alloc] init];
  _likeItem.user = userItem;
  _likeItem.time = @0;
  
  [_iconAvatar sd_setImageWithURL:[NSURL URLWithString:userItem.picUrl]];
  _lblName.text = userItem.name;
  
  _lblName.top = 25;
  
  [self refreshButton];
  [_btnFollow addTarget:self action:@selector(onFollowClick) forControlEvents:UIControlEventTouchUpInside];
}

+ (CGFloat)heightOfLike:(SWFeedLikeItem *)likeItem{
  return 70;
}

- (void)onFollowClick{
  SWUserRelationType relationType = [_likeItem.user.relation integerValue];

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
  
  _likeItem.user.relation = [NSNumber numberWithInteger:relationType];
  [self refreshButton];
  
  if (self.delegate && [self.delegate respondsToSelector:@selector(feedInteractLikeCellDidPressFollow:)]) {
    [self.delegate feedInteractLikeCellDidPressFollow:_likeItem];
  }
}

- (void)refreshButton{
  SWUserRelationType relationType = [_likeItem.user.relation integerValue];
  if (relationType == 0 || [_likeItem.user.uId isEqualToNumber:@0]) {
    _btnFollow.hidden = YES;
  }else{
    _btnFollow.hidden = NO;
    switch (relationType) {
      case SWUserRelationTypeFollowing:{
        [_btnFollow setImage:nil forState:UIControlStateNormal];
      }break;
      case SWUserRelationTypeFollowed:{
        [_btnFollow setImage:[UIImage imageNamed:@"home_btn_add_friend"] forState:UIControlStateNormal];
      }break;
      case SWUserRelationTypeInterFollow:{
        [_btnFollow setImage:nil forState:UIControlStateNormal];
      }break;
      case SWUserRelationTypeUnrelated:{
        [_btnFollow setImage:[UIImage imageNamed:@"home_btn_add_friend"] forState:UIControlStateNormal];
      }break;
        
      default:{
        [_btnFollow setImage:[UIImage imageNamed:@"home_btn_add_friend"] forState:UIControlStateNormal];
      }break;
    }
  }
  _btnFollow.tag = relationType;
}
@end
