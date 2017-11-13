//
//  SWTagFeedsVC.m
//  SeeWorld
//
//  Created by Albert Lee on 9/3/15.
//  Copyright (c) 2015 SeeWorld. All rights reserved.
//

#import "SWTagFeedsVC.h"
#import "SWFeedCell.h"
#import "SWFeedDetailScrollVC.h"
@interface SWTagFeedsVC ()<SWTagFeedsModelDelegate,UITableViewDataSource,UITableViewDelegate,
SWFeedCellDelegate>
@property(nonatomic, strong)UIView                    *headerView;
@property(nonatomic, strong)UILabel                   *lblFeedsCount;
@end

@implementation SWTagFeedsVC

- (id)init{
  if (self = [super init]) {
    self.model = [[SWTagFeedsModel alloc] init];
    self.model.delegate = self;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self uiInitialize];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark Custom Methods
- (void)uiInitialize{
  self.navigationItem.titleView = [[ALTitleLabel alloc] initWithTitle:[NSString stringWithFormat:@"#%@",self.model.tagItem.tagName]
                                                                color:[UIColor colorWithRGBHex:NAV_BAR_COLOR_HEX] fontSize:18];
  
  self.tbVC.view.frame = self.view.bounds;
  self.tbVC = [[UITableViewController alloc] initWithStyle:UITableViewStylePlain];
  self.tbVC.tableView.dataSource = self;
  self.tbVC.tableView.delegate   = self;
  self.tbVC.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  self.tbVC.tableView.backgroundColor= [UIColor colorWithRGBHex:0xffffff];
  self.tbVC.tableView.estimatedRowHeight = 0;
  self.tbVC.tableView.estimatedSectionFooterHeight = 0;
  self.tbVC.tableView.estimatedSectionHeaderHeight = 0;
  _tbVC.tableView.contentInset = UIEdgeInsetsMake(iOS11NavHeight, 0, 0, 0);
  if (@available(iOS 11.0, *)) {
    _tbVC.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
  }
  self.tbVC.refreshControl = [[UIRefreshControl alloc] init];
  [self.tbVC.refreshControl addTarget:self action:@selector(onHomeRefreshed) forControlEvents:UIControlEventValueChanged];
  [self.view addSubview:self.tbVC.tableView];
  
  
  if (self.model.tagItem){
      self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 33)];
      self.lblFeedsCount = [UILabel initWithFrame:CGRectMake(0, 0, UIScreenWidth-10, self.headerView.height)
                                          bgColor:[UIColor clearColor]
                                        textColor:[UIColor colorWithRGBHex:0x8b9cad]
                                             text:@""
                                    textAlignment:NSTextAlignmentRight
                                             font:[UIFont systemFontOfSize:12]];
      [self.headerView addSubview:self.lblFeedsCount];
      self.headerView.backgroundColor = [UIColor colorWithRGBHex:0xffffff];
      self.tbVC.tableView.tableHeaderView = self.headerView;
  }
  [self onHomeRefreshed];
}

- (void)onHomeRefreshed{
  [self.model getLatestTagFeeds];
}

#pragma mark Table View Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  NSInteger row = (self.model.feeds.count/2)+(self.model.feeds.count%2==0?0:1);
  return row;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  return [SWFeedCell height];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
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
  cell.contentView.backgroundColor = [UIColor colorWithRGBHex:0xffffff];
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
}

#pragma mark Like Delegate
- (void)tagFeedModelDidPressLike:(SWTagFeedsModel *)model row:(NSInteger)row{
  [self.tbVC.tableView reloadData];
  
  [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadCollectionLike" object:nil];
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
  if ([model.feedCount integerValue]>0) {
    self.lblFeedsCount.text = [[model.feedCount stringValue] stringByAppendingString:@"則貼文"];
  }
  [self.tbVC.refreshControl endRefreshing];
  [self.tbVC.tableView reloadData];
}
@end
