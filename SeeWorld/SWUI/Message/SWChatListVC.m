//
//  SWChatListVC.m
//  SeeWorld
//
//  Created by Albert Lee on 12/22/15.
//  Copyright © 2015 SeeWorld. All rights reserved.
//

#import "SWChatListVC.h"
#import "TabViewController.h"
#import "SWChatCell.h"
@interface SWChatListVC ()<SWChatModelDelegate>

@end

@implementation SWChatListVC{
  BOOL _pushing;
  BOOL _isChatConnected;
  UIImageView *_emptyChatView;
}
- (id)init{
  if (self = [super init]) {
    [SWChatModel sharedInstance].delegate = self;
    [[NSNotificationCenter defaultCenter] addObserverForName:@"RCIMConnected" object:nil queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification * _Nonnull note) {
                                                    _isChatConnected = YES;
                                                  }];
  }
  return self;
}

- (void)viewWillAppear:(BOOL)animated{
  [super viewWillAppear:animated];
  [self reloadChats];
}

- (void)reloadChats{
  _pushing = NO;
  [self refreshConversationTableViewIfNeeded];
}
- (void)viewDidLoad {
  //重写显示相关的接口，必须先调用super，否则会屏蔽SDK默认的处理
  [super viewDidLoad];
  self.navigationItem.titleView = [[ALTitleLabel alloc] initWithTitle:@"聊天" color:[UIColor colorWithRGBHex:NAV_BAR_COLOR_HEX]];
  //设置需要显示哪些类型的会话
  [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE),
                                      @(ConversationType_DISCUSSION),
                                      @(ConversationType_APPSERVICE),
                                      @(ConversationType_SYSTEM)]];
  [self setCollectionConversationType:@[]];
  [self setConversationAvatarStyle:RC_USER_AVATAR_CYCLE];
  self.conversationListTableView.tableFooterView = [ALLineView lineWithFrame:CGRectMake(0, 0, UIScreenWidth, 1) colorHex:0xE8EDF3];
  self.conversationListTableView.separatorInset = UIEdgeInsetsMake(0, 71, 0, 0);
  self.conversationListTableView.separatorColor = [UIColor colorWithRGBHex:0xcccccc];
  self.conversationListTableView.contentInset = UIEdgeInsetsMake(0, 0, 49, 0);
  self.conversationListTableView.backgroundColor = [UIColor colorWithRGBHex:0xffffff];
  [self setConversationPortraitSize:CGSizeMake(50, 50)];
  [self setCellBackgroundColor:[UIColor colorWithRGBHex:0xffffff]];
  
  __weak typeof(self)wSelf = self;
  [[NSNotificationCenter defaultCenter] addObserverForName:@"RCIMConnected" object:nil queue:[NSOperationQueue mainQueue]
                                                usingBlock:^(NSNotification * _Nonnull note) {
                                                  [wSelf initChatVC];
                                                }];
  
  if (_isChatConnected) {
    [self initChatVC];
  }
  
  UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"notice_btn_chat"]
                                                               style:UIBarButtonItemStylePlain
                                                              target:self action:@selector(onNewChatClicked)];
  self.navigationItem.rightBarButtonItem = rightBar;
}

- (void)initChatVC{
  _emptyChatView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.width + (self.view.width-144)/2.0,iOSNavHeight+50, 144, 144)];
  _emptyChatView.image = [UIImage imageNamed:@"no_message"];
  _emptyChatView.tag = 1001;
  [self.view addSubview:_emptyChatView];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)onNewChatClicked{
  TabViewController *tabVC = (TabViewController *)[UIApplication sharedApplication].delegate.window.rootViewController;
  if ([tabVC isKindOfClass:[TabViewController class]]) {
    [tabVC startChat];
  }
}

//重写RCConversationListViewController的onSelectedTableRow事件
- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType
         conversationModel:(RCConversationModel *)model
               atIndexPath:(NSIndexPath *)indexPath {
  SWMsgVC *vc = [[SWMsgVC alloc]init];
  vc.conversationType = model.conversationType;
  vc.targetId = model.targetId;
  vc.title = model.conversationTitle;
  vc.hidesBottomBarWhenPushed = YES;
  _pushing = YES;
  [self.navigationController pushViewControllerWithCustomAnimation:vc];
}
#pragma mark - 收到消息监听
-(void)didReceiveMessageNotification:(NSNotification *)notification{
  if (!_pushing) {
    [self refreshConversationTableViewIfNeeded];
  }
}

- (void)refreshConversationTableViewIfNeeded{
  [super refreshConversationTableViewIfNeeded];
  [self setEmpty:[self.conversationListTableView numberOfRowsInSection:0]==0];
  dispatch_async(dispatch_get_main_queue(), ^{
    [TabViewController dotAppearance];
  });
}

- (void)setEmpty:(BOOL)empty{
  dispatch_async(dispatch_get_main_queue(), ^{
    UIScrollView *scrollView = (UIScrollView*)[self.view superview];
    if ([scrollView isKindOfClass:[UIScrollView class]]) {
      NSArray *views = [scrollView subviews];
      for (UIImageView *imageView in views) {
        if (imageView.tag == 1001) {
          imageView.hidden = !empty;
          break;
        }
      }
    }
  });
}

- (void)didDeleteConversationCell:(RCConversationModel *)model{
  [self setEmpty:[self.conversationListTableView numberOfRowsInSection:0]==0];
}

- (void)notifyUpdateUnreadMessageCount{
  [super notifyUpdateUnreadMessageCount];
}

- (void)refreshConversationTableViewWithConversationModel:(RCConversationModel *)conversationModel{
  [super refreshConversationTableViewWithConversationModel:conversationModel];
}

-(NSMutableArray*)willReloadTableData:(NSMutableArray*)dataSource{
  [self setEmpty:dataSource.count==0];
  return dataSource;
}

- (void)willDisplayConversationTableCell:(RCConversationBaseCell *)cell
                             atIndexPath:(NSIndexPath *)indexPath{
  cell.selectionStyle = UITableViewCellSelectionStyleNone;
  cell.backgroundColor = [UIColor colorWithRGBHex:0xffffff];
  UILabel *lblTime = [cell performSelector:@selector(messageCreatedTimeLabel)];
  if (lblTime) {
    lblTime.font = [UIFont systemFontOfSize:13];
    lblTime.textColor = [UIColor colorWithRGBHex:0x8e8e8e];
  }
  UILabel *lblTitle = [cell performSelector:@selector(conversationTitle)];
  if (lblTitle) {
    lblTitle.font = [UIFont systemFontOfSize:16];
    lblTitle.textColor = [UIColor colorWithRGBHex:0x3414e];
    CGSize titleSize = [lblTitle.text sizeWithAttributes:@{NSFontAttributeName:lblTitle.font}
                                       constrainedToSize:CGSizeMake(lblTime.left-60, 16)];
    lblTitle.width = titleSize.width;
  }
  
  UILabel *lblContent = [cell performSelector:@selector(messageContentLabel)];
  if (lblContent) {
    lblContent.font = [UIFont systemFontOfSize:16];
    lblContent.textColor = [UIColor colorWithRGBHex:0x8e8e8e];
    CGSize contentSize = [lblContent.text sizeWithAttributes:@{NSFontAttributeName:lblContent.font}
                                           constrainedToSize:CGSizeMake(UIScreenWidth-60, 16)];
    lblContent.width = contentSize.width;
  }
  cell.layoutMargins = UIEdgeInsetsMake(0, 71, 0, 0);
}

- (CGFloat)rcConversationListTableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  return 70;
}

- (void)showEmptyConversationView{
  self.emptyConversationView = [[UIView alloc] initWithFrame:self.view.bounds];
  self.emptyConversationView.backgroundColor = [UIColor colorWithRGBHex:0xffffff];
  [self.view addSubview:self.emptyConversationView];
}

- (void)chatModelDidLoadChats:(SWChatModel *)model{
  
}
@end
