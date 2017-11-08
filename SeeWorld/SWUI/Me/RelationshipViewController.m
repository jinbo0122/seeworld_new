//
//  RelationshipViewController.m
//
//
//  Created by liufz on 15/10/11.
//
//

#import "RelationshipViewController.h"
#import "MJRefresh.h"
#import "GetFollowersApi.h"
#import "GetFollowsApi.h"
#import "CommonResponse.h"
#import "RelationshipCell.h"
#import "RelationshipResponse.h"
#import "PersonInfoData.h"
#import "PersonInfoData.h"

@interface RelationshipViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) NSMutableArray *persons;
@end

@implementation RelationshipViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  if (_type == eRelationshipTypeFollows){
    self.navigationItem.titleView = [[ALTitleLabel alloc] initWithTitle:@"追蹤列表"
                                                                  color:[UIColor whiteColor]
                                                               fontSize:18];
  }else{
    self.navigationItem.titleView = [[ALTitleLabel alloc] initWithTitle:@"粉絲列表"
                                                                  color:[UIColor whiteColor]
                                                               fontSize:18];
  }
  self.title = @"";
  _tableView.separatorInset = UIEdgeInsetsZero;
  [_tableView addLegendHeaderWithRefreshingBlock:^{
    [self refresh];
  }];
  _tableView.tableFooterView = [UIView new];
  [self refresh];
}

- (void)viewDidAppear:(BOOL)animated{
  [super viewDidAppear:animated];
}

- (void)viewWillAppear:(BOOL)animated{
  [super viewWillAppear:animated];
}

- (void)stopRefresh
{
  if ([_tableView.header isRefreshing])
  {
    [_tableView.header endRefreshing];
  }
  if ([_tableView.footer isRefreshing])
  {
    [_tableView.footer endRefreshing];
  }
}

- (void)refresh
{
  if (_type == eRelationshipTypeFollows) {
    GetFollowsApi *api = [[GetFollowsApi alloc] init];
    api.userId = _userId;
    [api startWithModelClass:[RelationshipResponse class] completionBlock:^(ModelMessage *message) {
      [self stopRefresh];
      if (message.isSuccess)
      {
        _persons = [NSMutableArray arrayWithArray:((RelationshipResponse *)message.object).data];
        [_tableView reloadData];
      }
      else
      {
        [SWHUD showCommonToast:(message.message.length == 0? @"请求失败！":message.message)];
      }
    }];
  }
  else
  {
    GetFollowersApi *api = [[GetFollowersApi alloc] init];
    api.userId = _userId;
    [api startWithModelClass:[RelationshipResponse class] completionBlock:^(ModelMessage *message) {
      [self stopRefresh];
      if (message.isSuccess)
      {
        _persons = [NSMutableArray arrayWithArray:((RelationshipResponse *)message.object).data];
        [_tableView reloadData];
      }
      else
      {
        [SWHUD showCommonToast:(message.message.length == 0? @"请求失败！":message.message)];
      }
    }];
  }
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return _persons.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  static NSString *iden = @"RelationshipCell";
  RelationshipCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
  if (!cell) {
    cell = [[RelationshipCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
  }
  cell.personData = _persons[indexPath.row];
  __weak __typeof(self)weakSelf = self;
  cell.relationshipChangedBlock = ^(PersonInfoData *personData, NSString *action){
    BOOL isMe = NO;
    if ([weakSelf.userId isEqualToString:(NSString *)[[NSUserDefaults standardUserDefaults] safeStringObjectForKey:@"userId"]]){
      isMe = YES;
    }
    
    if ([action isEqualToString:@"follow"]){
      if (personData.relation == 2){
        personData.relation = 3;
      }else if (personData.relation == 4){
        personData.relation = 1;
      }
    }else{
      if (personData.relation == 1){
        if (isMe){
          [weakSelf.persons removeObject:personData];
        }else{
          personData.relation = 4;
        }
      }else if (personData.relation == 3){
        if (self.type == eRelationshipTypeFollows){
          if (isMe){
            [weakSelf.persons removeObject:personData];
          }else{
            personData.relation = 4;
          }
        }else{
          personData.relation = 2;
        }
      }
    }
    [weakSelf.tableView reloadData];
  };
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  PersonInfoData *personData = _persons[indexPath.row];
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  [SWFeedUserItem pushUserVC:[SWFeedUserItem feedUserItemByDic:[personData dictionaryRepresentation]]
                         nav:self.navigationController];
}

@end
