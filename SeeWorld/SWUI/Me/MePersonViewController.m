//
//  MePersonViewController.m
//  SeeWorld
//
//  Created by  on 15/8/11.
//  Copyright (c) 2015年 SeeWorld. All rights reserved.
//

#import "MePersonViewController.h"
#import "SWDefine.h"
#import "UIImageView+WebCache.h"
#import "SettingTableViewController.h"
#import "GetUserInfoApi.h"
#import "PersonInfoResponse.h"
#import "PersonInfoData.h"
#import "SWTagFeedsVC.h"
#import "RegisterProfileViewController.h"
#import "RelationshipViewController.h"
#import "RefreshRelationshipAPI.h"
#import "CommonResponse.h"

@interface MePersonViewController ()<UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *editProfileView;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *followedCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *followerCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *feedCountLabel;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) SWTagFeedsVC *childVC;
@property (weak, nonatomic) IBOutlet UIView *followView;
@property (weak, nonatomic) IBOutlet UIView *followerView;
@property (weak, nonatomic) IBOutlet UIImageView *relationshipImageView;
@property (weak, nonatomic) IBOutlet UILabel *relationshipLabel;
@property (strong, nonatomic)UIButton *btnChat;

@end

@implementation MePersonViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self.navigationController setNavigationBarHidden:NO];
  [self initView];
  [self updatePersonInfo];
}

- (void)viewDidAppear:(BOOL)animated{
  [super viewDidAppear:animated];
  [_childVC.tbVC.tableView reloadData];
}

- (void)initView
{
  _editProfileView.layer.cornerRadius = 2.5;
  _editProfileView.layer.borderColor = [UIColor hexChangeFloat:@"D8D8D8"].CGColor;
  _editProfileView.layer.borderWidth = 2;
  [_editProfileView addGestureTabRecognizerWithTarget:self action:@selector(editProfile)];
  _headerImageView.layer.cornerRadius = _headerImageView.height/2;
  _headerImageView.layer.masksToBounds = YES;
  _headerImageView.contentMode = UIViewContentModeScaleToFill;
  self.navigationItem.titleView = [[ALTitleLabel alloc] initWithTitle:_person.name
                                                                color:[UIColor whiteColor]
                                                             fontSize:18];
  [_headerImageView sd_setImageWithURL:[NSURL URLWithString:_person.head] placeholderImage:[UIImage imageNamed:@"defaultphoto"]];
  
  if (nil == _person)
  {
    self.isMe = YES;
  }
  else if (_person.dataIdentifier == ((NSString *)[[NSUserDefaults standardUserDefaults] safeStringObjectForKey:@"userId"]).integerValue)
  {
    self.isMe = YES;
  }
  
  if (self.isMe)
  {
    self.relationshipImageView.image = [UIImage imageNamed:@"personprofile"];
    self.relationshipLabel.text = @"编辑个人资料";
    _editProfileView.userInteractionEnabled = NO;
    [self showSettingButton];
  }
  else
  {
    [self updateRelationship];
    self.navigationItem.rightBarButtonItem = nil;
  }
  
  [_followView addGestureTabRecognizerWithTarget:self action:@selector(showFollows)];
  [_followerView addGestureTabRecognizerWithTarget:self action:@selector(showFollowers)];
  [self refreshPersonInfo];
  
  
  if (!self.isMe) {
    self.btnChat = [[UIButton alloc] initWithFrame:CGRectMake(0, self.view.height-55, self.view.width, 55)];
    [self.btnChat setBackgroundColor:[UIColor colorWithRGBHex:0x30323a alpha:0.9]];
    [self.btnChat setImage:[UIImage imageNamed:@"message"] forState:UIControlStateNormal];
    [self.view addSubview:self.btnChat];
    [self.btnChat addTarget:self action:@selector(onChatClicked) forControlEvents:UIControlEventTouchUpInside];
  }
}

- (void)onChatClicked{
  SWMsgVC *chat = [[SWMsgVC alloc]init];
  chat.conversationType = ConversationType_PRIVATE;
  chat.targetId = [self userId];
  chat.title = self.person.name;
  [[SWChatModel sharedInstance] saveUser:[self userId] name:self.person.name picUrl:self.person.head];
  [self.navigationController pushViewController:chat animated:YES];
}

-(void)showFollowers
{
  [self showRelationship:eRelationshipTypeFollowers];
}

-(void)showFollows
{
  [self showRelationship:eRelationshipTypeFollows];
}

- (void)showRelationship:(RelationshipType)type
{
  UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
  RelationshipViewController *vc = [sb instantiateViewControllerWithIdentifier:@"RelationshipViewController"];
  vc.userId = _isMe? [[NSUserDefaults standardUserDefaults] safeStringObjectForKey:@"userId"]:D2IStr(_person.dataIdentifier);
  vc.type = type;
  vc.hidesBottomBarWhenPushed = YES;
  [self.navigationController pushViewController:vc animated:YES];
}


- (void)editProfile
{
  if (self.isMe)
  {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Profile" bundle:nil];
    RegisterProfileViewController *vc = [sb instantiateViewControllerWithIdentifier:@"RegisterProfileViewController"];
    vc.profileType = eProfileViewTypeEdit;
    vc.person = self.person;
    vc.headerImage.image = self.headerImageView.image;
    [self.navigationController pushViewController:vc animated:YES];
  }
  else
  {
    if (_person.relation == 1 || _person.relation == 3)
    {
      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定取消关注?" delegate:self cancelButtonTitle:SWStringCancel otherButtonTitles:SWStringOkay,nil];
      alert.delegate = self;
      [alert show];
    }
    else if (_person.relation == 2 || _person.relation == 4)
    {
      [self requsetRelationship:@"follow"];
    }
    else
    {
    }
  }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
  if (1 == buttonIndex) {
    [self requsetRelationship:@"unfollow"];
  }
}

- (void)requsetRelationship:(NSString *)action
{
  RefreshRelationshipAPI *api = [[RefreshRelationshipAPI alloc] init];
  api.userId = D2IStr( _person.dataIdentifier);
  api.action = action;
  [SWHUD showWaiting];
  [api startWithModelClass:[CommonResponse class] completionBlock:^(ModelMessage *message) {
    [SWHUD hideWaiting];
    if (message.isSuccess)
    {
      if ([action isEqualToString:@"follow"])
      {
        [SWHUD showCommonToast:@"关注成功！"];
        if (_person.relation == 2)
        {
          _person.relation = 3;
        }
        else if (_person.relation == 4)
        {
          _person.relation = 1;
        }
        _person.followedCount = _person.followedCount + 1;
      }
      else
      {
        [SWHUD showCommonToast:@"取消关注成功！"];
        if (_person.relation == 1)
        {
          _person.relation = 4;
        }
        else if (_person.relation == 3)
        {
          _person.relation = 2;
        }
        _person.followerCount = _person.followerCount - 1;
      }
      
      [self updatePersonInfo];
    }
    else
    {
      [SWHUD showCommonToast:(message.message.length == 0? @"请求失败！":message.message)];
    }
  }];
}

- (void)updateRelationship
{
  self.editProfileView.hidden = NO;
  if (self.isMe)
  {
    return;
  }
  if (_person.relation == 1)
  {
    self.relationshipImageView.image = [UIImage imageNamed:@"personfollowed"];
    self.relationshipLabel.text = @"已关注";
  }
  else if (_person.relation == 2 || _person.relation == 4)
  {
    self.relationshipImageView.image = [UIImage imageNamed:@"personfollow"];
    self.relationshipLabel.text = @"未关注";
  }
  else if (_person.relation == 3)
  {
    self.relationshipImageView.image = [UIImage imageNamed:@"personfolloweachother"];
    self.relationshipLabel.text = @"相互关注";
  }
  else
  {
    self.editProfileView.hidden = YES;
  }
}

- (void)updatePersonInfo
{
  [self updateRelationship];
  if (_person.head.length > 0)
  {
    [_headerImageView sd_setImageWithURL:[NSURL URLWithString:_person.head] placeholderImage:[UIImage imageNamed:@"personprofile"]];
  }
  self.navigationItem.titleView = [[ALTitleLabel alloc] initWithTitle:_person.name
                                                                color:[UIColor whiteColor]
                                                             fontSize:18];
  self.followedCountLabel.text = D2IStr(_person.followedCount);
  self.followerCountLabel.text = D2IStr(_person.followerCount);
  self.feedCountLabel.text = D2IStr(_person.feedCount);
  self.descriptionLabel.text = _person.dataDescription;
}

- (NSString *)userId
{
  if (nil == _person || self.isMe)
  {
    return @"self";
  }
  else
  {
    return D2IStr(_person.dataIdentifier);
  }
}

- (void)refreshPersonInfo
{
  GetUserInfoApi *api = [[GetUserInfoApi alloc] init];
  api.userId = [self userId];
  __weak GetUserInfoApi *wapi = api;
  [api startWithModelClass:[PersonInfoResponse class] completionBlock:^(ModelMessage *message) {
    if (message.isSuccess)
    {
      PersonInfoResponse *response = message.object;
      self.person = response.data;
      if (self.isMe) {
        [[NSUserDefaults standardUserDefaults] setSafeStringObject:D2IStr(_person.dataIdentifier) forKey:@"userId"];
      }
      
      _editProfileView.userInteractionEnabled = YES;
      [self updatePersonInfo];
      
      if (!_childVC)
      {
        _childVC = [[SWTagFeedsVC alloc] init];
        
        _childVC.model.userId = wapi.userId;
        _childVC.hidesBottomBarWhenPushed = YES;
        _childVC.view.frame = self.containerView.bounds;
        _childVC.view.top-=20;
        _childVC.view.height+=20;
        [self addChildViewController:_childVC];
        [self.containerView addSubview:_childVC.view];
      }
      
      [self.view bringSubviewToFront:self.btnChat];
    }
  }];
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  [self refreshPersonInfo];
}

- (void)showSettingButton{
  self.navigationItem.rightBarButtonItem = [UIBarButtonItem loadRightBarButtonItemWithImage:@"setting"
                                                                                       rect:CGRectMake(20, 14.5, 15, 15)
                                                                                     target:self
                                                                                     action:@selector(onSettingButtonClicked)];
}

- (void)onSettingButtonClicked
{
  UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Setting" bundle:nil];
  SettingTableViewController *vc = [sb instantiateInitialViewController];
  vc.person = self.person;
  [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
