//
//  SWSelectContactVC.m
//  SeeWorld
//
//  Created by Albert Lee on 1/5/16.
//  Copyright © 2016 SeeWorld. All rights reserved.
//

#import "SWSelectContactVC.h"
#import "SWSelectContactCell.h"
#import "SWSearchBar.h"
@interface SWSelectContactVC ()<SWContactModelDelegate,
UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>

@end

@implementation SWSelectContactVC{
  UITableView      *_contactTableView;
  SWContactModel   *_model;
  UIView           *_emptyView;
  SWSearchBar      *_searchBar;
}

- (id)init{
  if (self = [super init]) {
    _model = [[SWContactModel alloc] init];
    _model.delegate  = self;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.navigationItem.titleView = [[ALTitleLabel alloc] initWithTitle:SWStringSelectContact
                                                                color:[UIColor colorWithRGBHex:NAV_BAR_COLOR_HEX]
                                                             fontSize:19];
  self.navigationItem.leftBarButtonItem = [UIBarButtonItem loadLeftBarButtonItemWithTitle:SWStringCancel
                                                                                    color:[UIColor colorWithRGBHex:NAV_BAR_COLOR_HEX]
                                                                                     font:[UIFont systemFontOfSize:15]
                                                                                   target:self action:@selector(cancel)];
  self.navigationItem.rightBarButtonItem = [UIBarButtonItem loadBarButtonItemWithTitle:SWStringOkay
                                                                                 color:[UIColor colorWithRGBHex:0x8b9cad]
                                                                                  font:[UIFont systemFontOfSize:15]
                                                                                target:self action:@selector(startChat)];
  self.view.backgroundColor = [UIColor colorWithRGBHex:0xffffff];
  self.automaticallyAdjustsScrollViewInsets = NO;
  
  _searchBar = [[SWSearchBar alloc] initWithFrame:CGRectMake(0, iOSNavHeight, self.view.width, 54)];
  [self.view addSubview:_searchBar];
  _searchBar.showsCancelButton = NO;
  _searchBar.placeholder = SWStringSearch;
  _searchBar.delegate = self;
  _searchBar.layer.borderColor = [UIColor clearColor].CGColor;
  _searchBar.tintColor = [UIColor colorWithRGBHex:0x34414e];
  _searchBar.layer.borderColor = [UIColor colorWithRGBHex:0xcccccc].CGColor;
  [_searchBar setSearchFieldBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor] size:_searchBar.size] forState:UIControlStateNormal];
  [self reloadSelectView];
  
  _contactTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _searchBar.bottom, self.view.width, self.view.height-_searchBar.bottom)
                                                   style:UITableViewStylePlain];
  _contactTableView.dataSource = self;
  _contactTableView.delegate   = self;
  _contactTableView.rowHeight  = 70;
  _contactTableView.backgroundColor = [UIColor colorWithRGBHex:0xffffff];
  _contactTableView.separatorColor = [UIColor colorWithRGBHex:0xcccccc];
  _contactTableView.separatorInset = UIEdgeInsetsZero;
  _contactTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
  _contactTableView.tableFooterView = [UIView new];
  [self.view addSubview:_contactTableView];
  
  [_model getContacts];
  
  _emptyView = [[UIView alloc] initWithFrame:self.view.bounds];
  _emptyView.backgroundColor = [UIColor whiteColor];
  [self.view addSubview:_emptyView];
  
  UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.width-200)/2.0, 100, 200, 143)];
  imageView.image = [UIImage imageNamed:@"empty_contact"];
  [_emptyView addSubview:imageView];
  
  UILabel *lbl = [UILabel initWithFrame:CGRectMake(0, imageView.bottom+25, _emptyView.width, 25) bgColor:[UIColor clearColor]
                              textColor:[UIColor colorWithRGBHex:0x55acef]
                                   text:SWStringNoContacts
                          textAlignment:NSTextAlignmentCenter font:[UIFont systemFontOfSize:15]];
  [_emptyView addSubview:lbl];
  UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake((self.view.width-100)/2.0, lbl.bottom+60, 100, 28)];
  button.layer.masksToBounds = YES;
  button.layer.borderColor   = [UIColor colorWithRGBHex:0x55acef].CGColor;
  button.layer.borderWidth   = 0.5;
  button.layer.cornerRadius  = 4.0;
  [button setTitle:SWStringGoHomePage forState:UIControlStateNormal];
  [button setTitleColor:[UIColor colorWithRGBHex:0x55acef] forState:UIControlStateNormal];
  [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
  [_emptyView addSubview:button];
  [button addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
  _emptyView.hidden = YES;
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
  if (searchBar.text.length>0) {
    [_model searchUser:searchBar.text];
  }else{
    [_contactTableView reloadData];
  }
}

- (void)cancel{
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)startChat{
  if (_model.selectedContacts.count==0) {
    return;
  }else if(self.isFromAdd){
    __weak typeof(self)wSelf = self;
    if (self.discussionId) {
      MBProgressHUD *hud = [MBProgressHUD showLoadingInView:self.view];
      __weak typeof(hud)wHud = hud;
      NSMutableArray *userIdList = [NSMutableArray array];
      for (SWFeedUserItem *user in _model.selectedContacts) {
        [userIdList safeAddObject:[user.uId stringValue]];
      }
      [[RCIMClient sharedRCIMClient] addMemberToDiscussion:self.discussionId
                                                userIdList:userIdList
                                                   success:^(RCDiscussion *discussion) {
                                                     dispatch_async(dispatch_get_main_queue(), ^{
                                                       [wHud hide:YES];
                                                       [wSelf dismissViewControllerAnimated:YES
                                                                                 completion:^{
                                                                                   TabViewController *tab = (TabViewController*)[UIApplication sharedApplication].delegate.window.rootViewController;
                                                                                   if([tab isKindOfClass:[TabViewController class]]){
                                                                                     [tab setSelectedIndex:SWTabIndexMsg];
                                                                                     [tab popChatSetting];
                                                                                   }
                                                                                 }];
                                                     });
                                                   } error:^(RCErrorCode status) {
                                                     
                                                   }];
    }else{
      NSMutableArray *userIdList = [NSMutableArray array];
      NSString *name = @"";
      for (NSString *uId in self.userIds) {
        [userIdList safeAddObject:uId];
        if (!self.singleChatName) {
          continue;
        }
        name = [name stringByAppendingString:[self.singleChatName stringByAppendingString:@"、"]];
      }
      
      for (SWFeedUserItem *user in _model.selectedContacts) {
        if (![userIdList containsObject:[user.uId stringValue]]) {
          [userIdList safeAddObject:[user.uId stringValue]];
          name = [name stringByAppendingString:[user.name stringByAppendingString:@"、"]];
        }
      }
      
      name = [name stringByAppendingString:[[NSUserDefaults standardUserDefaults] safeStringObjectForKey:@"userName"]];
      MBProgressHUD *hud = [MBProgressHUD showLoadingInView:self.view];
      __weak typeof(hud)wHud = hud;
      [[RCIMClient sharedRCIMClient] createDiscussion:name
                                           userIdList:userIdList
                                              success:^(RCDiscussion *discussion) {
                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                  [wHud hide:YES];
                                                  SWMsgVC *chat = [[SWMsgVC alloc] init];
                                                  chat.conversationType = ConversationType_DISCUSSION;
                                                  chat.targetId = discussion.discussionId;
                                                  chat.title = discussion.discussionName;
                                                  chat.hidesBottomBarWhenPushed = YES;
                                                  [wSelf dismissViewControllerAnimated:YES
                                                                            completion:^{
                                                                              TabViewController *tab = (TabViewController*)[UIApplication sharedApplication].delegate.window.rootViewController;
                                                                              if([tab isKindOfClass:[TabViewController class]]){
                                                                                [tab setSelectedIndex:SWTabIndexMsg];
                                                                                [tab pushChat:chat];
                                                                              }
                                                                            }];
                                                });
                                                
                                              }error:^(RCErrorCode status) {
                                                
                                              }];
    }
  }else if (_model.selectedContacts.count==1){
    SWMsgVC *chat = [[SWMsgVC alloc] init];
    chat.conversationType = ConversationType_PRIVATE;
    SWFeedUserItem *userItem = (SWFeedUserItem *)_model.selectedContacts.firstObject;
    chat.targetId = [userItem.uId stringValue];
    chat.title = userItem.name;
    chat.hidesBottomBarWhenPushed = YES;
    [[SWChatModel sharedInstance] saveUser:[userItem.uId stringValue] name:userItem.name picUrl:userItem.picUrl];
    [self dismissViewControllerAnimated:YES
                             completion:^{
                               TabViewController *tab = (TabViewController*)[UIApplication sharedApplication].delegate.window.rootViewController;
                               if([tab isKindOfClass:[TabViewController class]]){
                                 [tab setSelectedIndex:SWTabIndexMsg];
                                 [tab pushChat:chat];
                               }
                             }];
  }else{
    NSMutableArray *userIdList = [NSMutableArray array];
    NSString *name = @"";
    for (SWFeedUserItem *user in _model.selectedContacts) {
      [userIdList safeAddObject:[user.uId stringValue]];
      name = [name stringByAppendingString:[user.name stringByAppendingString:@"、"]];
    }
    name = [name stringByAppendingString:[[NSUserDefaults standardUserDefaults] safeStringObjectForKey:@"userName"]];
    __weak typeof(self)wSelf = self;
    MBProgressHUD *hud = [MBProgressHUD showLoadingInView:self.view];
    __weak typeof(hud)wHud = hud;
    [[RCIMClient sharedRCIMClient] createDiscussion:name
                                         userIdList:userIdList
                                            success:^(RCDiscussion *discussion) {
                                              [wHud hide:YES];
                                              SWMsgVC *chat = [[SWMsgVC alloc] init];
                                              chat.conversationType = ConversationType_DISCUSSION;
                                              chat.targetId = discussion.discussionId;
                                              chat.title = discussion.discussionName;
                                              chat.hidesBottomBarWhenPushed = YES;
                                              [wSelf dismissViewControllerAnimated:YES
                                                                        completion:^{
                                                                          TabViewController *tab = (TabViewController*)[UIApplication sharedApplication].delegate.window.rootViewController;
                                                                          if([tab isKindOfClass:[TabViewController class]]){
                                                                            [tab setSelectedIndex:SWTabIndexMsg];
                                                                            [tab pushChat:chat];
                                                                          }
                                                                        }];
                                            }error:^(RCErrorCode status) {
                                              
                                            }];
  }
  
}

- (void)reloadSelectView{  
  self.navigationItem.rightBarButtonItem = [UIBarButtonItem loadBarButtonItemWithTitle:_model.selectedContacts.count>0?[NSString stringWithFormat:@"%@(%d)",SWStringOkay,(int)_model.selectedContacts.count]:SWStringOkay
                                                                                 color:[UIColor colorWithRGBHex:_model.selectedContacts.count>0?0x55acef:0x8b9cad]
                                                                                  font:[UIFont systemFontOfSize:15]
                                                                                target:self action:@selector(startChat)];
}

#pragma mark tableView
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
  if ([_searchBar isFirstResponder]) {
    [_searchBar resignFirstResponder];
  }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  return _searchBar.text.length>0?[_model.searchedContacts count]:[_model.contacts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  static NSString *iden = @"contact";
  SWSelectContactCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
  if (!cell) {
    cell = [[SWSelectContactCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
  }
  [cell refreshUser:[(_searchBar.text.length>0?_model.searchedContacts:_model.contacts) safeObjectAtIndex:indexPath.row] selected:_model.selectedContacts];
  cell.btnChat.tag = indexPath.row;
  [cell.btnChat addTarget:self action:@selector(onChatClicked:) forControlEvents:UIControlEventTouchUpInside];
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  [_model dealUser:[(_searchBar.text.length>0?_model.searchedContacts:_model.contacts) safeObjectAtIndex:indexPath.row]];
  [tableView reloadData];
  [self reloadSelectView];
}
#pragma mark model
- (void)onChatClicked:(UIButton *)button{
  SWFeedUserItem *user = [_model.contacts safeObjectAtIndex:button.tag];
  [_model dealUser:user];
  [self startChat];
}

- (void)contactModelDidLoadContacts:(SWContactModel *)model{
  [_contactTableView reloadData];
  _emptyView.hidden = model.contacts.count;
}

- (void)contactModelDidSearchContacts:(SWContactModel *)model{
  [_contactTableView reloadData];
}

@end
