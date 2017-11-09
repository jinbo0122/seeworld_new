//
//  SWSearchFriendVC.m
//  SeeWorld
//
//  Created by Albert Lee on 9/2/15.
//  Copyright (c) 2015 SeeWorld. All rights reserved.
//

#import "SWSearchFriendVC.h"
#import "SWSearchFriendModel.h"
#import "SWFeedInteractLikeCell.h"
@interface SWSearchFriendVC ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,
SWFeedInteractLikeCellDelegate,SWSearchFriendModelDelegate>
@property(nonatomic, strong)SWSearchBar *searchBar;
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)SWSearchFriendModel *model;
@end

@implementation SWSearchFriendVC

- (id)init{
  if (self = [super init]) {
    self.model = [[SWSearchFriendModel alloc] init];
    self.model.delegate = self;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  [self.navigationController setNavigationBarHidden:YES];
  
  self.searchBar = [[SWSearchBar alloc] initWithFrame:CGRectMake(0, 20, self.view.width, 44)];
  self.searchBar.delegate = self;
  [self.searchBar becomeFirstResponder];
  [self.view addSubview:self.searchBar];
  
  UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, self.searchBar.bottom, self.view.width, 0.5)];
  line.backgroundColor = [UIColor colorWithRGBHex:0x283748];
  [self.view addSubview:line];
  
  self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, iOSNavHeight+0.5, self.view.width, self.view.height-iOSNavHeight-0.5)
                                                style:UITableViewStylePlain];
  self.tableView.delegate = self;
  self.tableView.dataSource = self;
  self.tableView.tableFooterView = [UIView new];
  self.tableView.rowHeight = [SWFeedInteractLikeCell heightOfLike:nil];
  self.tableView.backgroundColor = [UIColor colorWithRGBHex:0x1a2531];
  self.tableView.separatorColor = [UIColor colorWithRGBHex:0x283748];
  self.tableView.separatorInset = UIEdgeInsetsZero;
  [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
  [super viewWillAppear:animated];
  [self.navigationController setNavigationBarHidden:YES];
}

#pragma mark Search Bar Delegate
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
  [self.model searchUserByName:searchText];
}

#pragma mark TableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  return [self.model.users count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  static NSString *iden = @"search";
  
  SWFeedInteractLikeCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
  if (!cell) {
    cell = [[SWFeedInteractLikeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
  }
  cell.delegate = self;
  [cell refreshUser:[self.model.users safeObjectAtIndex:indexPath.row]];
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  [tableView deselectRowAtIndexPath:indexPath animated:YES];  
  [SWFeedUserItem pushUserVC:[self.model.users safeObjectAtIndex:indexPath.row] nav:self.navigationController];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
  if ([self.searchBar isFirstResponder]) {
    [self.searchBar resignFirstResponder];
  }
}
#pragma mark Cell Delegate
- (void)feedInteractLikeCellDidPressFollow:(SWFeedLikeItem *)likeItem{
  [self.model processFollow:likeItem];
}

#pragma mark Model Delegate
- (void)searchFriendDidReturnResults:(SWSearchFriendModel *)model string:(NSString *)string{
  if ([self.searchBar.text isEqualToString:string]) {
    [self.tableView reloadData];
  }
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
