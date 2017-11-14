//
//  SWNoticeVC.m
//  SeeWorld
//
//  Created by Albert Lee on 9/23/15.
//  Copyright © 2015 SeeWorld. All rights reserved.
//

#import "SWNoticeVC.h"
@interface SWNoticeVC ()<UITableViewDataSource,UITableViewDelegate,
SWNoticeCellDelegate,SWNoticeModelDelegate>
@property(nonatomic, strong)UITableViewController *tbVCNotices;
@end

@implementation SWNoticeVC{
  SWTagFeedsModel *_detailModel;
  UIView *_emptyNoticeView;
}
- (id)init{
  if (self = [super init]) {
    [SWNoticeModel sharedInstance].delegate = self;
  }
  return self;
}
- (void)viewDidLoad {
  [super viewDidLoad];
  [self uiInitialize];
}

- (void)viewDidAppear:(BOOL)animated{
  [super viewDidAppear:animated];
  [self performSelector:@selector(reloadModelData) withObject:nil afterDelay:1.0];
}

- (void)viewWillAppear:(BOOL)animated{
  [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark Custom
- (void)uiInitialize{
  self.navigationItem.titleView = [[ALTitleLabel alloc] initWithTitle:@"通知"
                                                                color:[UIColor colorWithRGBHex:NAV_BAR_COLOR_HEX]];

  self.tbVCNotices = [[UITableViewController alloc] initWithStyle:UITableViewStylePlain];
  self.tbVCNotices.view.frame = self.view.bounds;
  self.tbVCNotices.tableView.dataSource = self;
  self.tbVCNotices.tableView.delegate   = self;
  self.tbVCNotices.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
  self.tbVCNotices.tableView.separatorColor = [UIColor colorWithRGBHex:0xE8EDF3];
  self.tbVCNotices.tableView.backgroundColor= [UIColor colorWithRGBHex:0xffffff];
  self.tbVCNotices.tableView.tableFooterView = [UIView new];
  self.tbVCNotices.tableView.contentInset   = UIEdgeInsetsMake(iOSNavHeight, 0, 49+iphoneXBottomAreaHeight, 0);
  self.tbVCNotices.tableView.separatorInset = UIEdgeInsetsZero;
  self.tbVCNotices.refreshControl = [[UIRefreshControl alloc] init];
  [self.tbVCNotices.refreshControl addTarget:self action:@selector(onNoticesRefreshed) forControlEvents:UIControlEventValueChanged];
  _tbVCNotices.tableView.estimatedRowHeight = 0;
  _tbVCNotices.tableView.estimatedSectionFooterHeight = 0;
  _tbVCNotices.tableView.estimatedSectionHeaderHeight = 0;
  if (@available(iOS 11.0, *)) {
    _tbVCNotices.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
  }
  [self.view addSubview:self.tbVCNotices.tableView];
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
  [self reloadModelData];
}

- (void)onChatsRefreshed{
  [[SWChatModel sharedInstance] getChats];
}

- (void)onNoticesRefreshed{
  [[SWNoticeModel sharedInstance] getLatestNotices];
}

- (void)reloadModelData{
  if ([[SWNoticeModel sharedInstance] freshDotIndex]>=0) {
    [[SWNoticeModel sharedInstance] syncContentData];
    [self.tbVCNotices.tableView reloadData];
  }else{
    if ([SWNoticeModel sharedInstance].notices.count==0) {
      [[SWNoticeModel sharedInstance] getLatestNotices];
    }
  }
}
#pragma mark Table View Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  return [SWNoticeModel sharedInstance].notices.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  return [SWNoticeCell heightOfNotice:[[SWNoticeModel sharedInstance].notices safeObjectAtIndex:indexPath.row]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  static NSString *idenNotice = @"notice";
  SWNoticeCell *cell = [tableView dequeueReusableCellWithIdentifier:idenNotice];
  if (!cell) {
    cell = [[SWNoticeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idenNotice];
  }
  [cell refreshNotice:[[SWNoticeModel sharedInstance].notices safeObjectAtIndex:indexPath.row]];
  cell.delegate = self;
  return cell;
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
@end
