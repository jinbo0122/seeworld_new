//
//  SWUserListVC.m
//  SeeWorld
//
//  Created by Albert Lee on 15/11/2017.
//  Copyright © 2017 SeeWorld. All rights reserved.
//

#import "SWUserListVC.h"
#import "SWUserListCell.h"
@interface SWUserListVC ()<SWUserListModelDelegate,UITableViewDelegate,UITableViewDataSource>

@end

@implementation SWUserListVC{
  UITableViewController *_tbVC;
}

- (id)init{
  if (self = [super init]) {
    _model = [[SWUserListModel alloc] init];
    _model.delegate = self;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.navigationItem.titleView = [[ALTitleLabel alloc] initWithTitle:_model.title color:[UIColor colorWithRGBHex:NAV_BAR_COLOR_HEX]];
  _tbVC = [[UITableViewController alloc] initWithStyle:UITableViewStylePlain];
  _tbVC.view.frame = self.view.bounds;
  _tbVC.tableView.dataSource = self;
  _tbVC.tableView.delegate   = self;
  _tbVC.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
  _tbVC.tableView.separatorColor = [UIColor colorWithRGBHex:0xcccccc];
  _tbVC.tableView.separatorInset = UIEdgeInsetsMake(0, 62.5, 0, 0);
  _tbVC.tableView.backgroundColor= [UIColor whiteColor];
  _tbVC.tableView.contentInset   = UIEdgeInsetsMake(iOSNavHeight, 0, 49+iphoneXBottomAreaHeight, 0);
  _tbVC.tableView.rowHeight = 59;
  _tbVC.tableView.estimatedRowHeight = 0;
  _tbVC.tableView.estimatedSectionFooterHeight = 0;
  _tbVC.tableView.estimatedSectionHeaderHeight = 0;
  _tbVC.tableView.tableFooterView = [UIView new];
  _tbVC.refreshControl = [[UIRefreshControl alloc] init];
  [_tbVC.refreshControl addTarget:self action:@selector(onRefreshed) forControlEvents:UIControlEventValueChanged];
  [self.view addSubview:_tbVC.tableView];
  if (@available(iOS 11.0, *)) {
    _tbVC.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
  }
  
  [self onRefreshed];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark Custom
- (void)onRefreshed{
  [_model getUsers];
}

#pragma mark Table View
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  return _model.users.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  static NSString *iden = @"userList";
  SWUserListCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
  if (!cell) {
    cell = [[SWUserListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
  }
  [cell refreshWithUser:[_model.users safeObjectAtIndex:indexPath.row]];
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  [SWFeedUserItem pushUserVC:[_model.users safeObjectAtIndex:indexPath.row] nav:self.navigationController];
}

#pragma mark Model
- (void)userListModelDidLoadUsers:(SWUserListModel *)model{
  [_tbVC.refreshControl endRefreshing];
  [_tbVC.tableView reloadData];
}

- (void)userListModelDidFailLoadUsers:(SWUserListModel *)model{
  [_tbVC.refreshControl endRefreshing];
  [_tbVC.tableView reloadData];
}
@end
