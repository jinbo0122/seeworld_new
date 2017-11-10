//
//  RelationshipCell.m
//
//
//  Created by liufz on 15/10/11.
//
//

#import "RelationshipCell.h"
#import "UIImageView+WebCache.h"
#import "SWHUD.h"
#import "RefreshRelationshipAPI.h"
#import "SWDefine.h"
#import "CommonResponse.h"

@interface RelationshipCell ()<UIAlertViewDelegate>
@property (strong, nonatomic)UIImageView  *iconAvatar;
@property (strong, nonatomic)UILabel      *lblName;
@property (strong, nonatomic)UIButton     *btnFollow;

@end

@implementation RelationshipCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
  if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    self.contentView.backgroundColor = [UIColor colorWithRGBHex:0xffffff];
    _btnFollow = [[UIButton alloc] initWithFrame:CGRectMake(UIScreenWidth-116, 21, 106, 28)];
    [self.contentView addSubview:_btnFollow];
    _btnFollow.customImageView = [[UIImageView alloc] initWithFrame:CGRectMake(70, 8, 13, 12)];
    [_btnFollow addSubview:_btnFollow.customImageView];
    [_btnFollow addTarget:self action:@selector(onFollowClicked:) forControlEvents:UIControlEventTouchUpInside];
    _btnFollow.titleLabel.font = [UIFont systemFontOfSize:11];
    [_btnFollow setTitleColor:[UIColor colorWithRGBHex:0x55acef] forState:UIControlStateNormal];
    
    _iconAvatar = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 50, 50)];
    _iconAvatar.layer.masksToBounds = YES;
    _iconAvatar.layer.cornerRadius = _iconAvatar.width/2.0;
    [self.contentView addSubview:_iconAvatar];
    
    _lblName = [UILabel initWithFrame:CGRectMake(_iconAvatar.right+10, 0, _btnFollow.left-_iconAvatar.right-20, 70)
                              bgColor:[UIColor clearColor]
                            textColor:[UIColor colorWithRGBHex:0x333333]
                                 text:@""
                        textAlignment:NSTextAlignmentLeft font:[UIFont systemFontOfSize:16]];
    [self.contentView addSubview:_lblName];
  }
  return self;
}

- (void)setPersonData:(PersonInfoData *)personData{
  _personData = personData;
  [_iconAvatar sd_setImageWithURL:[NSURL URLWithString:personData.head]
                 placeholderImage:[UIImage imageNamed:@"personprofile"]];
  _lblName.text = personData.name;
  
  _btnFollow.hidden = NO;
  if (_personData.relation == 1){
    [_btnFollow setTitle:@"追蹤中      " forState:UIControlStateNormal];
    _btnFollow.customImageView.image = [UIImage imageNamed:@"profile_status_follwing"];
    [_btnFollow setImage:nil forState:UIControlStateNormal];
  }else if (_personData.relation == 2 || _personData.relation == 4){
    [_btnFollow setTitle:@"" forState:UIControlStateNormal];
    [_btnFollow setImage:[UIImage imageNamed:@"notice_btn_follow"] forState:UIControlStateNormal];
    _btnFollow.customImageView.image = nil;
  }else if (_personData.relation == 3){
    [_btnFollow setTitle:@"互相追蹤      " forState:UIControlStateNormal];
    _btnFollow.customImageView.image = [UIImage imageNamed:@"profile_status_mutual_follwing"];
    [_btnFollow setImage:nil forState:UIControlStateNormal];
  }else{
    _btnFollow.hidden = YES;
  }
}

- (void)onFollowClicked:(id)sender {
  if (_personData.relation == 1 || _personData.relation == 3)
  {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"確定取消追蹤?" delegate:self cancelButtonTitle:SWStringCancel otherButtonTitles:SWStringOkay,nil];
    alert.delegate = self;
    [alert show];
  }
  else if (_personData.relation == 2 || _personData.relation == 4)
  {
    [self requsetRelationship:@"follow"];
  }
  else
  {
  }
}

- (UIEdgeInsets)layoutMargins{
  return UIEdgeInsetsZero;
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
  if (1 == buttonIndex) {
    [self requsetRelationship:@"unfollow"];
  }
}

- (void)requsetRelationship:(NSString *)action{
  RefreshRelationshipAPI *api = [[RefreshRelationshipAPI alloc] init];
  api.userId = D2IStr( _personData.dataIdentifier);
  api.action = action;
  [SWHUD showWaiting];
  [api startWithModelClass:[CommonResponse class] completionBlock:^(ModelMessage *message) {
    [SWHUD hideWaiting];
    if (message.isSuccess){
      if ([action isEqualToString:@"follow"]){
        [SWHUD showCommonToast:@"追蹤成功！"];
      }else{
        [SWHUD showCommonToast:@"取消追蹤成功！"];
      }
      if (self.relationshipChangedBlock) {
        self.relationshipChangedBlock(_personData,action);
      }
    }else{
      [SWHUD showCommonToast:(message.message.length == 0? @"请求失败！":message.message)];
    }
  }];
}

@end
