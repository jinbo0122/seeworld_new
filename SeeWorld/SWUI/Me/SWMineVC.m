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
#import "SWFeedCell.h"
#import "SWHomeFeedCell.h"
#import "GetUserInfoApi.h"
#import "RefreshRelationshipAPI.h"
#import "SWHomeFeedReportView.h"
#import "SWAgreementVC.h"
#import "SWHomeFeedShareView.h"
#import "SWFeedTagButton.h"
#import "SWUserListVC.h"
#import <AVKit/AVKit.h>
@interface SWMineVC ()<SWMineHeaderViewDelegate,UITableViewDelegate,UITableViewDataSource,
SWTagFeedsModelDelegate,SWHomeFeedCellDelegate,UIDocumentInteractionControllerDelegate,
SWFeedInteractVCDelegate>
@property(nonatomic, strong)SWMineHeaderView  *headerView;
@property(nonatomic, strong)UITableView       *tableView;
@property(nonatomic, strong)SWTagFeedsModel   *model;
@property(nonatomic, strong)UIDocumentInteractionController *documentController;
@end

@implementation SWMineVC{
  BOOL _isNavRefreshed;
  BOOL _isNavRecovered;
}
- (id)init{
  if (self = [super init]) {
    self.model = [[SWTagFeedsModel alloc] init];
    self.model.delegate = self;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor colorWithRGBHex:0xe8edf3];
  [self refreshNavLine];
  
  _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width,
                                                             self.view.height-(self.user?0:49))
                                            style:UITableViewStylePlain];
  _tableView.delegate = self;
  _tableView.dataSource = self;
  _tableView.backgroundColor = [UIColor colorWithRGBHex:0xe8edf3];
  _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  _tableView.contentInset = UIEdgeInsetsMake((isRunningOnIOS11?0:(-iOSNavHeight)), 0, 49+iphoneXBottomAreaHeight, 0);
  _tableView.estimatedRowHeight = 0;
  _tableView.estimatedSectionFooterHeight = 0;
  _tableView.estimatedSectionHeaderHeight = 0;
  [self.view addSubview:_tableView];
  if (@available(iOS 11.0, *)) {
    _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
  }
  
  _headerView = [[SWMineHeaderView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, 360.5+iOSTopHeight)];
  _headerView.isEditMode = NO;
  _headerView.delegate = self;
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
  [_model loadCache];
  [_model getLatestTagFeeds];
}

- (void)setUser:(SWFeedUserItem *)user{
  _user = user;
  _model.userId = _user?[_user.uId stringValue]:[[SWConfigManager sharedInstance].user.uId stringValue];
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
  [self refresh];
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
  if (_isNavRefreshed) {
    return;
  }
  _isNavRefreshed = YES;
  _isNavRecovered = NO;
  self.navigationController.navigationBar.translucent = YES;
  [self.navigationController.navigationBar setBarTintColor:[UIColor clearColor]];
  self.navigationController.navigationBar.tintColor = [UIColor clearColor];
  [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                forBarMetrics:UIBarMetricsDefault];
  self.navigationController.navigationBar.shadowImage = [UIImage new];
  self.navigationItem.titleView = nil;
  [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
  [_tableView reloadData];
  [self rightBarNeedSetting:NO];
}

- (void)recoverNavLine{
  if (_isNavRecovered) {
    return;
  }
  _isNavRecovered = YES;
  _isNavRefreshed = NO;
  [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
  self.navigationController.navigationBar.translucent = YES;
  self.navigationController.navigationBar.tintColor = [UIColor colorWithRGBHex:0xffffff];
  [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRGBHex:0xffffff]];
  [self.navigationController.navigationBar setBackgroundImage:nil
                                                forBarMetrics:UIBarMetricsDefault];
  self.navigationController.navigationBar.shadowImage = nil;
  [self.navigationController.navigationBar setBackgroundImage:nil
                                                forBarMetrics:UIBarMetricsDefault];
  self.navigationItem.titleView = [[ALTitleLabel alloc] initWithTitle:self.user?self.user.name:[SWConfigManager sharedInstance].user.name
                                                                color:[UIColor colorWithRGBHex:NAV_BAR_COLOR_HEX]];
  [self rightBarNeedSetting:YES];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle{
  return UIStatusBarStyleDefault;
}

- (void)rightBar{
  [self rightBarNeedSetting:NO];
}

- (void)rightBarNeedSetting:(BOOL)needSetting{
  if ([SWConfigManager sharedInstance].user&& ([self.user.uId isEqualToNumber:[SWConfigManager sharedInstance].user.uId]||!self.user)) {
    if (needSetting) {
      self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"profile_btn_setting"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                                                style:UIBarButtonItemStylePlain
                                                                               target:self
                                                                               action:@selector(onSettingClicked)];

    }else{
      self.navigationItem.rightBarButtonItem = nil;
    }
  }else{
    self.navigationItem.rightBarButtonItem = nil;
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
  [_headerView refreshWithUser:self.user];
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
  SWUserListVC *vc = [[SWUserListVC alloc] init];
  vc.model.uId = self.user?[self.user.uId stringValue]:[[SWConfigManager sharedInstance].user.uId stringValue];
  vc.model.title = @"追蹤列表";
  vc.model.type = SWUserListAPITypeGetFollowing;
  vc.hidesBottomBarWhenPushed = YES;
  [self.navigationController pushViewController:vc animated:YES];
}

- (void)mineHeaderDidNeedGoFollower:(SWMineHeaderView *)header{
  SWUserListVC *vc = [[SWUserListVC alloc] init];
  vc.model.uId = self.user?[self.user.uId stringValue]:[[SWConfigManager sharedInstance].user.uId stringValue];
  vc.model.title = @"粉絲列表";
  vc.model.type = SWUserListAPITypeGetFollower;
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
  chat.titleText = self.user.name;
  [[SWChatModel sharedInstance] saveUser:[self.user.uId stringValue] name:self.user.name picUrl:self.user.picUrl];
  [self.navigationController pushViewController:chat animated:YES];
}

- (void)mineHeaderDidPressMore:(SWMineHeaderView *)header{
  __weak typeof(self)wSelf = self;
  SWActionSheetView *action = [[SWActionSheetView alloc] initWithFrame:[UIScreen mainScreen].bounds title:nil content:@"檢舉"];
  action.completeBlock = ^{
    SWHomeFeedReportView *reportView = [[SWHomeFeedReportView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    reportView.userId = [wSelf.user.uId stringValue];
    [reportView show];
  };
  [action show];
}

- (void)mineHeaderDidPressPost:(SWMineHeaderView *)header{
  TabViewController *tabVC = (TabViewController *)[UIApplication sharedApplication].delegate.window.rootViewController;
  if ([tabVC isKindOfClass:[TabViewController class]]) {
    [tabVC compose];
  }
}

- (void)mineHeaderDidPressFollow:(SWMineHeaderView *)header{
  [self onFollowClick];
}

- (void)mineHeaderDidPressSetting:(SWMineHeaderView *)header{
  [self onSettingClicked];
}

#pragma mark Table View Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  return [self.model.feeds count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  return [SWHomeFeedCell heightByFeed:[self.model.feeds safeObjectAtIndex:indexPath.row]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  static NSString *identifier = @"feed";
  SWHomeFeedCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
  if (!cell) {
    cell = [[SWHomeFeedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
  }
  [cell refreshHomeFeed:[self.model.feeds safeObjectAtIndex:indexPath.row] row:indexPath.row];
  cell.delegate = self;
  return cell;
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
- (void)homeFeedCellDidPressUser:(SWFeedUserItem *)userItem{
  [SWFeedUserItem pushUserVC:userItem nav:self.navigationController];
}

- (void)homeFeedCellDidPressLike:(SWFeedItem *)feedItem row:(NSInteger)row{
  [self.model likeClickedByRow:row];
}

- (void)homeFeedCellDidPressReply:(SWFeedItem *)feedItem row:(NSInteger)row enableKeyboard:(BOOL)enableKeyboard{
  SWFeedDetailScrollVC *vc = [[SWFeedDetailScrollVC alloc] init];
  vc.model = _model;
  vc.currentIndex = row;
  vc.hidesBottomBarWhenPushed = YES;
  vc.needEnableKeyboardOnLoad = enableKeyboard;
  [self.navigationController pushViewController:vc animated:YES];
}

- (void)homeFeedCellDidPressUrl:(NSURL *)url row:(NSInteger)row{
  ALWebVC *vc = [[ALWebVC alloc] init];
  vc.url = url.absoluteString;
  vc.hidesBottomBarWhenPushed = YES;
  [self.navigationController pushViewController:vc animated:YES];
}

- (void)homeFeedCellDidPressShare:(SWFeedItem *)feedItem row:(NSInteger)row{
  SWHomeFeedShareView *shareView = [[SWHomeFeedShareView alloc] initWithFrame:[UIScreen mainScreen].bounds];
  [shareView show];
  
  SWHomeFeedCell *cell = (SWHomeFeedCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
  
  for (SWFeedTagButton *button in [cell.feedImageView subviews]) {
    if ([button isKindOfClass:[SWFeedTagButton class]]) {
      button.tagHoverImageView.hidden = YES;
      button.tagHoverImageView2.hidden = YES;
    }
  }
  
  UIImage *shareImage = [UIImage imageWithView:cell.feedImageView];
  shareView.shareImage = shareImage;
  
  for (SWFeedTagButton *button in [cell.feedImageView subviews]) {
    if ([button isKindOfClass:[SWFeedTagButton class]]) {
      button.tagHoverImageView.hidden = NO;
      button.tagHoverImageView2.hidden = NO;
    }
  }
  
  __weak typeof(feedItem)wFeed = feedItem;
  shareView.reportBlock = ^{
    SWHomeFeedReportView *reportView = [[SWHomeFeedReportView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    __strong typeof(wFeed)sFeed = wFeed;
    reportView.feedItem = sFeed;
    [reportView show];
  };
  
  __weak typeof(self)wSelf = self;
  __weak typeof(shareView)wShareView = shareView;
  shareView.instaBlock = ^(UIImage *image){
    NSURL *instagramURL = [NSURL URLWithString:@"instagram://app"];
    if([[UIApplication sharedApplication] canOpenURL:instagramURL]) //check for App is install or not
    {
      NSData *imageData = UIImagePNGRepresentation(image); //convert image into .png format.
      NSFileManager *fileManager = [NSFileManager defaultManager];//create instance of NSFileManager
      NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //create an array and store result of our search for the documents directory in it
      NSString *documentsDirectory = [paths objectAtIndex:0]; //create NSString object, that holds our exact path to the documents directory
      NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"insta.igo"]]; //add our image to the path
      [fileManager createFileAtPath:fullPath contents:imageData attributes:nil]; //finally save the path (image)
      CGRect rect = CGRectMake(0 ,0 , 0, 0);
      UIGraphicsBeginImageContextWithOptions(wSelf.view.bounds.size, wSelf.view.opaque, 0.0);
      [wSelf.view.layer renderInContext:UIGraphicsGetCurrentContext()];
      UIGraphicsEndImageContext();
      NSString *fileNameToSave = [NSString stringWithFormat:@"Documents/insta.igo"];
      NSString  *jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:fileNameToSave];
      NSString *newJpgPath = [NSString stringWithFormat:@"file://%@",jpgPath];
      NSURL *igImageHookFile = [NSURL URLWithString:newJpgPath];
      wSelf.documentController.UTI = @"com.instagram.exclusivegram";
      wSelf.documentController = [wSelf setupControllerWithURL:igImageHookFile usingDelegate:wSelf];
      wSelf.documentController=[UIDocumentInteractionController interactionControllerWithURL:igImageHookFile];
      NSString *caption = @"#Your Text"; //settext as Default Caption
      wSelf.documentController.annotation=[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@",caption],@"InstagramCaption", nil];
      [wSelf.documentController presentOpenInMenuFromRect:rect inView: wSelf.view animated:YES];
      [wShareView dismiss];
    }
    else{
      [MBProgressHUD showTip:@"未安装Instagram"];
    }
  };
  
  shareView.fbBlock = ^(UIImage *image){
    FBSDKSharePhoto *photo = [[FBSDKSharePhoto alloc] init];
    photo.image = image;
    photo.userGenerated = YES;
    FBSDKSharePhotoContent *content = [[FBSDKSharePhotoContent alloc] init];
    content.photos = @[photo];
    [FBSDKShareDialog showFromViewController:wSelf
                                 withContent:content
                                    delegate:nil];
    
  };
}

- (UIDocumentInteractionController *) setupControllerWithURL: (NSURL*) fileURL usingDelegate: (id <UIDocumentInteractionControllerDelegate>) interactionDelegate {
  NSLog(@"file url %@",fileURL);
  UIDocumentInteractionController *interactionController = [UIDocumentInteractionController interactionControllerWithURL: fileURL];
  interactionController.delegate = interactionDelegate;
  
  return interactionController;
}

- (void)homeFeedCellDidPressLikeList:(SWFeedItem *)feedItem row:(NSInteger)row{
  SWFeedInteractVC *vc = [[SWFeedInteractVC alloc] init];
  vc.delegate = self;
  vc.defaultIndex = SWFeedInteractIndexLikes;
  vc.feedRow  = row;
  vc.isModal  = YES;
  vc.model.feedItem  = feedItem;
  UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
  [self presentViewController:nav animated:YES completion:nil];
}

- (void)homeFeedCellDidPressTag:(SWFeedTagItem *)tagItem{
  SWTagFeedsVC *vc = [[SWTagFeedsVC alloc] init];
  vc.model.tagItem = tagItem;
  vc.hidesBottomBarWhenPushed = YES;
  [self.navigationController pushViewController:vc animated:YES];
}

- (void)homeFeedCellDidPressImage:(SWFeedItem *)feedItem rects:(NSArray *)rects atIndex:(NSInteger)index{
  ALPhotoListFullView *view = [[ALPhotoListFullView alloc] initWithFrames:rects
                                                                photoList:[feedItem.feed photoUrlsWithSuffix:FEED_SMALL]
                                                                    index:index];
  [view setFeedItem:feedItem];
  [[UIApplication sharedApplication].delegate.window addSubview:view];
}

- (void)homeFeedCellDidPressUrl:(SWFeedItem *)feedItem{
  ALWebVC *vc = [[ALWebVC alloc] init];
  vc.url = feedItem.feed.link.linkUrl;
  vc.hidesBottomBarWhenPushed = YES;
  [self.navigationController pushViewController:vc animated:YES];
}

- (void)homeFeedCellDidPressVideo:(SWFeedItem *)feedItem row:(NSInteger)row{
  AVPlayerViewController *vc = [[AVPlayerViewController alloc] init];
  AVURLAsset *asset = [AVURLAsset assetWithURL:[NSURL URLWithString:feedItem.feed.videoUrl]];
  AVPlayerItem *item = [AVPlayerItem playerItemWithAsset: asset];
  AVPlayer * player = [[AVPlayer alloc] initWithPlayerItem: item];
  vc.player = player;
  [vc.view setFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.width)];
  vc.showsPlaybackControls = YES;
  [self presentViewController:vc animated:YES completion:nil];
  [player play];
}

#pragma mark Feed Interact VC Delegate
- (void)feedInteractVCDidDismiss:(SWFeedInteractVC *)vc row:(NSInteger)row likes:(NSMutableArray *)likes comments:(NSMutableArray *)comments{
  __weak typeof(self)wSelf = self;
  [wSelf dismissViewControllerAnimated:YES completion:^{
    SWFeedItem *feedItem = [wSelf.model.feeds safeObjectAtIndex:row];
    feedItem.likeCount = [NSNumber numberWithInteger:likes.count];
    feedItem.commentCount = [NSNumber numberWithInteger:comments.count];
    feedItem.likes = likes;
    feedItem.comments = comments;
    
    [wSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:0]]
                           withRowAnimation:UITableViewRowAnimationNone];
  }];
}

#pragma mark Model Delegate
- (void)tagFeedModelDidPressLike:(SWTagFeedsModel *)model row:(NSInteger)row{
  [self.tableView reloadData];
  [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadCollectionLike" object:nil];
}

- (void)tagFeedModelDidLoadContents:(SWTagFeedsModel *)model{
  [self.tableView reloadData];
}
@end
