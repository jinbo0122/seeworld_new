//
//  SWNoticeVC.m
//  SeeWorld
//
//  Created by Albert Lee on 9/23/15.
//  Copyright © 2015 SeeWorld. All rights reserved.
//

#import "SWNoticeVC.h"
#import "SWChatListVC.h"
@interface SWNoticeVC ()<SWFeedInteractNavViewDelegate,UITableViewDataSource,UITableViewDelegate,
SWNoticeCellDelegate,SWNoticeModelDelegate,SWChatModelDelegate,SWChatListVCDelegate,
SWExploreSegViewDelegate>
@property(nonatomic, strong)UITableViewController *tbVCChats;
@property(nonatomic, strong)UITableViewController *tbVCNotices;
@property(nonatomic, strong)UIScrollView          *scrollView;

@property(nonatomic, strong)SWChatListVC *chatVC;
@end

@implementation SWNoticeVC{
  SWTagFeedsModel *_detailModel;
  BOOL _isChatConnected;
  UIView *_emptyNoticeView;
  UIImageView *_emptyChatView;
}
- (id)init{
  if (self = [super init]) {
    [SWNoticeModel sharedInstance].delegate = self;
    [SWChatModel sharedInstance].delegate = self;
    [[NSNotificationCenter defaultCenter] addObserverForName:@"RCIMConnected" object:nil queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification * _Nonnull note) {
                                                    _isChatConnected = YES;
                                                  }];
  }
  return self;
}
- (void)viewDidLoad {
  [super viewDidLoad];
  [self uiInitialize];
}

- (void)viewDidAppear:(BOOL)animated{
  [super viewDidAppear:animated];
  [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x, 0) animated:NO];
  [self performSelector:@selector(reloadModelData) withObject:nil afterDelay:1.0];
}

- (void)viewWillAppear:(BOOL)animated{
  [super viewWillAppear:animated];
  [self.chatVC reloadChats];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark Custom
- (void)uiInitialize{
  self.navigationItem.titleView = [[ALTitleLabel alloc] initWithTitle:@"動態消息"
                                                                color:[UIColor whiteColor]];
  self.titleView = [[SWExploreSegView alloc] initWithFrame:CGRectMake(0, iOS7NavHeight, UIScreenWidth, 38)
                                                     items:@[@"",@""]
                                                    images:@[@"notice_btn_notice",@"home_btn_comment"]];
  self.titleView.delegate = self;
  self.titleView.selectedIndex = 0;
  [self.view addSubview:self.titleView];
  
  self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.titleView.bottom, self.view.width, self.view.height-self.titleView.bottom)];
  self.scrollView.bounces = NO;
  self.scrollView.scrollEnabled = NO;
  self.scrollView.contentSize = CGSizeMake(UIScreenWidth *2, 1);
  self.scrollView.contentOffset = CGPointMake(0, 0);
  self.automaticallyAdjustsScrollViewInsets = NO;
  [self.view addSubview:self.scrollView];
  
  self.tbVCNotices = [[UITableViewController alloc] initWithStyle:UITableViewStylePlain];
  self.tbVCNotices.view.frame = self.scrollView.bounds;
  self.tbVCNotices.tableView.dataSource = self;
  self.tbVCNotices.tableView.delegate   = self;
  self.tbVCNotices.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
  self.tbVCNotices.tableView.separatorColor = [UIColor colorWithRGBHex:0x2a3847];
  self.tbVCNotices.tableView.backgroundColor= [UIColor colorWithRGBHex:0x1a2531];
  self.tbVCNotices.tableView.tableFooterView = [UIView new];
  self.tbVCNotices.tableView.contentInset   = UIEdgeInsetsMake(0, 0, 49, 0);
  self.tbVCNotices.tableView.separatorInset = UIEdgeInsetsZero;
  self.tbVCNotices.refreshControl = [[UIRefreshControl alloc] init];
  [self.tbVCNotices.refreshControl addTarget:self action:@selector(onNoticesRefreshed) forControlEvents:UIControlEventValueChanged];
  [self.scrollView addSubview:self.tbVCNotices.tableView];
  _emptyNoticeView = [[UIView alloc] initWithFrame:CGRectMake((self.view.width-210)/2.0, 134, 210, 200)];
  UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(33, 0, 144, 144)];
  imageView.image = [UIImage imageNamed:@"no_notice"];
  [_emptyNoticeView addSubview:imageView];
  UILabel *lbl = [UILabel initWithFrame:CGRectMake(0, imageView.bottom+25, _emptyNoticeView.width, 25) bgColor:[UIColor clearColor]
                              textColor:[UIColor colorWithRGBHex:0x55acef]
                                   text:SWStringNoNotices
                          textAlignment:NSTextAlignmentCenter font:[UIFont systemFontOfSize:15]];
  [_emptyNoticeView addSubview:lbl];
  [self.tbVCNotices.tableView addSubview:_emptyNoticeView];
  _emptyNoticeView.hidden = YES;
  self.scrollView.contentOffset = CGPointMake(0, self.scrollView.contentOffset.y);
  [self reloadModelData];
  
  __weak typeof(self)wSelf = self;
  [[NSNotificationCenter defaultCenter] addObserverForName:@"RCIMConnected" object:nil queue:[NSOperationQueue mainQueue]
                                                usingBlock:^(NSNotification * _Nonnull note) {
                                                  [wSelf initChatVC];
                                                }];
  if (_isChatConnected) {
    [self initChatVC];
  }
  
  
  if (![SWNoticeModel sharedInstance].unreadNoticeCount && [[RCIMClient sharedRCIMClient] getTotalUnreadCount]) {
    [self.titleView setSelectedIndex:1];
  }
  
  [self rightBar];
}

- (void)rightBar{
  if (self.titleView.selectedIndex==0) {
    self.navigationItem.rightBarButtonItems = @[];
  }else{
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -1;
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"notice_btn_chat"]
                                                                        imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self action:@selector(onNewChatClicked)];
    self.navigationItem.rightBarButtonItems = @[negativeSpacer,rightBar];
  }
}

- (void)onNewChatClicked{
  TabViewController *tabVC = (TabViewController *)[UIApplication sharedApplication].delegate.window.rootViewController;
  if ([tabVC isKindOfClass:[TabViewController class]]) {
    [tabVC startChat];
  }
}

- (void)onChatsRefreshed{
  [[SWChatModel sharedInstance] getChats];
}

- (void)onNoticesRefreshed{
  [[SWNoticeModel sharedInstance] getLatestNotices];
}

- (void)reloadModelData{
  if ([[SWNoticeModel sharedInstance] freshDotIndex]>=0) {
    self.titleView.selectedIndex = [[SWNoticeModel sharedInstance] freshDotIndex];
    [[SWNoticeModel sharedInstance] syncContentData];
    [self.tbVCNotices.tableView reloadData];
    [self.tbVCChats.tableView reloadData];
  }else{
    if ([SWNoticeModel sharedInstance].notices.count==0) {
      [[SWNoticeModel sharedInstance] getLatestNotices];
    }
  }
  
  if (![SWNoticeModel sharedInstance].unreadNoticeCount && [[RCIMClient sharedRCIMClient] getTotalUnreadCount]) {
    [self.titleView setSelectedIndex:1];
  }else if ([SWNoticeModel sharedInstance].unreadNoticeCount && ![[RCIMClient sharedRCIMClient] getTotalUnreadCount]){
    [self.titleView setSelectedIndex:0];
  }
}



- (void)initChatVC{
  if (!self.chatVC) {
    self.chatVC = [[SWChatListVC alloc] init];
    self.chatVC.view.left = UIScreenWidth;
    self.chatVC.view.height = self.tbVCNotices.tableView.height;
    [self.scrollView addSubview:self.chatVC.view];
    self.chatVC.delegate = self;
    
    _emptyChatView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.width + (self.view.width-144)/2.0,iOS7NavHeight+50, 144, 144)];
    _emptyChatView.image = [UIImage imageNamed:@"no_message"];
    _emptyChatView.tag = 1001;
    [self.scrollView addSubview:_emptyChatView];
  }
}
#pragma mark Title Delegate
- (void)feedInteractNavViewDidSelectIndex:(NSInteger)index{
  [self.scrollView setContentOffset:CGPointMake(index*UIScreenWidth, 0) animated:YES];
  
  if (index==1) {
    [self initChatVC];
  }
  
  [self rightBar];
}

#pragma mark Table View Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  if ([tableView isEqual:self.tbVCChats.tableView]) {
    return [SWChatModel sharedInstance].chats.count;
  }else{
    return [SWNoticeModel sharedInstance].notices.count;
  }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  if ([tableView isEqual:self.tbVCChats.tableView]) {
    return [SWNoticeCell heightOfNotice:[[SWChatModel sharedInstance].chats safeObjectAtIndex:indexPath.row]];
  }else{
    return [SWNoticeCell heightOfNotice:[[SWNoticeModel sharedInstance].notices safeObjectAtIndex:indexPath.row]];
  }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  if ([tableView isEqual:self.tbVCChats.tableView]) {
    static NSString *idenChat = @"chat";
    SWNoticeCell *cell = [tableView dequeueReusableCellWithIdentifier:idenChat];
    if (!cell) {
      cell = [[SWNoticeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idenChat];
    }
    [cell refreshNotice:[[SWChatModel sharedInstance].chats safeObjectAtIndex:indexPath.row]];
    cell.delegate = self;
    return cell;
  }else{
    static NSString *idenNotice = @"notice";
    SWNoticeCell *cell = [tableView dequeueReusableCellWithIdentifier:idenNotice];
    if (!cell) {
      cell = [[SWNoticeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idenNotice];
    }
    [cell refreshNotice:[[SWNoticeModel sharedInstance].notices safeObjectAtIndex:indexPath.row]];
    cell.delegate = self;
    return cell;
  }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  SWNoticeCell *cell = [tableView cellForRowAtIndexPath:indexPath];
  [cell hideDot];
  
  if ([tableView isEqual:self.tbVCNotices.tableView]) {
    SWNoticeMsgItem *msgItem = [[SWNoticeModel sharedInstance].notices safeObjectAtIndex:indexPath.row];
    if ([msgItem.mType integerValue]==SWNoticeTypeFollow) {
      [self enterUserVC:msgItem.user];
    }else{
      [self noticeCellDidPressFeed:msgItem];
    }
    [[SWNoticeModel sharedInstance] markReadMsg:msgItem];
  }else{
//    SWNoticeMsgItem *msgItem = [[SWChatModel sharedInstance].chats safeObjectAtIndex:indexPath.row];
//    @TODO("Enter");
//    [self noticeCellDidPressFeed:msgItem];
//    [[SWNoticeModel sharedInstance] markReadMsg:msgItem];
  }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
  if ([scrollView isEqual:self.tbVCNotices.tableView]){
    CGSize size = scrollView.contentSize;
    float y = scrollView.contentOffset.y + scrollView.bounds.size.height - scrollView.contentInset.bottom;
    float h = size.height;
    
    float reload_distance = -10;
    if(y > h + reload_distance && size.height>1400) {
      [[SWNoticeModel sharedInstance] getMoreNotices];
    }
  }
}

- (void)enterUserVC:(SWFeedUserItem *)userItem{
  [SWFeedUserItem pushUserVC:userItem nav:self.navigationController];
}

#pragma mark Like Cell Delegate
- (void)noticeCellDidPressFollow:(SWNoticeMsgItem *)msgItem{
  SWFeedLikeItem *likeItem = [[SWFeedLikeItem alloc] init];
  likeItem.time = msgItem.time;
  likeItem.user = msgItem.user;
  [[SWNoticeModel sharedInstance] processFollow:likeItem];
  
  [[SWNoticeModel sharedInstance] markReadMsg:msgItem];
}

- (void)noticeCellDidPressFeed:(SWNoticeMsgItem *)msgItem{
  SWFeedDetailScrollVC *vc = [[SWFeedDetailScrollVC alloc] init];
  _detailModel = [[SWTagFeedsModel alloc] init];
  _detailModel.feedCount = @1;
  SWFeedItem *feed = [[SWFeedItem alloc] init];
  feed.feed = [msgItem.feed copy];
  _detailModel.feeds = [NSMutableArray arrayWithObject:feed];
  _detailModel.lastFeedId = @0;
  _detailModel.isFromNotice = YES;
  vc.model = _detailModel;
  vc.currentIndex = 0;
  vc.hidesBottomBarWhenPushed = YES;
  [self.navigationController pushViewController:vc animated:YES];
  
  [[SWNoticeModel sharedInstance] markReadMsg:msgItem];
}

- (void)noticeCellDidPressAvatar:(SWNoticeMsgItem *)msgItem{
  [self enterUserVC:msgItem.user];
  
  [[SWNoticeModel sharedInstance] markReadMsg:msgItem];
}

#pragma mark Model Delegate
- (void)noticeModelDidLoadNotices:(SWNoticeModel *)model{
  [self.tbVCNotices.refreshControl endRefreshing];
  [self.tbVCNotices.tableView reloadData];
  _emptyNoticeView.hidden = model.notices.count;
}

- (void)chatModelDidLoadChats:(SWChatModel *)model{
  [self.tbVCChats.refreshControl endRefreshing];
  [self.tbVCChats.tableView reloadData];
}

- (void)chatListDidPressWithVC:(UIViewController *)vc{
  if (vc) {
    [self.navigationController pushViewController:vc animated:YES];
  }
}
@end
