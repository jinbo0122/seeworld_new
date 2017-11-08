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
  UIScrollView     *_selectView;
  UITableView      *_contactTableView;
  SWContactModel   *_model;
  UIView           *_emptyView;
  UIView           *_line;
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
                                                                color:[UIColor whiteColor]
                                                             fontSize:19];
  self.navigationItem.leftBarButtonItem = [UIBarButtonItem loadLeftBarButtonItemWithTitle:SWStringCancel
                                                                                    color:[UIColor colorWithRGBHex:0x8b9cad]
                                                                                     font:[UIFont systemFontOfSize:15]
                                                                                   target:self action:@selector(cancel)];
  self.navigationItem.rightBarButtonItem = [UIBarButtonItem loadBarButtonItemWithTitle:SWStringOkay
                                                                                 color:[UIColor colorWithRGBHex:0x8b9cad]
                                                                                  font:[UIFont systemFontOfSize:15]
                                                                                target:self action:@selector(startChat)];
  self.view.backgroundColor = [UIColor colorWithRGBHex:0x1a2531];
  self.automaticallyAdjustsScrollViewInsets = NO;
  _selectView  = [[UIScrollView alloc] initWithFrame:CGRectMake(0, iOS7NavHeight, self.view.width, 104)];
  _selectView.alwaysBounceHorizontal = YES;
  _selectView.contentInset = UIEdgeInsetsZero;
  [self.view addSubview:_selectView];
  
  _searchBar = [[SWSearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 44)];
  [_selectView addSubview:_searchBar];
  _searchBar.showsCancelButton = NO;
  _searchBar.placeholder = SWStringSearch;
  _searchBar.delegate = self;
  
  [self reloadSelectView];
  
  _line = [[UIView alloc] initWithFrame:CGRectMake(0, _selectView.bottom, self.view.width, 1)];
  _line.backgroundColor = [UIColor colorWithRGBHex:0x2a3a4b];
  [self.view addSubview:_line];
  _line.hidden = YES;
  
  _contactTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _line.bottom, self.view.width, self.view.height-_line.bottom)
                                                   style:UITableViewStylePlain];
  _contactTableView.dataSource = self;
  _contactTableView.delegate   = self;
  _contactTableView.rowHeight  = 60.0;
  _contactTableView.backgroundColor = [UIColor colorWithRGBHex:0x1a2531];
  _contactTableView.separatorColor = [UIColor colorWithRGBHex:0x2a3847];
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
                                                                                     [tab setSelectedIndex:3];
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
                                                                                [tab setSelectedIndex:3];
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
                                 [tab setSelectedIndex:3];
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
                                                                            [tab setSelectedIndex:3];
                                                                            [tab pushChat:chat];
                                                                          }
                                                                        }];
                                            }error:^(RCErrorCode status) {
                                              
                                            }];
  }
  
}

- (void)reloadSelectView{
  for (UIImageView *avatar in [_selectView subviews]) {
    if (avatar.tag==100) {
      [avatar removeFromSuperview];
    }
  }
  
  if (_model.selectedContacts.count==0) {    
    UILabel *label = [UILabel initWithFrame:CGRectMake(15, 54, self.view.width-30, 40)
                                    bgColor:[UIColor clearColor]
                                  textColor:[UIColor colorWithRGBHex:0x535962]
                                       text:@"直接添加或搜尋好友"
                              textAlignment:NSTextAlignmentLeft
                                       font:[UIFont systemFontOfSize:16]];
    label.tag = 100;
    [_selectView addSubview:label];
  }else{
    for (NSInteger i=0; i<_model.selectedContacts.count; i++) {
      SWFeedUserItem *user = [_model.selectedContacts safeObjectAtIndex:i];
      UIImageView *avatar = [[UIImageView alloc] initWithFrame:CGRectMake(15+50*i,44+ 10, 40, 40)];
      avatar.layer.masksToBounds = YES;
      avatar.layer.cornerRadius  = 20;
      [avatar sd_setImageWithURL:[NSURL URLWithString:user.picUrl]];
      avatar.layer.borderColor = [UIColor whiteColor].CGColor;
      avatar.layer.borderWidth = 1.0;
      avatar.tag = 100;
      [_selectView addSubview:avatar];
    }
  }
  
  _selectView.contentSize = CGSizeMake(MAX(_selectView.width, 15+50*_model.selectedContacts.count+10), _selectView.height);
  if (_selectView.contentSize.width>_selectView.width) {
    [_selectView setContentOffset:CGPointMake(_selectView.contentSize.width-_selectView.width, 0)];
  }
  
  self.navigationItem.rightBarButtonItem = [UIBarButtonItem loadBarButtonItemWithTitle:_model.selectedContacts.count>0?[NSString stringWithFormat:@"%@(%d)",SWStringOkay,(int)_model.selectedContacts.count]:SWStringOkay
                                                                                 color:[UIColor colorWithRGBHex:_model.selectedContacts.count>0?0x28e4f2:0x8b9cad]
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
  _line.hidden = !model.contacts.count;
}

- (void)contactModelDidSearchContacts:(SWContactModel *)model{
  [_contactTableView reloadData];
}

@end
