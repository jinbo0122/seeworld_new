//
//  SWSearchVC.m
//  SeeWorld
//
//  Created by Albert Lee on 9/9/15.
//  Copyright (c) 2015 SeeWorld. All rights reserved.
//

#import "SWSearchVC.h"
#import "SWExploreSegView.h"
#import "SWSearchModel.h"
#import "SWTagResultCell.h"
@interface SWSearchVC ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,
SWExploreSegViewDelegate,SWSearchModelDelegate,SWFeedInteractLikeCellDelegate>
@property(nonatomic, strong)SWSearchBar *searchBar;
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)SWSearchModel *model;
@property(nonatomic, strong)SWExploreSegView *segView;
@end

@implementation SWSearchVC
- (id)init{
  if (self = [super init]) {
    self.model = [[SWSearchModel alloc] init];
    self.model.delegate = self;
  }
  return self;
}

- (void)viewWillAppear:(BOOL)animated{
  [super viewWillAppear:animated];
  [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor colorWithRGBHex:0xffffff];
  [self.navigationController setNavigationBarHidden:YES];
  
  self.searchBar = [[SWSearchBar alloc] initWithFrame:CGRectMake(0, 20+iOSTopHeight, self.view.width, 44)];
  self.searchBar.delegate = self;
  [self.searchBar becomeFirstResponder];
  _searchBar.backgroundColor = [UIColor whiteColor];
  _searchBar.layer.borderColor = [UIColor clearColor].CGColor;
  _searchBar.tintColor = [UIColor colorWithRGBHex:NAV_BAR_COLOR_HEX];
  _searchBar.barTintColor  = [UIColor colorWithRGBHex:NAV_BAR_COLOR_HEX];
  [self.view addSubview:self.searchBar];

  self.segView = [[SWExploreSegView alloc] initWithFrame:CGRectMake(0, self.searchBar.bottom, self.view.width, 38)
                                                   items:@[@"",@""]
                                                  images:@[@"search_btn_penson",@"search_btn_tag"]];
  self.segView.delegate = self;
  self.segView.selectedIndex = SWSearchVCIndexUser;
  [self.view addSubview:self.segView];
  
  self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _segView.bottom, self.view.width, self.view.height-_segView.bottom)
                                                style:UITableViewStylePlain];
  self.tableView.delegate = self;
  self.tableView.dataSource = self;
  self.tableView.tableFooterView = [UIView new];
  self.tableView.separatorColor = [UIColor colorWithRGBHex:0x2a3847];
  self.tableView.backgroundColor = [UIColor colorWithRGBHex:0xE8EDF3];
  self.tableView.separatorInset = UIEdgeInsetsZero;
  [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

#pragma mark Nav Delegate
- (void)feedInteractNavViewDidSelectIndex:(NSInteger)index{
  self.model.currentIndex = index;
  
  if (index==SWSearchVCIndexUser) {
    self.searchBar.placeholder = SWStringSearchUser;
    [self.model.users removeAllObjects];
  }else{
    self.searchBar.placeholder = SWStringSearchTag;
    [self.model.tags removeAllObjects];
  }
  
  [self.tableView reloadData];
}

#pragma mark Search Bar Delegate
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
  [_searchBar resignFirstResponder];
  __weak typeof(self)wSelf = self;
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    [wSelf dismissViewControllerAnimated:YES completion:nil];
  });
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
  if(self.model.currentIndex==SWSearchVCIndexUser){
    [self.model searchUserByName:searchText];
  }else{
    [self.model searchTag:searchText];
  }
}

#pragma mark TableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  return self.model.currentIndex==SWSearchVCIndexUser?[self.model.users count]:[self.model.tags count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  return self.model.currentIndex==SWSearchVCIndexUser?[SWFeedInteractLikeCell heightOfLike:nil]:38;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  
  if (self.model.currentIndex == SWSearchVCIndexUser) {
    static NSString *idenUser = @"searchUser";
    
    SWFeedInteractLikeCell *cell = [tableView dequeueReusableCellWithIdentifier:idenUser];
    if (!cell) {
      cell = [[SWFeedInteractLikeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idenUser];
    }
    cell.delegate = self;
    [cell refreshUser:[self.model.users safeObjectAtIndex:indexPath.row]];
    return cell;
  }else{
    static NSString *idenTag = @"searchTag";
    
    SWTagResultCell *cell = [tableView dequeueReusableCellWithIdentifier:idenTag];
    if (!cell) {
      cell = [[SWTagResultCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idenTag];
    }
    [cell refreshTag:[self.model.tags safeObjectAtIndex:indexPath.row]];
    return cell;
  }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  [self.navigationController setNavigationBarHidden:NO];
  if (self.model.currentIndex==SWSearchVCIndexUser) {
    [SWFeedUserItem pushUserVC:[self.model.users safeObjectAtIndex:indexPath.row] nav:self.navigationController];
  }else{
    SWTagFeedsVC *vc = [[SWTagFeedsVC alloc] init];
    vc.model.tagItem = [self.model.tags safeObjectAtIndex:indexPath.row];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
  }
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
- (void)searchFriendDidReturnResults:(SWSearchModel *)model string:(NSString *)string{
  if ([self.searchBar.text isEqualToString:string]) {
    [self.tableView reloadData];
  }
}

- (void)searchTagDidReturnResults:(SWSearchModel *)model tag:(NSString *)tag{
  if ([self.searchBar.text isEqualToString:tag]) {
    [self.tableView reloadData];
  }
}
@end
