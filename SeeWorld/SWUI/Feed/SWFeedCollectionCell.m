//
//  SWFeedCollectionCell.m
//  SeeWorld
//
//  Created by Albert Lee on 9/3/15.
//  Copyright (c) 2015 SeeWorld. All rights reserved.
//

#import "SWFeedCollectionCell.h"
#import "SWFeedUserInfoHeaderView.h"
#import "SWFeedLikeMemberView.h"
#import "SWFeedInteractView.h"
#import "TTTAttributedLabel.h"
#import "SWAgreementVC.h"
@interface SWFeedCollectionCell()<SWFeedLikeMemberViewDelegate,SWFeedImageViewDelegate,
TTTAttributedLabelDelegate,UITextFieldDelegate,SWFeedInteractModelDelegate,
UITableViewDelegate,UITableViewDataSource,SWFeedInteractCommentCellDelegate>
@property(nonatomic, strong)UIView *bgView;
@property(nonatomic, strong)UIView *bgHeaderView;
@property(nonatomic, strong)SWFeedUserInfoHeaderView  *headerView;
@property(nonatomic, strong)SWFeedInteractView        *interactView;
@property(nonatomic, strong)TTTAttributedLabel        *lblContent;
@property(nonatomic, strong)SWFeedLikeMemberView      *likesView;
@property(nonatomic, strong)SWFeedItem                *feedItem;
@property(nonatomic, assign)NSInteger                 row;
@end

@implementation SWFeedCollectionCell{
  UITableView *_tableView;
}
- (id)initWithFrame:(CGRect)frame{
  self = [super initWithFrame:frame];
  if (self) {
    _interactModel = [[SWFeedInteractModel alloc] init];
    _interactModel.delegate = self;
    
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, iOSNavHeight - 10, UIScreenWidth, UIScreenHeight-iOSNavHeight)];
    _bgView.backgroundColor = [UIColor colorWithRGBHex:0xffffff];
    [self.contentView addSubview:_bgView];

    _bgHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, iOSNavHeight - 10, UIScreenWidth, UIScreenHeight-iOSNavHeight)];
    _bgHeaderView.backgroundColor = [UIColor colorWithRGBHex:0xffffff];
    [_bgView addSubview:_bgHeaderView];
    
    _headerView = [[SWFeedUserInfoHeaderView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, 55)];
    [_bgHeaderView addSubview:_headerView];
    
    _lblContent = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
    _lblContent.enabledTextCheckingTypes = NSTextCheckingTypeLink;
    _lblContent.delegate = self;
    _lblContent.textColor = [UIColor colorWithRGBHex:NAV_BAR_COLOR_HEX];
    _lblContent.font = [UIFont systemFontOfSize:16];
    _lblContent.linkAttributes = @{NSForegroundColorAttributeName:[UIColor colorWithRGBHex:0x2782D7]};
    _lblContent.lineBreakMode = NSLineBreakByCharWrapping;
    _lblContent.numberOfLines = 0;
    [_bgHeaderView addSubview:_lblContent];
    
    _feedImageView = [[SWFeedImageView alloc] initWithFrame:CGRectMake(-0.5, _headerView.bottom, UIScreenWidth+1, UIScreenWidth)];
    _feedImageView.delegate = self;
    [_bgHeaderView addSubview:_feedImageView];
    
    _interactView  = [[SWFeedInteractView alloc] initWithFrame:CGRectMake(0, _feedImageView.bottom, UIScreenWidth, 40)];
    [_bgHeaderView addSubview:_interactView];
    
    _likesView = [[SWFeedLikeMemberView alloc] initWithFrame:CGRectZero];
    [_bgHeaderView addSubview:_likesView];
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTableViewTapped:)];
    [_bgView addGestureRecognizer:gesture];
    
    _tableView = [[UITableView alloc] initWithFrame:_bgView.bounds style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate   = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.separatorColor = [UIColor colorWithRGBHex:0xe8e9e8];
    _tableView.backgroundColor= [UIColor colorWithRGBHex:0xffffff];
    _tableView.tableFooterView = [UIView new];
    _tableView.separatorInset = UIEdgeInsetsZero;
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, 48+iphoneXBottomAreaHeight, 0);
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    if (@available(iOS 11.0, *)) {
      _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [_bgView addSubview:_tableView];
    _tableView.tableHeaderView = _bgHeaderView;
    
    UITapGestureRecognizer *tableViewGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTableViewTapped:)];
    [_tableView addGestureRecognizer:tableViewGesture];
    
    
    _commentInputView = [[SWCommentInputView alloc] initWithFrame:CGRectMake(0, _bgView.height-48-iphoneXBottomAreaHeight, UIScreenWidth, 48+iphoneXBottomAreaHeight)];
    _commentInputView.txtField.delegate = self;
    [_commentInputView.btnPhoto addTarget:self action:@selector(onSendPhotoClicked) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:self.commentInputView];
  }
  return self;
}

- (BOOL)dismissKeyboard{
  if ([_commentInputView.txtField isFirstResponder]) {
    [_commentInputView.txtField resignFirstResponder];
    if(_commentInputView.txtField.text.length==0){
      _commentInputView.replyUser = nil;
    }
    return YES;
  }
  return NO;
}

#pragma mark TextField Delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
  if ([string isEqualToString:@"\n"]) {
    if ([[textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]>0) {
      [self dismissKeyboard];
      [_interactModel sendComment:textField.text replyUser:_commentInputView.replyUser];
      _commentInputView.replyUser = nil;
      textField.text = @"";
      return NO;
    }
  }
  return YES;
}

- (void)onSendPhotoClicked{
  [self dismissKeyboard];
  if (self.delegate && [self.delegate respondsToSelector:@selector(feedDetailViewDidNeedOpenImagePicker:)]) {
    [self.delegate feedDetailViewDidNeedOpenImagePicker:self];
  }
}

- (void)attributedLabel:(TTTAttributedLabel *)label
didLongPressLinkWithURL:(NSURL *)url
                atPoint:(CGPoint)point{
  if (self.delegate && [self.delegate respondsToSelector:@selector(feedDetailViewDidPressUrl:row:)]) {
    [self.delegate feedDetailViewDidPressUrl:url row:self.row];
  }
}

- (void)attributedLabel:(TTTAttributedLabel *)label
   didSelectLinkWithURL:(NSURL *)url{
  if (self.delegate && [self.delegate respondsToSelector:@selector(feedDetailViewDidPressUrl:row:)]) {
    [self.delegate feedDetailViewDidPressUrl:url row:self.row];
  }
}

- (void)refreshFeedView:(SWFeedItem *)feed row:(NSInteger)row{
  self.feedItem = feed;
  self.row      = row;
  _interactModel.feedItem = _feedItem;
  [_headerView refresshWithFeed:feed];
  NSAttributedString *content = [[NSAttributedString alloc] initWithString:feed.feed.content
                                                                attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],
                                                                             NSForegroundColorAttributeName:[UIColor colorWithRGBHex:NAV_BAR_COLOR_HEX]}];
  CGSize contentSize = [TTTAttributedLabel sizeThatFitsAttributedString:content
                                                        withConstraints:CGSizeMake(UIScreenWidth-30, 1000)
                                                 limitedToNumberOfLines:50];
  [_lblContent setText:content];
  _lblContent.frame = feed.feed.content.length?CGRectMake(15, 55, contentSize.width, contentSize.height+5):CGRectZero;
  [_headerView addTarget:self action:@selector(onHeaderClicked:) forControlEvents:UIControlEventTouchUpInside];
  [_feedImageView refreshWithFeed:feed];
  _feedImageView.delegate = self;
  _feedImageView.top = feed.feed.content.length?(_lblContent.bottom+10):55;
  
  [_interactView refreshWithFeed:feed];
  _interactView.top = _feedImageView.bottom;
  
  [_interactView.btnLike addTarget:self action:@selector(onLikeClicked:) forControlEvents:UIControlEventTouchUpInside];
  [_interactView.btnReply addTarget:self action:@selector(onReplyClicked:) forControlEvents:UIControlEventTouchUpInside];
  [_interactView.btnShare addTarget:self action:@selector(onShareClicked:) forControlEvents:UIControlEventTouchUpInside];
  
  [_likesView refreshWithFeedLikes:feed.likes count:[feed.likeCount integerValue]];
  _likesView.delegate = self;
  _likesView.top = MAX(_interactView.bottom, _lblContent.bottom) +10;
  
  
  _bgHeaderView.height = MAX(MAX(_likesView.bottom+10, _lblContent.bottom+15), _interactView.bottom+15);
  _tableView.tableHeaderView = _bgHeaderView;
  [_interactModel getComments];
}

- (void)onTableViewTapped:(UITapGestureRecognizer *)tap{
  CGPoint location = [tap locationInView:_tableView];
  NSIndexPath *path = [_tableView indexPathForRowAtPoint:location];
  
  if(path){
    [self tableView:_tableView didSelectRowAtIndexPath:path];
  }else{
    [self dismissKeyboard];
  }
}

+ (CGFloat)heightByFeed:(SWFeedItem *)feed{
  CGSize contentSize = [feed.feed.content sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}
                                           constrainedToSize:CGSizeMake(UIScreenWidth-30, 1000)];
  NSInteger contentHeight = 0;
  SWFeedType type = feed.feed.type;
  if (type == SWFeedTypeLink) {
    contentHeight = 62;
  }else if (type == SWFeedTypeVideo){
    SWFeedImageItem *photoItem = [feed.feed.photos safeObjectAtIndex:0];
    contentHeight = UIScreenWidth *photoItem.height/photoItem.width;
  }else if (type == SWFeedTypeImage){
    if (feed.feed.photos.count == 1) {
      SWFeedImageItem *photoItem = [feed.feed.photos safeObjectAtIndex:0];
      contentHeight = UIScreenWidth *photoItem.height/photoItem.width;
    }else if (feed.feed.photos.count == 2){
      contentHeight = UIScreenWidth/2.0;
    }else if (feed.feed.photos.count == 3){
      contentHeight = UIScreenWidth/3.0;
    }else if (feed.feed.photos.count == 4||
              (feed.feed.photos.count>=7 && feed.feed.photos.count<=9)){
      contentHeight = UIScreenWidth;
    }else if (feed.feed.photos.count == 5||
              feed.feed.photos.count == 6){
      contentHeight = UIScreenWidth * 2.0/3.0;
    }else{
      contentHeight = 0;
    }
  }

  return 10/*间隙*/+ 55/*头部*/ + contentHeight + 40 /*按钮*/
  + (feed.feed.content.length>0?(contentSize.height+15):0)
  + (feed.likes.count>0?30:0) /*赞成员*/ + ((feed.feed.content.length>0||feed.likes.count>0||feed.comments.count>0)?15:0);
}

- (void)onHeaderClicked:(UIButton *)button{
  [self dismissKeyboard];
  if (self.delegate && [self.delegate respondsToSelector:@selector(feedDetailViewDidPressUser:)]) {
    [self.delegate feedDetailViewDidPressUser:self.feedItem.user];
  }
}

- (void)onLikeClicked:(UIButton *)button{
  [self dismissKeyboard];
  __weak typeof(button)wButton = button;
  __weak typeof(self)wSelf = self;
  
  [UIView animateWithDuration:0.15
                   animations:^{
                     wButton.customImageView.transform = CGAffineTransformScale(wButton.transform, 1.5, 1.5);
                   } completion:^(BOOL finished) {
                     [UIView animateWithDuration:0.15
                                      animations:^{
                                        wButton.customImageView.transform = CGAffineTransformIdentity;
                                      }
                                      completion:^(BOOL finished) {
                                        if (wSelf.delegate && [wSelf.delegate respondsToSelector:@selector(feedDetailViewDidPressLike:row:)]) {
                                          [wSelf.delegate feedDetailViewDidPressLike:wSelf.feedItem row:wSelf.row];
                                        }
                                      }];
                   }];
}

- (void)onReplyClicked:(UIButton *)button{
  [_commentInputView.txtField becomeFirstResponder];
}

- (void)feedCommentViewDidPressUser:(SWFeedUserItem *)userItem{
  [self dismissKeyboard];
  if (self.delegate && [self.delegate respondsToSelector:@selector(feedDetailViewDidPressReply:row:)]) {
    [self.delegate feedDetailViewDidPressReply:self.feedItem row:self.row];
  }
}

- (void)feedCommentViewDidPressUrl:(NSURL *)url{
  [self dismissKeyboard];
  if (self.delegate && [self.delegate respondsToSelector:@selector(feedDetailViewDidPressUrl:row:)]) {
    [self.delegate feedDetailViewDidPressUrl:url row:self.row];
  }
}

- (void)onShareClicked:(UIButton *)button{
  [self dismissKeyboard];
  if (self.delegate && [self.delegate respondsToSelector:@selector(feedDetailViewDidPressShare:row:)]) {
    [self.delegate feedDetailViewDidPressShare:self.feedItem row:self.row];
  }
}

- (void)feedLikeMemberViewDidPressMore:(SWFeedLikeMemberView *)view{
  [self dismissKeyboard];
  if (self.delegate && [self.delegate respondsToSelector:@selector(feedDetailViewDidPressLikeList:row:)]) {
    [self.delegate feedDetailViewDidPressLikeList:self.feedItem row:self.row];
  }
}

- (void)feedLikeMemberViewDidPressUser:(SWFeedUserItem *)userItem{
  [self dismissKeyboard];
  if (self.delegate && [self.delegate respondsToSelector:@selector(feedDetailViewDidPressLikeList:row:)]) {
    [self.delegate feedDetailViewDidPressLikeList:self.feedItem row:self.row];
  }
}

- (void)feedImageViewDidPressTag:(SWFeedTagItem *)tagItem{
  [self dismissKeyboard];
  if (self.delegate && [self.delegate respondsToSelector:@selector(feedDetailViewDidPressTag:)]) {
    [self.delegate feedDetailViewDidPressTag:tagItem];
  }
}

- (void)feedImageViewDidPressImage:(SWFeedItem *)feedItem{
  if (![self dismissKeyboard]) {
    CGRect rect = [_feedImageView convertRect:_feedImageView.bounds toView:[UIApplication sharedApplication].delegate.window];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(feedDetailViewDidPressImage:rect:)]) {
      [self.delegate feedDetailViewDidPressImage:feedItem rect:rect];
    }
  }
}

#pragma mark Table View Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
  [self dismissKeyboard];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  return _interactModel.feedItem.comments.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  return [SWFeedInteractCommentCell heightOfComment:[_interactModel.feedItem.comments safeObjectAtIndex:indexPath.row]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  static NSString *idenComment = @"comment";
  SWFeedInteractCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:idenComment];
  if (!cell) {
    cell = [[SWFeedInteractCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idenComment];
  }
  [cell refreshComment:[_interactModel.feedItem.comments safeObjectAtIndex:indexPath.row]];
  cell.delegate = self;
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
  if ([tableView isEqual:_tableView]) {
    return NO;
  }
  return YES;
}

#pragma mark Comment Cell Delegate
- (void)feedInteractCommentCellDidPressImage:(NSString *)url rect:(CGRect)rect{
  if (![self dismissKeyboard]) {
    ALPhotoListFullView *view = [[ALPhotoListFullView alloc] initWithFrames:@[[NSValue valueWithCGRect:rect]]
                                                                  photoList:@[url]
                                                                      index:0];
    [[UIApplication sharedApplication].delegate.window addSubview:view];
    
  }
}

- (void)feedInteractCommentCellDidPressUrl:(NSURL *)url{
  SWAgreementVC *vc = [[SWAgreementVC alloc] init];
  vc.url = url.absoluteString;
  vc.hidesBottomBarWhenPushed = YES;
  [((UIViewController *)self.delegate).navigationController pushViewController:vc animated:YES];
}

- (void)feedInteractCommentCellDidNeedEnterUser:(SWFeedUserItem *)userItem{
  [self enterUserVC:userItem];
}

- (void)enterUserVC:(SWFeedUserItem *)userItem{
  [SWFeedUserItem pushUserVC:userItem nav:((UIViewController *)self.delegate).navigationController];
}

- (void)feedInteractCommentCellDidPressed:(SWFeedCommentItem *)commentItem{
  [self dismissKeyboard];
  
  if ([commentItem.user.relation integerValue]==SWUserRelationTypeSelf) {
    [self feedInteractCommentCellDidSwiped:commentItem];
  }else{
    self.commentInputView.replyUser = commentItem.user;
    [self.commentInputView.txtField becomeFirstResponder];
  }
}

- (void)feedInteractCommentCellDidSwiped:(SWFeedCommentItem *)commentItem{
  if ([commentItem.user.uId isEqualToNumber:@0]||[[commentItem.user.uId stringValue] isEqualToString:[[NSUserDefaults standardUserDefaults] safeStringObjectForKey:@"userId"]]||[commentItem.user.relation integerValue]==SWUserRelationTypeSelf||
      [_interactModel.feedItem.user.uId isEqual:@0]||[[_interactModel.feedItem.user.uId stringValue] isEqualToString:[[NSUserDefaults standardUserDefaults] safeStringObjectForKey:@"userId"]]) {
    __weak typeof(self)wSelf = self;
    [[[SWAlertView alloc] initWithTitle:@"刪除評論"
                             cancelText:SWStringCancel
                            cancelBlock:^{
                              
                            } okText:SWStringOkay
                                okBlock:^{
                                  [wSelf.interactModel deleteComment:commentItem];
                                }] show];
  }
}

- (BOOL)isMyPic{
  return [_interactModel.feedItem.user.uId isEqual:@0]||[[_interactModel.feedItem.user.uId stringValue] isEqualToString:[[NSUserDefaults standardUserDefaults] safeStringObjectForKey:@"userId"]];
}

#pragma mark InteractModel
- (void)feedInteractModelDidLoadComments:(SWFeedInteractModel *)model{
  [_tableView reloadData];
}

- (void)feedInteractModelDidDeleteComments:(SWFeedInteractModel *)model{
  [_tableView reloadData];
}

- (void)feedInteractModelDidSendComments:(SWFeedInteractModel *)model{
  [_interactModel getComments];
}

- (void)feedInteractModelDidSendImages:(SWFeedInteractModel *)model{
  [self feedInteractModelDidLoadComments:model];
}
@end
