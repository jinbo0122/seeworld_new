//
//  SWFeedInteractVC.m
//  SeeWorld
//
//  Created by Albert Lee on 9/2/15.
//  Copyright (c) 2015 SeeWorld. All rights reserved.
//

#import "SWFeedInteractVC.h"
#import "SWExploreSegView.h"
#import "SWFeedInteractCommentCell.h"
#import "SWFeedInteractLikeCell.h"
#import "SWCommentInputView.h"
#import "UzysAssetsPickerController.h"
#import "SWAgreementVC.h"

@interface SWFeedInteractVC ()<UITableViewDataSource,UITableViewDelegate,
SWExploreSegViewDelegate,SWFeedInteractLikeCellDelegate,SWFeedInteractCommentCellDelegate,
SWFeedInteractModelDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property(nonatomic, strong)UITableViewController *tbVCComments;
@property(nonatomic, strong)UITableViewController *tbVCLikes;
@property(nonatomic, strong)UIScrollView          *scrollView;
@property(nonatomic, strong)SWExploreSegView      *titleView;
@property(nonatomic, strong)SWCommentInputView    *commentInputView;
@end

@implementation SWFeedInteractVC
- (id)init{
  self = [super init];
  if (self) {
    self.model = [[SWFeedInteractModel alloc] init];
    self.model.delegate = self;
  }
  return self;
}
- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  if (self.isModal) {
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem loadBarButtonItemWithImage:@"back" rect:CGRectMake(0, 12.5, 11, 19)
                                                                                  arget:self action:@selector(onDismissVC)];
  }
  self.automaticallyAdjustsScrollViewInsets = NO;
  [self uiInitialize];
  
  [self.model getComments];
  [self.model getLikes];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated{
  [super viewWillDisappear:animated];
  BOOL isMenuVisible = [[UIMenuController sharedMenuController] isMenuVisible];
  if (isMenuVisible) {
    [[UIMenuController sharedMenuController] setMenuVisible:NO animated:NO];
  }
}

#pragma mark Custom
- (void)onDismissVC{
  if (self.delegate && [self.delegate respondsToSelector:@selector(feedInteractVCDidDismiss:row:likes:comments:)]) {
    [self.delegate feedInteractVCDidDismiss:self row:self.feedRow likes:self.model.feedItem.likes comments:self.model.feedItem.comments];
  }else{
    [self dismissViewControllerAnimated:YES completion:nil];
  }
}

- (void)uiInitialize{
  self.titleView = [[SWExploreSegView alloc] initWithFrame:CGRectMake(0, iOSNavHeight, self.view.width, 38)
                                                     items:@[@"",@""]
                                                    images:@[@"home_btn_comment",@"home_btn_like"]];
  self.titleView.delegate = self;
  self.titleView.selectedIndex = self.defaultIndex;
  [self.view addSubview:self.titleView];
  
  self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.titleView.bottom, self.view.width, self.view.height-self.titleView.bottom)];
  self.scrollView.bounces = NO;
  self.scrollView.scrollEnabled = NO;
  self.scrollView.contentSize = CGSizeMake(UIScreenWidth *2, 1);
  [self.view addSubview:self.scrollView];
  
  self.tbVCComments = [[UITableViewController alloc] initWithStyle:UITableViewStylePlain];
  self.tbVCComments.view.frame = self.view.bounds;
  self.tbVCComments.tableView.dataSource = self;
  self.tbVCComments.tableView.delegate   = self;
  self.tbVCComments.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
  self.tbVCComments.tableView.separatorColor = [UIColor colorWithRGBHex:0xe8e9e8];
  self.tbVCComments.tableView.backgroundColor= [UIColor colorWithRGBHex:0xffffff];
  self.tbVCComments.tableView.contentInset   = UIEdgeInsetsMake(0, 0, 48+iOSNavHeight+self.titleView.height+iphoneXBottomAreaHeight, 0);
  self.tbVCComments.tableView.tableFooterView = [UIView new];
  self.tbVCComments.tableView.separatorInset = UIEdgeInsetsZero;
  self.tbVCComments.refreshControl = [[UIRefreshControl alloc] init];
  [self.tbVCComments.refreshControl addTarget:self action:@selector(onCommentsRefreshed) forControlEvents:UIControlEventValueChanged];
  [self.scrollView addSubview:self.tbVCComments.tableView];
  UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTableViewTapped:)];
  [self.tbVCComments.tableView addGestureRecognizer:gesture];
  
  self.commentInputView = [[SWCommentInputView alloc] initWithFrame:CGRectMake(0, self.scrollView.height-48-iphoneXBottomAreaHeight, UIScreenWidth, 48+iphoneXBottomAreaHeight)];
  self.commentInputView.txtField.delegate = self;
  [self.commentInputView.btnPhoto addTarget:self action:@selector(onSendPhotoClicked) forControlEvents:UIControlEventTouchUpInside];
  [self.scrollView addSubview:self.commentInputView];
  
  self.tbVCLikes = [[UITableViewController alloc] initWithStyle:UITableViewStylePlain];
  self.tbVCLikes.view.frame = self.view.bounds;
  self.tbVCLikes.view.left  = UIScreenWidth;
  self.tbVCLikes.tableView.dataSource = self;
  self.tbVCLikes.tableView.delegate   = self;
  self.tbVCLikes.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
  self.tbVCLikes.tableView.separatorColor = [UIColor colorWithRGBHex:0xe8e9e8];
  self.tbVCLikes.tableView.backgroundColor= [UIColor colorWithRGBHex:0xffffff];
  self.tbVCLikes.tableView.tableFooterView = [UIView new];
  self.tbVCLikes.tableView.contentInset   = UIEdgeInsetsMake(0, 0, 48+iOSNavHeight+self.titleView.height+iphoneXBottomAreaHeight, 0);
  self.tbVCLikes.tableView.separatorInset = UIEdgeInsetsZero;
  self.tbVCLikes.refreshControl = [[UIRefreshControl alloc] init];
  [self.tbVCLikes.refreshControl addTarget:self action:@selector(onLikesRefreshed) forControlEvents:UIControlEventValueChanged];
  [self.scrollView addSubview:self.tbVCLikes.tableView];
  
  self.scrollView.contentOffset = CGPointMake(UIScreenWidth*self.defaultIndex, 0);
}

- (void)onCommentsRefreshed{
  [self.model getComments];
}

- (void)onLikesRefreshed{
  [self.model getLikes];
}

- (void)dismissKeyboard{
  if ([self.commentInputView.txtField isFirstResponder]) {
    [self.commentInputView.txtField resignFirstResponder];
    
    if(self.commentInputView.txtField.text.length==0){
      self.commentInputView.replyUser = nil;
    }
  }
}

- (void)onTableViewTapped:(UITapGestureRecognizer *)tap{
  CGPoint location = [tap locationInView:self.tbVCComments.tableView];
  NSIndexPath *path = [self.tbVCComments.tableView indexPathForRowAtPoint:location];
  
  if(path){
    [self tableView:self.tbVCComments.tableView didSelectRowAtIndexPath:path];
  }else{
    [self dismissKeyboard];
  }
}

#pragma mark Title Delegate
- (void)feedInteractNavViewDidSelectIndex:(NSInteger)index{
  [self.scrollView setContentOffset:CGPointMake(index*UIScreenWidth, 0) animated:YES];
  [self dismissKeyboard];
}

#pragma mark Table View Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
  [self dismissKeyboard];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  if ([tableView isEqual:self.tbVCComments.tableView]) {
    return self.model.feedItem.comments.count;
  }else{
    return self.model.feedItem.likes.count;
  }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  if ([tableView isEqual:self.tbVCComments.tableView]) {
    return [SWFeedInteractCommentCell heightOfComment:[self.model.feedItem.comments safeObjectAtIndex:indexPath.row]];
  }else{
    return [SWFeedInteractLikeCell heightOfLike:[self.model.feedItem.likes safeObjectAtIndex:indexPath.row]];
  }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  if ([tableView isEqual:self.tbVCComments.tableView]) {
    static NSString *idenComment = @"comment";
    SWFeedInteractCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:idenComment];
    if (!cell) {
      cell = [[SWFeedInteractCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idenComment];
    }
    [cell refreshComment:[self.model.feedItem.comments safeObjectAtIndex:indexPath.row]];
    cell.delegate = self;
    return cell;
  }else{
    static NSString *idenLike = @"idenLike";
    SWFeedInteractLikeCell *cell = [tableView dequeueReusableCellWithIdentifier:idenLike];
    if (!cell) {
      cell = [[SWFeedInteractLikeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idenLike];
    }
    [cell refreshLike:[self.model.feedItem.likes safeObjectAtIndex:indexPath.row]];
    cell.delegate = self;
    return cell;
  }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  
  if ([tableView isEqual:self.tbVCLikes.tableView]) {
    [self enterUserVC:[(SWFeedLikeItem *)[self.model.feedItem.likes safeObjectAtIndex:indexPath.row] user]];
  }
}

- (void)enterUserVC:(SWFeedUserItem *)userItem{
  [SWFeedUserItem pushUserVC:userItem nav:self.navigationController];
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
  if ([tableView isEqual:self.tbVCComments.tableView]) {
    return NO;
  }
  return YES;
}

#pragma mark TextField Delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
  if ([string isEqualToString:@"\n"]) {
    if ([[textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]>0) {
      [self dismissKeyboard];
      
      [self.model sendComment:textField.text replyUser:self.commentInputView.replyUser];
      self.commentInputView.replyUser = nil;
      textField.text = @"";
      return NO;
    }
  }
  return YES;
}

- (void)onSendPhotoClicked{
  [self dismissKeyboard];
  UIImagePickerController *picker = [[UIImagePickerController alloc] init];
  picker.navigationBar.tintColor = [UIColor colorWithRGBHex:0x191d28];
  picker.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor colorWithRGBHex:0x191d28]};
  [picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
  [picker setDelegate:self];
  [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark Photo Delegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
  __weak typeof(self)wSelf = self;
  [self dismissViewControllerAnimated:YES completion:^{
    [wSelf.model sendImage:[info objectForKey:UIImagePickerControllerOriginalImage] replyUser:wSelf.commentInputView.replyUser];
  }];
}
#pragma mark Comment Cell Delegate
- (void)feedInteractCommentCellDidPressImage:(NSString *)url rect:(CGRect)rect{
  ALPhotoListFullView *view = [[ALPhotoListFullView alloc] initWithFrames:@[[NSValue valueWithCGRect:rect]]
                                                                photoList:@[url]
                                                                    index:0];
  [[UIApplication sharedApplication].delegate.window addSubview:view];
}

- (void)feedInteractCommentCellDidPressUrl:(NSURL *)url{
  SWAgreementVC *vc = [[SWAgreementVC alloc] init];
  vc.url = url.absoluteString;
  vc.hidesBottomBarWhenPushed = YES;
  [self.navigationController pushViewController:vc animated:YES];
}

- (void)feedInteractCommentCellDidNeedEnterUser:(SWFeedUserItem *)userItem{
  [self enterUserVC:userItem];
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
      [self.model.feedItem.user.uId isEqual:@0]||[[self.model.feedItem.user.uId stringValue] isEqualToString:[[NSUserDefaults standardUserDefaults] safeStringObjectForKey:@"userId"]]) {
    __weak typeof(self)wSelf = self;
    [[[SWAlertView alloc] initWithTitle:@"刪除評論"
                             cancelText:SWStringCancel
                            cancelBlock:^{
                              
                            } okText:SWStringOkay
                                okBlock:^{
                                  [wSelf.model deleteComment:commentItem];
                                }] show];
  }
}

- (BOOL)isMyPic{
  return [self.model.feedItem.user.uId isEqual:@0]||[[self.model.feedItem.user.uId stringValue] isEqualToString:[[NSUserDefaults standardUserDefaults] safeStringObjectForKey:@"userId"]];
}

#pragma mark Like Cell Delegate
- (void)feedInteractLikeCellDidPressFollow:(SWFeedLikeItem *)likeItem{
  [self.model processFollow:likeItem];
}

#pragma mark Model Delegate

- (void)feedInteractModelDidLoadComments:(SWFeedInteractModel *)model{
  self.automaticallyAdjustsScrollViewInsets = NO;
  [self.tbVCComments.refreshControl endRefreshing];
  [self.tbVCComments.tableView reloadData];
  
  if (model.feedItem.comments.count>0) {
    self.titleView.btnLeft.lblCustom.text = [@" " stringByAppendingString:[[NSNumber numberWithInteger:model.feedItem.comments.count] stringValue]];
  }
  if ([self.tbVCComments.tableView numberOfRowsInSection:0]) {
    [self.tbVCComments.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                                       atScrollPosition:UITableViewScrollPositionBottom
                                               animated:NO];
  }
  [self.titleView.btnLeft.lblCustom sizeToFit];
  self.titleView.btnLeft.lblCustom.top = 0; self.titleView.btnLeft.lblCustom.height = self.titleView.btnLeft.height;
//  self.titleView.btnLeft.lblCustom.textColor = [UIColor colorWithRGBHex:0x00f8ff];
}

- (void)feedInteractModelDidLoadLikes:(SWFeedInteractModel *)model{
  [self.tbVCLikes.refreshControl endRefreshing];
  [self.tbVCLikes.tableView reloadData];
  
  if (model.feedItem.likes.count>0) {
    self.titleView.btnRight.lblCustom.text = [@" " stringByAppendingString:[[NSNumber numberWithInteger:model.feedItem.likes.count] stringValue]];
  }
  [self.titleView.btnRight.lblCustom sizeToFit];
  self.titleView.btnRight.lblCustom.top = 0; self.titleView.btnRight.lblCustom.height = self.titleView.btnRight.height;
//  self.titleView.btnRight.lblCustom.textColor = [UIColor colorWithRGBHex:0x00f8ff];
}

- (void)feedInteractModelDidDeleteComments:(SWFeedInteractModel *)model{
  [self.tbVCComments.tableView reloadData];
  if (model.feedItem.comments.count>0) {
    self.titleView.btnLeft.lblCustom.text = [@" " stringByAppendingString:[[NSNumber numberWithInteger:model.feedItem.comments.count] stringValue]];
  }else{
    self.titleView.btnLeft.lblCustom.text =  @"";
  }
  [self.titleView.btnLeft.lblCustom sizeToFit];
  self.titleView.btnLeft.lblCustom.top = 0; self.titleView.btnLeft.lblCustom.height = self.titleView.btnLeft.height;
//  self.titleView.btnLeft.lblCustom.textColor = [UIColor colorWithRGBHex:0x00f8ff];
}

- (void)feedInteractModelDidSendComments:(SWFeedInteractModel *)model{
  [self.model getComments];
}

- (void)feedInteractModelDidSendImages:(SWFeedInteractModel *)model{
  [self feedInteractModelDidLoadComments:model];
}
@end
