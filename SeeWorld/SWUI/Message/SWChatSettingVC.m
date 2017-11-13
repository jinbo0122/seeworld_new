//
//  SWChatSettingVC.m
//  SeeWorld
//
//  Created by Albert Lee on 1/7/16.
//  Copyright © 2016 SeeWorld. All rights reserved.
//

#import "SWChatSettingVC.h"
#import "SWChatSettingCell.h"
#import "SWEditDiscussionNameVC.h"
#import "SWHomeFeedReportView.h"
#import "SWReportView.h"
@protocol SWChatSettingHeaderViewDelegate;
@interface SWChatSettingHeaderView : UIView
@property(nonatomic, weak)id<SWChatSettingHeaderViewDelegate>delegate;
@end
@protocol SWChatSettingHeaderViewDelegate <NSObject>

- (void)headerDidPressAvatar:(NSString *)userId;
- (void)headerDidPressAdd;
@end

@implementation SWChatSettingHeaderView{
  UIScrollView *_selectView;
}

- (id)initWithFrame:(CGRect)frame{
  if (self = [super initWithFrame:frame]){
    self.backgroundColor = [UIColor colorWithRGBHex:0x1a2531];
    _selectView  = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.width, 60)];
    _selectView.alwaysBounceHorizontal = YES;
    _selectView.contentInset = UIEdgeInsetsZero;
    [self addSubview:_selectView];
  }
  return self;
}

- (void)refreshUser:(NSArray *)users{
  for (UIView *view in [_selectView subviews]) {
    if (view.tag==100) {
      [view removeFromSuperview];
    }
  }
  
  for (NSInteger i=0; i<=users.count; i++) {
    if (i==users.count) {
      UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(5+60*i, 0, 60, 60)];
      UIImageView *avatar = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
      avatar.layer.masksToBounds = YES;
      avatar.layer.cornerRadius  = avatar.width/2.0;
      avatar.tag = 100;
      avatar.image = [UIImage imageNamed:@"chat_btn_addpeople"];
      [button addSubview:avatar];
      [button addTarget:self action:@selector(onAddClick) forControlEvents:UIControlEventTouchUpInside];
      [_selectView addSubview:button];
      break;
    }
    
    NSString *userId = [users safeObjectAtIndex:i];
    __weak typeof(_selectView)selectView = _selectView;
    __weak typeof(self)wSelf = self;
    [[SWChatModel sharedInstance]
     getUserInfoWithUserId:userId
     completion:^(RCUserInfo *userInfo) {
       dispatch_async(dispatch_get_main_queue(), ^{
         UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(5+60*i, 0, 60, 60)];
         [selectView addSubview:button];
         
         UIImageView *avatar = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
         avatar.layer.masksToBounds = YES;
         avatar.layer.cornerRadius  = avatar.width/2.0;
         [avatar sd_setImageWithURL:[NSURL URLWithString:userInfo.portraitUri]];
         avatar.tag = 100;
         avatar.layer.borderColor = [UIColor whiteColor].CGColor;
         avatar.layer.borderWidth = 1.0;
         [button addSubview:avatar];
         
         button.tagString = userInfo.userId;
         [button addTarget:wSelf action:@selector(onUserClicked:) forControlEvents:UIControlEventTouchUpInside];
       });

     }];
    

  }
  _selectView.contentSize = CGSizeMake(MAX(_selectView.width, 15+75*(users.count+1)), 60);
  if (_selectView.contentSize.width>_selectView.width) {
    [_selectView setContentOffset:CGPointMake(_selectView.contentSize.width-_selectView.width, 0)];
  }
}

- (void)onUserClicked:(UIButton*)button{
  if (self.delegate && [self.delegate respondsToSelector:@selector(headerDidPressAvatar:)]) {
    [self.delegate headerDidPressAvatar:button.tagString];
  }
}

- (void)onAddClick{
  if (self.delegate && [self.delegate respondsToSelector:@selector(headerDidPressAdd)]) {
    [self.delegate headerDidPressAdd];
  }
}

@end

@interface SWChatSettingFooterView : UIView
@property(nonatomic, strong)UIButton *btnQuit;
@end

@implementation SWChatSettingFooterView

- (id)initWithFrame:(CGRect)frame{
  if (self = [super initWithFrame:frame]){
    self.backgroundColor = [UIColor colorWithRGBHex:0x1a2531];
    [self addSubview:[ALLineView lineWithFrame:CGRectMake(0, 0, self.width, 0.4) colorHex:0x2a536e]];
    self.btnQuit = [[UIButton alloc] initWithFrame:CGRectMake(10, 30, self.width-20, 44)];
    [self.btnQuit setBackgroundColor:[UIColor colorWithRGBHex:0xec5050]];
    [self.btnQuit setTitle:SWStringDeleteQuit forState:UIControlStateNormal];
    [self.btnQuit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnQuit.titleLabel setFont:[UIFont systemFontOfSize:17]];
    self.btnQuit.layer.masksToBounds = YES;
    self.btnQuit.layer.cornerRadius  = 4.0;
    [self addSubview:self.btnQuit];
  }
  return self;
}

@end

@interface SWChatSettingVC ()<UITableViewDataSource,UITableViewDelegate,SWChatSettingCellDelegate,
SWChatSettingHeaderViewDelegate>
@property(nonatomic, strong)SWChatSettingHeaderView *headerView;
@property(nonatomic, strong)SWChatSettingFooterView *footerView;
@property(nonatomic, strong)UITableView             *tableView;
@property(nonatomic, strong)RCConversation          *chat;
@property(nonatomic, strong)RCDiscussion            *discussion;
@end

@implementation SWChatSettingVC

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor colorWithRGBHex:0x1a2531];
  self.navigationItem.titleView = [[ALTitleLabel alloc] initWithTitle:SWStringChatDetail color:[UIColor colorWithRGBHex:0x191d28]];
  self.automaticallyAdjustsScrollViewInsets = NO;
  self.headerView = [[SWChatSettingHeaderView alloc] initWithFrame:CGRectMake(0, iOSNavHeight, self.view.width, 60)];
  [self.view addSubview:self.headerView];
  self.headerView.delegate = self;
  
  self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.headerView.bottom, self.view.width, self.view.height-self.headerView.bottom)
                                                style:UITableViewStylePlain];
  self.tableView.backgroundColor = [UIColor colorWithRGBHex:0xf5f4f9];
  self.tableView.delegate = self;
  self.tableView.dataSource = self;
  self.tableView.rowHeight = 45;
  self.tableView.backgroundColor = [UIColor colorWithRGBHex:0x1a2531];
  self.tableView.separatorColor = [UIColor colorWithRGBHex:0x2a536e];
  self.tableView.separatorInset = UIEdgeInsetsZero;
  self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
  [self.view addSubview:self.tableView];
  
  __weak typeof(self)wSelf = self;
  if (self.cType==ConversationType_DISCUSSION) {
    self.footerView = [[SWChatSettingFooterView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 104)];
    [self.footerView.btnQuit addTarget:self action:@selector(onQuitClicked) forControlEvents:UIControlEventTouchUpInside];
    self.tableView.tableFooterView = self.footerView;
    self.chat = [[RCIMClient sharedRCIMClient] getConversation:ConversationType_DISCUSSION
                                                      targetId:self.targetId];
    [[RCIMClient sharedRCIMClient] getDiscussion:self.targetId
                                         success:^(RCDiscussion *discussion) {
                                           wSelf.discussion = discussion;
                                           [wSelf.tableView reloadData];
                                           [wSelf.headerView refreshUser:wSelf.discussion.memberIdList];
                                         } error:^(RCErrorCode status) {
                                           
                                         }];
  }else{
    self.tableView.tableFooterView = [ALLineView lineWithFrame:CGRectMake(0, 0, self.view.width, 0.5) colorHex:0x1a2531];
    self.chat = [[RCIMClient sharedRCIMClient] getConversation:ConversationType_PRIVATE
                                                      targetId:self.targetId];
    [self.headerView refreshUser:@[self.targetId]];
    [self.tableView reloadData];
  }
}

- (void)viewDidAppear:(BOOL)animated{
  [super viewDidAppear:animated];
  if (self.cType==ConversationType_DISCUSSION) {
    __weak typeof(self)wSelf = self;
    [[RCIMClient sharedRCIMClient] getDiscussion:self.targetId
                                         success:^(RCDiscussion *discussion) {
                                           wSelf.discussion = discussion;
                                           [wSelf.tableView reloadData];
                                         } error:^(RCErrorCode status) {
                                           
                                         }];
  }
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)onQuitClicked{
  __weak typeof(self)wSelf = self;
  SWReportView *reportView = [[SWReportView alloc] initWithTitle:SWStringDeleteQuit];
  reportView.block = ^{
    MBProgressHUD *hud = [MBProgressHUD showLoadingInView:wSelf.view];
    __weak typeof(hud)wHud = hud;
    [[RCIMClient sharedRCIMClient] removeConversation:wSelf.cType targetId:wSelf.targetId];
    [[RCIMClient sharedRCIMClient] quitDiscussion:wSelf.targetId
                                          success:^(RCDiscussion *discussion) {
                                            dispatch_async(dispatch_get_main_queue(), ^{
                                              [wHud hide:YES];
                                              [wSelf.navigationController popToRootViewControllerAnimated:YES];
                                            });
                                          } error:^(RCErrorCode status) {
                                            
                                          }];
  };
  [reportView show];
}

- (void)editDiscussionName{
  SWEditDiscussionNameVC *vc = [[SWEditDiscussionNameVC alloc] init];
  vc.targetId = self.targetId;
  [self.navigationController pushViewController:vc animated:YES];
}

- (void)reportChat{
  SWHomeFeedReportView *reportView = [[SWHomeFeedReportView alloc] initWithFrame:[UIScreen mainScreen].bounds];
  reportView.userId = self.targetId;
  [reportView show];
}

- (void)clearMsgs{
  __weak typeof(self)wSelf = self;
  SWReportView *reportView = [[SWReportView alloc] initWithTitle:SWStringClearMsgs];
  reportView.block = ^{
    [wSelf.messages removeAllObjects];
    [[RCIMClient sharedRCIMClient] clearMessages:wSelf.cType targetId:wSelf.targetId];
  };
  [reportView show];
}

#pragma mark header
- (void)headerDidPressAvatar:(NSString *)userId{
  SWFeedUserItem *item = [[SWFeedUserItem alloc] init];
  item.uId = [userId numberValue];
  [SWFeedUserItem pushUserVC:item nav:self.navigationController];
}

- (void)headerDidPressAdd{
  SWSelectContactVC *vc = [[SWSelectContactVC alloc] init];
  vc.userIds = (self.cType==ConversationType_DISCUSSION)?self.discussion.memberIdList:@[self.targetId];
  vc.isFromAdd = YES;
  vc.discussionId = (self.cType==ConversationType_DISCUSSION)?self.discussion.discussionId:nil;
  if (self.chat) {
    vc.singleChatName = self.cType==ConversationType_PRIVATE?[[self.chat.jsonDict safeDicObjectForKey:@"user"] safeStringObjectForKey:@"name"]:@"";
  }
  UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
  [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark table view
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
  return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  if (self.cType == ConversationType_PRIVATE) {
    return section==2?1:2;
  }else if (self.cType==ConversationType_DISCUSSION){
    return section==0?3:1;
  }
  return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  static NSString *iden = @"setting";
  SWChatSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
  if (!cell) {
    cell = [[SWChatSettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
  }
  if (self.cType==ConversationType_PRIVATE) {
    cell.chat = self.chat;
  }else{
    cell.chat = self.chat;
    cell.discussion = self.discussion;
  }
  [cell refreshWithIndexPath:indexPath cType:self.cType];
  cell.delegate = self;
  cell.selectionStyle = UITableViewCellSelectionStyleNone;
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  if (self.cType==ConversationType_DISCUSSION && indexPath.section==0 && indexPath.row==0) {
    [self editDiscussionName];
  }else if ((self.cType==ConversationType_DISCUSSION && indexPath.section==1)||
            (self.cType==ConversationType_PRIVATE && indexPath.section==1 && indexPath.row==1)) {
    [self reportChat];
  }else if ((self.cType==ConversationType_DISCUSSION && indexPath.section==2)||
            (self.cType==ConversationType_PRIVATE && indexPath.section==2)) {
    [self clearMsgs];
  }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
  UIView *view =[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 20)];
  [view addSubview:[ALLineView lineWithFrame:CGRectMake(0, 0, self.view.width, 0.5) colorHex:0x2a536e]];
  [view addSubview:[ALLineView lineWithFrame:CGRectMake(0, 19.5, self.view.width, 0.5) colorHex:0x2a536e]];
  return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
  return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
  return [ALLineView lineWithFrame:CGRectMake(0, 0, self.view.width, 0.5) colorHex:0x2a536e];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
  return 0.5;
}
#pragma mark cell
- (void)chatSettingCellDidPressSwitch:(SWChatSettingCell *)cell isON:(BOOL)isON{
  if (cell.swtchType==SWChatSettingSwitchTypeTop) {
    [[RCIMClient sharedRCIMClient] setConversationToTop:self.cType
                                               targetId:self.targetId isTop:isON];
  }else if (cell.swtchType==SWChatSettingSwitchTypeMute){
    [[RCIMClient sharedRCIMClient] setConversationNotificationStatus:self.cType
                                                            targetId:self.targetId
                                                           isBlocked:isON
                                                             success:^(RCConversationNotificationStatus nStatus) {
                                                               
                                                             } error:^(RCErrorCode status) {
                                                               
                                                             }];
  }else if (cell.swtchType==SWChatSettingSwitchTypeAddblack){
    if (isON) {
      [[RCIMClient sharedRCIMClient] addToBlacklist:self.targetId
                                            success:^{
                                              
                                            } error:^(RCErrorCode status) {
                                              
                                            }];
    }else{
      [[RCIMClient sharedRCIMClient] removeFromBlacklist:self.targetId success:^{
        
      } error:^(RCErrorCode status) {
        
      }];
    }
    
  }
  
}
@end
