//
//  SWUserListCell.m
//  SeeWorld
//
//  Created by Albert Lee on 15/11/2017.
//  Copyright © 2017 SeeWorld. All rights reserved.
//

#import "SWUserListCell.h"
#import "RefreshRelationshipAPI.h"
@implementation SWUserListCell{
  UIImageView *_avatarView;
  UILabel     *_lblName;
  UIButton    *_btnFollow;
  SWFeedUserItem *_user;
}

- (void)awakeFromNib {
  [super awakeFromNib];
  // Initialization code
}

- (UIEdgeInsets)layoutMargins{
  return UIEdgeInsetsMake(0, 62.5, 0, 0);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
  if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    _avatarView = [[UIImageView alloc] initWithFrame:CGRectMake(7.5, 7.5, 45, 45)];
    _avatarView.layer.masksToBounds = YES;
    _avatarView.layer.cornerRadius = _avatarView.height/2.0;
    [self.contentView addSubview:_avatarView];
    
    _lblName = [UILabel initWithFrame:CGRectZero
                              bgColor:[UIColor clearColor]
                            textColor:[UIColor colorWithRGBHex:0x34414e]
                                 text:@""
                        textAlignment:NSTextAlignmentLeft
                                 font:[UIFont systemFontOfSize:17]];
    [self.contentView addSubview:_lblName];
    
    _btnFollow = [[UIButton alloc] initWithFrame:CGRectZero];
    [_btnFollow setImage:nil text:@"" textColorHex:0x55acef fontSize:13];
    [self.contentView addSubview:_btnFollow];
    [_btnFollow addTarget:self action:@selector(onFollowClicked) forControlEvents:UIControlEventTouchUpInside];
  }
  return self;
}

- (void)refreshWithUser:(SWFeedUserItem *)user{
  _user = user;
  [_avatarView sd_setImageWithURL:[NSURL URLWithString:user.picUrl]];
  _lblName.text = user.name;
  [_lblName sizeToFit];
  _lblName.frame = CGRectMake(_avatarView.right+10, (59-_lblName.height)/2.0,
                              MIN(_lblName.width, UIScreenWidth-110-_avatarView.right-10),
                              _lblName.height);
  
  [self refreshFollowStatus];
}

- (void)onFollowClicked{
  RefreshRelationshipAPI *api = [[RefreshRelationshipAPI alloc] init];
  api.userId = [_user.uId stringValue];
  SWUserRelationType relation = [_user.relation integerValue];
  BOOL hasFollow = (relation==SWUserRelationTypeFollowing||relation==SWUserRelationTypeInterFollow);
  NSString *action = hasFollow?@"unfollow":@"follow";
  api.action = action;
  _user.relation = @(hasFollow?SWUserRelationTypeUnrelated:SWUserRelationTypeFollowing);
  [self refreshFollowStatus];
  [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
    if ([action isEqualToString:@"follow"]) {
      [SWUserAddFollowAPI showSuccessTip];
    }else{
      [SWUserRemoveFollowAPI showSuccessTip];
    }
  } failure:^(YTKBaseRequest *request) {
  }];
}

- (void)refreshFollowStatus{
  if ([_user.uId isEqualToNumber:[SWConfigManager sharedInstance].user.uId]) {
    _btnFollow.hidden = YES;
  }else{
    _btnFollow.hidden = NO;
  }
  SWUserRelationType relation = [_user.relation integerValue];
  NSString *resource = relation==SWUserRelationTypeFollowing?@"followed_highlight":(relation==SWUserRelationTypeInterFollow?@"followeeachother_highlight":@"followe_highlight");
  NSString *status = relation==SWUserRelationTypeFollowing?@"追蹤中":(relation==SWUserRelationTypeInterFollow?@"互相追蹤":@"追蹤TA");
  _btnFollow.customImageView.image = [UIImage imageNamed:resource];
  _btnFollow.lblCustom.text = status;
  [_btnFollow.customImageView sizeToFit];
  [_btnFollow.lblCustom sizeToFit];
  _btnFollow.frame = CGRectMake(UIScreenWidth-23-_btnFollow.customImageView.width-8.5-_btnFollow.lblCustom.width,
                                0, _btnFollow.customImageView.width+8.5+_btnFollow.lblCustom.width, 59);
  _btnFollow.lblCustom.top = (_btnFollow.height-_btnFollow.lblCustom.height)/2.0;
  _btnFollow.customImageView.left = _btnFollow.lblCustom.right+8.5;
  _btnFollow.customImageView.top = (_btnFollow.height-_btnFollow.customImageView.height)/2.0;
}
@end
