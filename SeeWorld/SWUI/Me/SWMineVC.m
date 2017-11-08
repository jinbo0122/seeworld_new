//
//  SWMineVC.m
//  SeeWorld
//
//  Created by Albert Lee on 5/16/16.
//  Copyright © 2016 SeeWorld. All rights reserved.
//

#import "SWMineVC.h"
#import "SWSettingVC.h"
#import "SWMineHeaderView.h"
#import "SWEditAvatarVC.h"
#import "SWEditCoverVC.h"
#import "SWActionSheetView.h"
#import "SWEditProfileVC.h"
#import "RelationshipViewController.h"
#import "SWFeedCell.h"
#import "SWFeedBigCell.h"
#import "GetUserInfoApi.h"
#import "RefreshRelationshipAPI.h"
#import "SWHomeFeedReportView.h"
@interface SWMineVC ()<SWMineHeaderViewDelegate,UITableViewDelegate,UITableViewDataSource,
SWFeedCellDelegate,SWTagFeedsModelDelegate,SWFeedBigCellDelegate>
@property(nonatomic, strong)SWMineHeaderView  *headerView;
@property(nonatomic, strong)UITableView       *tableView;
@property(nonatomic, strong)SWTagFeedsModel   *model;
@end

@implementation SWMineVC
- (id)init{
  if (self = [super init]) {
    self.model = [[SWTagFeedsModel alloc] init];
    self.model.delegate = self;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor colorWithRGBHex:0x1a2531];
  [self refreshNavLine];
  
  _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width,
                                                             self.view.height-(self.user?0:49))
                                            style:UITableViewStylePlain];
  _tableView.delegate = self;
  _tableView.dataSource = self;
  _tableView.backgroundColor = [UIColor colorWithRGBHex:0x1a2531];
  _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  _tableView.contentInset = UIEdgeInsetsMake(-iOS7NavHeight, 0, 0, 0);
  [self.view addSubview:_tableView];
  
  _headerView = [[SWMineHeaderView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, 246)];
  _headerView.isEditMode = NO;_headerView.delegate = self;
  if (self.user) {
    SWFeedUserItem *user = [[SWConfigManager sharedInstance] userByUId:self.user.uId];
    if (user) {
      [_headerView refreshWithUser:user];
      _user = user;
    }else{
      [_headerView refreshWithUser:_user];
    }
  }else{
    [_headerView refreshWithUser:[SWConfigManager sharedInstance].user];
  }
  _tableView.tableHeaderView = _headerView;
  _model.userId = self.user?[self.user.uId stringValue]:[[SWConfigManager sharedInstance].user.uId stringValue];
  [_model loadCache];
  [_model getLatestTagFeeds];
  
  if (self.user) {
    [self refreshUserInfo];
  }
}

- (void)refreshUserInfo{
  GetUserInfoApi *api = [[GetUserInfoApi alloc] init];
  if (self.user) {
    api.userId = [self.user.uId stringValue];
  }else{
    api.userId = [[SWConfigManager sharedInstance].user.uId stringValue];
  }
  __weak typeof(self)wSelf = self;
  [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
    SWFeedUserItem *user = [SWFeedUserItem feedUserItemByDic:[[request.responseString safeJsonDicFromJsonString] safeDicObjectForKey:@"data"]];
    wSelf.user = user;
    [wSelf.headerView refreshWithUser:wSelf.user];
    [wSelf rightBar];
    [[SWConfigManager sharedInstance] saveUser:user];
  } failure:^(YTKBaseRequest *request) {
    
  }];
}

- (void)refresh{
  [self.model getLatestTagFeeds];
}

- (void)viewWillAppear:(BOOL)animated{
  [super viewWillAppear:animated];
  [self refreshNavLine];
}

- (void)viewDidAppear:(BOOL)animated{
  [super viewDidAppear:animated];
  [self refreshNavLine];
  [self refreshUserInfo];
  [_tableView reloadData];
}

- (void)viewDidDisappear:(BOOL)animated{
  [super viewDidDisappear:animated];
  [self recoverNavLine];
}

- (void)viewWillDisappear:(BOOL)animated{
  [super viewWillDisappear:animated];
  [self recoverNavLine];
}

- (void)refreshNavLine{
  self.navigationController.navigationBar.translucent = YES;
  [self.navigationController.navigationBar setBarTintColor:[UIColor clearColor]];
  self.navigationController.navigationBar.tintColor = [UIColor clearColor];
  [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                forBarMetrics:UIBarMetricsDefault];
  self.navigationController.navigationBar.shadowImage = [UIImage new];
  self.navigationItem.titleView = nil;
  [_tableView reloadData];
  [self rightBar];
}

- (void)recoverNavLine{
  self.navigationController.navigationBar.translucent = YES;
  self.navigationController.navigationBar.tintColor = [UIColor colorWithRGBHex:0x152c3e];
  [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRGBHex:0x152c3e]];
  [self.navigationController.navigationBar setBackgroundImage:nil
                                                forBarMetrics:UIBarMetricsDefault];
  self.navigationController.navigationBar.shadowImage = nil;
  [self.navigationController.navigationBar setBackgroundImage:nil
                                                forBarMetrics:UIBarMetricsDefault];
  self.navigationItem.titleView = [[ALTitleLabel alloc] initWithTitle:self.user?self.user.name:[SWConfigManager sharedInstance].user.name
                                                                color:[UIColor whiteColor]];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle{
  return UIStatusBarStyleLightContent;
}

- (void)rightBar{
  if ([self.user.uId isEqualToNumber:[SWConfigManager sharedInstance].user.uId]||!self.user) {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"profile_btn_setting"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(onSettingClicked)];
  }else{
    SWUserRelationType relation = [self.user.relation integerValue];
    BOOL hasFollow = (relation==SWUserRelationTypeFollowing||relation==SWUserRelationTypeInterFollow);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:hasFollow?@"profile_btn_unfollw":@"profile_btn_follw"]
                                                                                     imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(onFollowClick)];
    
  }
}

- (void)onFollowClick{
  RefreshRelationshipAPI *api = [[RefreshRelationshipAPI alloc] init];
  api.userId = [self.user.uId stringValue];
  SWUserRelationType relation = [self.user.relation integerValue];
  BOOL hasFollow = (relation==SWUserRelationTypeFollowing||relation==SWUserRelationTypeInterFollow);
  NSString *action = hasFollow?@"unfollow":@"follow";
  api.action = action;
  self.user.relation = @(hasFollow?SWUserRelationTypeUnrelated:SWUserRelationTypeFollowing);
  [self rightBar];
  __weak typeof(self)wSelf = self;
  [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
    [wSelf refreshUserInfo];
    if ([action isEqualToString:@"follow"]) {
      [SWUserAddFollowAPI showSuccessTip];
    }else{
      [SWUserRemoveFollowAPI showSuccessTip];
    }
  } failure:^(YTKBaseRequest *request) {
    [wSelf refreshUserInfo];
  }];
}

- (void)onSettingClicked{
  SWSettingVC *vc = [[SWSettingVC alloc] init];
  vc.hidesBottomBarWhenPushed = YES;
  [self.navigationController pushViewController:vc animated:YES];
}

- (void)mineHeaderViewDidNeedEditCover:(SWMineHeaderView *)header{
  if (!self.user || [self.user.uId isEqualToNumber:[SWConfigManager sharedInstance].user.uId]) {
    __weak typeof(self)wSelf = self;
    SWActionSheetView *action = [[SWActionSheetView alloc] initWithFrame:[UIScreen mainScreen].bounds title:nil content:@"更換封面照片"];
    action.completeBlock = ^{
      SWEditCoverVC *vc = [[SWEditCoverVC alloc] init];
      UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
      [wSelf presentViewController:nav animated:YES completion:nil];
    };
    [action show];
  }
}

- (void)mineHeaderViewDidNeedEditAvatar:(SWMineHeaderView *)header{
  if (!self.user || [self.user.uId isEqualToNumber:[SWConfigManager sharedInstance].user.uId]) {
    __weak typeof(self)wSelf = self;
    SWActionSheetView *action = [[SWActionSheetView alloc] initWithFrame:[UIScreen mainScreen].bounds title:nil content:@"更換大頭照"];
    action.completeBlock = ^{
      SWEditAvatarVC *vc = [[SWEditAvatarVC alloc] init];
      UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
      [wSelf presentViewController:nav animated:YES completion:nil];
    };
    [action show];
  }
}

- (void)mineHeaderDidNeedGoFollowing:(SWMineHeaderView *)header{
  UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
  RelationshipViewController *vc = [sb instantiateViewControllerWithIdentifier:@"RelationshipViewController"];
  vc.userId = self.user?[self.user.uId stringValue]:[[SWConfigManager sharedInstance].user.uId stringValue];
  vc.type = eRelationshipTypeFollows;
  vc.hidesBottomBarWhenPushed = YES;
  [self.navigationController pushViewController:vc animated:YES];
}

- (void)mineHeaderDidNeedGoFollower:(SWMineHeaderView *)header{
  UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
  RelationshipViewController *vc = [sb instantiateViewControllerWithIdentifier:@"RelationshipViewController"];
  vc.userId = self.user?[self.user.uId stringValue]:[[SWConfigManager sharedInstance].user.uId stringValue];
  vc.type = eRelationshipTypeFollowers;
  vc.hidesBottomBarWhenPushed = YES;
  [self.navigationController pushViewController:vc animated:YES];
}

- (void)mineHeaderDidPressEdit:(SWMineHeaderView *)header{
  SWEditProfileVC *vc = [[SWEditProfileVC alloc] init];
  vc.hidesBottomBarWhenPushed = YES;
  [self.navigationController pushViewController:vc animated:YES];
}

- (void)mineHeaderDidPressChat:(SWMineHeaderView *)header{
  SWMsgVC *chat = [[SWMsgVC alloc]init];
  chat.conversationType = ConversationType_PRIVATE;
  chat.targetId = [self.user.uId stringValue];
  chat.title = self.user.name;
  [[SWChatModel sharedInstance] saveUser:[self.user.uId stringValue] name:self.user.name picUrl:self.user.picUrl];
  [self.navigationController pushViewController:chat animated:YES];
}

- (void)mineHeaderDidPressMode:(SWMineHeaderView *)header{
  [_tableView reloadData];
}

- (void)mineHeaderDidPressMore:(SWMineHeaderView *)header{
  __weak typeof(self)wSelf = self;
  SWActionSheetView *action = [[SWActionSheetView alloc] initWithFrame:[UIScreen mainScreen].bounds title:nil content:@"舉報"];
  action.completeBlock = ^{
    SWHomeFeedReportView *reportView = [[SWHomeFeedReportView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    reportView.userId = [wSelf.user.uId stringValue];
    [reportView show];
  };
  [action show];
}

#pragma mark Table View
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  NSInteger row = (self.model.feeds.count/2)+(self.model.feeds.count%2==0?0:1);
  return _headerView.btnMode.tag?row:self.model.feeds.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  return _headerView.btnMode.tag?[SWFeedCell height]:[SWFeedBigCell height];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  if (_headerView.btnMode.tag) {
    static NSString *identifier = @"feed";
    SWFeedCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
      cell = [[SWFeedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    NSInteger location = indexPath.row*2;
    NSInteger length = indexPath.row*2+2>=self.model.feeds.count?
    (self.model.feeds.count-indexPath.row*2):2;
    
    if (self.model.feeds.count==0) {
      [cell refreshThumbCell:@[] row:indexPath.row];
    }else{
      [cell refreshThumbCell:[self.model.feeds subarrayWithRange:NSMakeRange(location, length)] row:indexPath.row];
    }
    cell.contentView.backgroundColor = [UIColor colorWithRGBHex:0x1a2531];
    cell.delegate = self;
    return cell;
  }else{
    static NSString *identifier = @"big";
    SWFeedBigCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
      cell = [[SWFeedBigCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell refreshThumbCell:[self.model.feeds safeObjectAtIndex:indexPath.row] row:indexPath.row];
    cell.delegate = self;
    return cell;
  }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
  CGSize size = scrollView.contentSize;
  float y = scrollView.contentOffset.y + scrollView.bounds.size.height - scrollView.contentInset.bottom;
  float h = size.height;
  
  float reload_distance = -10;
  if(y > h + reload_distance && size.height>300) {
    [self.model getMoreTagFeeds];
  }
  
  if (scrollView.contentOffset.y>_headerView.height) {
    [self recoverNavLine];
  }else{
    [self refreshNavLine];
  }
}

#pragma mark Cell Delegate
- (void)feedCellDidPressThumb:(SWFeedItem *)feedItem index:(NSInteger)index{
  SWFeedDetailScrollVC *vc = [[SWFeedDetailScrollVC alloc] init];
  vc.model = self.model;
  vc.currentIndex = index;
  vc.hidesBottomBarWhenPushed = YES;
  [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark Model Delegate
- (void)tagFeedModelDidLoadContents:(SWTagFeedsModel *)model{
  [self.tableView reloadData];
}
@end
