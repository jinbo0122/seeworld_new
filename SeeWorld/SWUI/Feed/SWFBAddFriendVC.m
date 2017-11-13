//
//  SWFBAddFriendVC.m
//  SeeWorld
//
//  Created by Albert Lee on 9/4/15.
//  Copyright (c) 2015 SeeWorld. All rights reserved.
//

#import "SWFBAddFriendVC.h"
#import "SWFeedInteractLikeCell.h"
#import "SWUserAddFollowAPI.h"
#import "SWUserRemoveFollowAPI.h"
#import "SWSearcgFBFriendAPI.h"
@interface SWFBAddFriendVC ()<UITableViewDataSource,UITableViewDelegate,SWFeedInteractLikeCellDelegate>
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSMutableArray *users;
@end

@implementation SWFBAddFriendVC

- (id)init{
  if (self = [super init]) {
    self.users = [NSMutableArray array];
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.navigationItem.titleView = [[ALTitleLabel alloc] initWithTitle:@"Facebook好友"
                                                                color:[UIColor colorWithRGBHex:NAV_BAR_COLOR_HEX]
                                                             fontSize:18];
  self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds
                                                style:UITableViewStylePlain];
  self.tableView.dataSource = self;
  self.tableView.delegate = self;
  self.tableView.backgroundColor = [UIColor colorWithRGBHex:0x1a2531];
  [self.view addSubview:self.tableView];
  self.tableView.separatorInset = UIEdgeInsetsZero;
  self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
  self.tableView.separatorColor = [UIColor colorWithRGBHex:0x283748];
  self.tableView.rowHeight = 66;
  self.tableView.tableFooterView = [UIView new];
  [self getFBUsers];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark Custom

- (void)getFBUsers{
  __weak typeof(self)wSelf = self;
  SWSearcgFBFriendAPI *api = [[SWSearcgFBFriendAPI alloc] init];
  [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
    NSDictionary *dic = [request.responseString safeJsonDicFromJsonString];
    NSArray *users = [dic safeArrayObjectForKey:@"data"];
    [wSelf.users removeAllObjects];
    
    if (isFakeDataOn) {
      for (NSInteger i=0; i<10; i++) {
        [wSelf.users addObject:[SWFeedUserItem myself]];
      }
    }
    
    for (NSDictionary *userdic in users) {
      [wSelf.users safeAddObject:[SWFeedUserItem feedUserItemByDic:userdic]];
    }
    
    [wSelf.tableView reloadData];
  } failure:^(YTKBaseRequest *request) {
    [wSelf.tableView reloadData];
  }];
}


#pragma mark Table View Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  return [self.users count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  static NSString *iden = @"FBFriends";
  SWFeedInteractLikeCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
  if (!cell) {
    cell = [[SWFeedInteractLikeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
  }
  [cell refreshUser:[self.users safeObjectAtIndex:indexPath.row]];
  cell.delegate = self;
  
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  [SWFeedUserItem pushUserVC:[self.users safeObjectAtIndex:indexPath.row] nav:self.navigationController];
}

#pragma mark Cell Delegate

- (void)feedInteractLikeCellDidPressFollow:(SWFeedLikeItem *)likeItem{
  SWUserRelationType type = [likeItem.user.relation integerValue];
  
  if (type==SWUserRelationTypeFollowing||
      type==SWUserRelationTypeInterFollow) {
    SWUserAddFollowAPI *api = [[SWUserAddFollowAPI alloc] init];
    api.uId = likeItem.user.uId;
    [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
      [SWUserAddFollowAPI showSuccessTip];
    } failure:^(YTKBaseRequest *request) {
      
    }];
  }else{
    SWUserRemoveFollowAPI *api = [[SWUserRemoveFollowAPI alloc] init];
    api.uId = likeItem.user.uId;
    [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
      
    } failure:^(YTKBaseRequest *request) {
      
    }];
  }
}
@end
