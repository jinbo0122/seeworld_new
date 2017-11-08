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
@interface SWChatListVC ()

@end

@implementation SWChatListVC{
  BOOL _pushing;
}
- (void)reloadChats{
  _pushing = NO;
  [self refreshConversationTableViewIfNeeded];
}
- (void)viewDidLoad {
  //重写显示相关的接口，必须先调用super，否则会屏蔽SDK默认的处理
  [super viewDidLoad];
  
  //设置需要显示哪些类型的会话
  [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE),
                                      @(ConversationType_DISCUSSION),
                                      @(ConversationType_APPSERVICE),
                                      @(ConversationType_SYSTEM)]];
  [self setCollectionConversationType:@[]];
  [self setConversationAvatarStyle:RC_USER_AVATAR_CYCLE];
  self.conversationListTableView.tableFooterView = [ALLineView lineWithFrame:CGRectMake(0, 0, UIScreenWidth, 1) colorHex:0x1a2531];
  self.conversationListTableView.separatorInset = UIEdgeInsetsZero;
  self.conversationListTableView.separatorColor = [UIColor colorWithRGBHex:0x2a3847];
  self.conversationListTableView.contentInset = UIEdgeInsetsMake(0, 0, 49, 0);
  self.conversationListTableView.backgroundColor = [UIColor colorWithRGBHex:0x1a2531];
  [self setConversationPortraitSize:CGSizeMake(40, 40)];
  [self setCellBackgroundColor:[UIColor colorWithRGBHex:0x1a2531]];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

//- (UIColor *)cellBackgroundColor{
//  return [UIColor colorWithRGBHex:0x1a2531];
//}

//重写RCConversationListViewController的onSelectedTableRow事件
- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType
         conversationModel:(RCConversationModel *)model
               atIndexPath:(NSIndexPath *)indexPath {
  SWMsgVC *vc = [[SWMsgVC alloc]init];
  vc.conversationType = model.conversationType;
  vc.targetId = model.targetId;
  vc.title = model.conversationTitle;
  vc.hidesBottomBarWhenPushed = YES;
  if (self.delegate && [self.delegate respondsToSelector:@selector(chatListDidPressWithVC:)]) {
    _pushing = YES;
    [self.delegate chatListDidPressWithVC:vc];
  }
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
  cell.backgroundColor = [UIColor colorWithRGBHex:0x1a2531];
  UILabel *lblTime = [cell performSelector:@selector(messageCreatedTimeLabel)];
  if (lblTime) {
    lblTime.font = [UIFont systemFontOfSize:9];
    lblTime.textColor = [UIColor colorWithRGBHex:0x8b9cad];
  }
  UILabel *lblTitle = [cell performSelector:@selector(conversationTitle)];
  if (lblTitle) {
    lblTitle.font = [UIFont systemFontOfSize:14];
    lblTitle.textColor = [UIColor colorWithRGBHex:0x838cda];
    CGSize titleSize = [lblTitle.text sizeWithAttributes:@{NSFontAttributeName:lblTitle.font}
                                       constrainedToSize:CGSizeMake(lblTime.left-60, 16)];
    lblTitle.width = titleSize.width;
  }
  
  UILabel *lblContent = [cell performSelector:@selector(messageContentLabel)];
  if (lblContent) {
    lblContent.font = [UIFont systemFontOfSize:12];
    lblContent.textColor = [UIColor colorWithRGBHex:0xfbfcfc];
    CGSize contentSize = [lblContent.text sizeWithAttributes:@{NSFontAttributeName:lblContent.font}
                                           constrainedToSize:CGSizeMake(UIScreenWidth-60, 16)];
    lblContent.width = contentSize.width;
  }
  cell.layoutMargins = UIEdgeInsetsZero;
}

- (CGFloat)rcConversationListTableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  return 66;
}

- (void)showEmptyConversationView{
  self.emptyConversationView = [[UIView alloc] initWithFrame:self.view.bounds];
  self.emptyConversationView.backgroundColor = [UIColor colorWithRGBHex:0x1a2531];
  [self.view addSubview:self.emptyConversationView];
}
@end
