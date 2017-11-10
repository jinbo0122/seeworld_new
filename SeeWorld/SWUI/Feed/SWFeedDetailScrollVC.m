//
//  SWFeedDetailScrollVC.m
//  SeeWorld
//
//  Created by Albert Lee on 9/3/15.
//  Copyright (c) 2015 SeeWorld. All rights reserved.
//

#import "SWFeedDetailScrollVC.h"
#import "SWFeedCollectionView.h"
#import "SWFeedInteractVC.h"
#import "SWTagFeedsVC.h"
#import "SWHomeFeedShareView.h"
#import "SWHomeFeedReportView.h"
#import "SWFeedTagButton.h"
#import "SWAgreementVC.h"
@interface SWFeedDetailScrollVC ()<SWFeedCollectionViewDelegate,SWFeedDetailViewDelegate,
SWFeedInteractVCDelegate,UIDocumentInteractionControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property(nonatomic, strong)SWFeedCollectionView *collectionView;
@property(nonatomic, strong)UIDocumentInteractionController *documentController;
@property(strong, nonatomic)UIButton *rightButton;
@end

@implementation SWFeedDetailScrollVC
- (void)viewDidDisappear:(BOOL)animated{
  [super viewDidDisappear:animated];
  if ([self isMovingFromParentViewController]) {
    self.collectionView.delegate = nil;
    self.collectionView.dataSourceDelegate = nil;
    self.collectionView.dataSource = nil;
    [self.navigationController.navigationBar setBarTintColor:[UIColor redColor]];
  }
}

- (void)viewWillDisappear:(BOOL)animated{
  [super viewWillDisappear:animated];
  BOOL isMenuVisible = [[UIMenuController sharedMenuController] isMenuVisible];
  if (isMenuVisible) {
    [[UIMenuController sharedMenuController] setMenuVisible:NO animated:NO];
  }
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  NSString *userId = [[NSUserDefaults standardUserDefaults] safeStringObjectForKey:@"userId"];
  if ([_model.userId isEqualToString:userId] || [userId isEqualToString:@"self"]||
      [_model.userId isEqualToString:@"self"]){
    UIBarButtonItem *barbtn = [[UIBarButtonItem alloc] initWithTitle:@"刪除"
                                                               style:UIBarButtonItemStylePlain
                                                              target:self
                                                              action:@selector(onDelButtonClicked:)];
    [barbtn setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRGBHex:0x191d28],
                                     NSFontAttributeName:[UIFont systemFontOfSize:14]}
                          forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = barbtn;
  }
  
  
  self.view.backgroundColor = [UIColor colorWithRGBHex:0xffffff];
  self.navigationItem.titleView = [[ALTitleLabel alloc] initWithTitle:@"照片"
                                                                color:[UIColor colorWithRGBHex:0x191d28]
                                                             fontSize:18];
  
  UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
  layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 10);
  [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
  
  self.collectionView = [[SWFeedCollectionView alloc] initWithFrame:self.view.bounds
                                               collectionViewLayout:layout];
  self.collectionView.dataSourceDelegate = self;
  
  self.collectionView.top = -15;
  self.collectionView.height+=15;
  [self.view addSubview:self.collectionView];
  
  [self.collectionView scrollTo:self.currentIndex animated:YES];
  
  __weak typeof(self)wSelf = self;
  [[NSNotificationCenter defaultCenter] addObserverForName:@"reloadCollectionLike"
                                                    object:nil
                                                     queue:[NSOperationQueue mainQueue]
                                                usingBlock:^(NSNotification *note) {
                                                  [wSelf.collectionView reloadDataAtIndex:wSelf.currentIndex];
                                                }];
}

- (void)onDelButtonClicked:(UIButton *)sender
{
  __weak typeof(self)wSelf = self;
  [[[SWAlertView alloc] initWithTitle:@"確認刪除該動態？"
                           cancelText:SWStringCancel
                          cancelBlock:^{
                            
                          } okText:SWStringOkay
                              okBlock:^{
                                SWFeedDeleteAPI *api = [[SWFeedDeleteAPI alloc] init];
                                api.fId = [[(SWFeedItem *)[wSelf.model.feeds safeObjectAtIndex:wSelf.currentIndex] feed] fId];
                                [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
                                  [wSelf.model.feeds safeRemoveObjectAtIndex:wSelf.currentIndex];
                                  [wSelf.collectionView reloadData];
                                  if (wSelf.model.feeds.count==0) {
                                    [wSelf.navigationController popViewControllerAnimated:YES];
                                  }
                                } failure:^(YTKBaseRequest *request) {
                                  
                                }];
                              }] show];
}

- (void)dealloc{
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

#pragma mark - PDContentCollectionViewDelegate
- (NSInteger)numberOfCellsInHorizontalScrollView:(SWFeedCollectionView *)hScrollView{
  return [self.model.feeds count];
}

- (void)horizontalScrollViewCell:(SWFeedCollectionCell *)cell cellAtIndexPath:(NSIndexPath *)indexPath{
  SWFeedItem *feedItem = [self.model.feeds safeObjectAtIndex:indexPath.row];
  cell.delegate = self;
  [cell refreshFeedView:feedItem row:indexPath.row];
}


- (void)horizontalScrollView:(SWFeedCollectionView *)hScrollView didScrollToIndex:(NSInteger)index{
  self.currentIndex = index;
}

#pragma mark Cell Delegate
- (void)feedDetailViewDidPressUser:(SWFeedUserItem *)userItem{
  [SWFeedUserItem pushUserVC:userItem nav:self.navigationController];
}

- (void)feedDetailViewDidPressLike:(SWFeedItem *)feedItem row:(NSInteger)row{
  [self.model likeClickedByRow:row];
}

- (void)feedDetailViewDidPressReply:(SWFeedItem *)feedItem row:(NSInteger)row{
  SWFeedInteractVC *vc = [[SWFeedInteractVC alloc] init];
  vc.delegate = self;
  vc.defaultIndex = SWFeedInteractIndexComments;
  vc.feedRow  = row;
  vc.isModal  = YES;
  vc.model.feedItem  = feedItem;
  UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
  [self presentViewController:nav animated:YES completion:nil];
}

- (void)feedDetailViewDidPressUrl:(NSURL *)url row:(NSInteger)row{
  SWAgreementVC *vc = [[SWAgreementVC alloc] init];
  vc.url = url.absoluteString;
  vc.hidesBottomBarWhenPushed = YES;
  [self.navigationController pushViewController:vc animated:YES];
}

- (void)feedDetailViewDidPressShare:(SWFeedItem *)feedItem row:(NSInteger)row{
  SWHomeFeedShareView *shareView = [[SWHomeFeedShareView alloc] initWithFrame:[UIScreen mainScreen].bounds];
  [shareView show];
  
  SWFeedCollectionCell *cell = (SWFeedCollectionCell*)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
  
  for (SWFeedTagButton *button in [cell.feedImageView subviews]) {
    if ([button isKindOfClass:[SWFeedTagButton class]]) {
      button.tagHoverImageView.hidden = YES;
      button.tagHoverImageView2.hidden = YES;
    }
  }
  
  UIImage *shareImage = [UIImage imageWithView:cell.feedImageView];
  shareView.shareImage = shareImage;
  
  for (SWFeedTagButton *button in [cell.feedImageView subviews]) {
    if ([button isKindOfClass:[SWFeedTagButton class]]) {
      button.tagHoverImageView.hidden = NO;
      button.tagHoverImageView2.hidden = NO;
    }
  }
  
  __weak typeof(feedItem)wFeed = feedItem;
  shareView.reportBlock = ^{
    SWHomeFeedReportView *reportView = [[SWHomeFeedReportView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    reportView.feedItem = wFeed;
    [reportView show];
    
  };
  
  __weak typeof(self)wSelf = self;
  __weak typeof(shareView)wShareView = shareView;
  shareView.instaBlock = ^(UIImage *image){
    NSURL *instagramURL = [NSURL URLWithString:@"instagram://app"];
    if([[UIApplication sharedApplication] canOpenURL:instagramURL]) //check for App is install or not
    {
      NSData *imageData = UIImagePNGRepresentation(image); //convert image into .png format.
      NSFileManager *fileManager = [NSFileManager defaultManager];//create instance of NSFileManager
      NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //create an array and store result of our search for the documents directory in it
      NSString *documentsDirectory = [paths objectAtIndex:0]; //create NSString object, that holds our exact path to the documents directory
      NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"insta.igo"]]; //add our image to the path
      [fileManager createFileAtPath:fullPath contents:imageData attributes:nil]; //finally save the path (image)
      CGRect rect = CGRectMake(0 ,0 , 0, 0);
      UIGraphicsBeginImageContextWithOptions(wSelf.view.bounds.size, wSelf.view.opaque, 0.0);
      [wSelf.view.layer renderInContext:UIGraphicsGetCurrentContext()];
      UIGraphicsEndImageContext();
      NSString *fileNameToSave = [NSString stringWithFormat:@"Documents/insta.igo"];
      NSString  *jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:fileNameToSave];
      NSString *newJpgPath = [NSString stringWithFormat:@"file://%@",jpgPath];
      NSURL *igImageHookFile = [[NSURL alloc]initFileURLWithPath:newJpgPath];
      wSelf.documentController.UTI = @"com.instagram.exclusivegram";
      wSelf.documentController = [self setupControllerWithURL:igImageHookFile usingDelegate:wSelf];
      wSelf.documentController=[UIDocumentInteractionController interactionControllerWithURL:igImageHookFile];
      NSString *caption = @"#Your Text"; //settext as Default Caption
      wSelf.documentController.annotation=[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@",caption],@"InstagramCaption", nil];
      [wSelf.documentController presentOpenInMenuFromRect:rect inView: wSelf.view animated:YES];
      [wShareView dismiss];
    }
    else{
      [MBProgressHUD showTip:@"未安装Instagram"];
    }
  };
  
  shareView.fbBlock = ^(UIImage *image){
    FBSDKSharePhoto *photo = [[FBSDKSharePhoto alloc] init];
    photo.image = image;
    photo.userGenerated = YES;
    FBSDKSharePhotoContent *content = [[FBSDKSharePhotoContent alloc] init];
    content.photos = @[photo];
    [FBSDKShareDialog showFromViewController:wSelf
                                 withContent:content
                                    delegate:nil];
    
  };
}

- (UIDocumentInteractionController *) setupControllerWithURL: (NSURL*) fileURL usingDelegate: (id <UIDocumentInteractionControllerDelegate>) interactionDelegate {
  NSLog(@"file url %@",fileURL);
  UIDocumentInteractionController *interactionController = [UIDocumentInteractionController interactionControllerWithURL: fileURL];
  interactionController.delegate = interactionDelegate;
  
  return interactionController;
}
- (void)feedDetailViewDidPressLikeList:(SWFeedItem *)feedItem row:(NSInteger)row{
  SWFeedInteractVC *vc = [[SWFeedInteractVC alloc] init];
  vc.delegate = self;
  vc.defaultIndex = SWFeedInteractIndexLikes;
  vc.feedRow  = row;
  vc.isModal  = YES;
  vc.model.feedItem  = feedItem;
  UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
  [self presentViewController:nav animated:YES completion:nil];
}

- (void)feedDetailViewDidPressTag:(SWFeedTagItem *)tagItem{
  SWTagFeedsVC *vc = [[SWTagFeedsVC alloc] init];
  vc.model.tagItem = tagItem;
  vc.hidesBottomBarWhenPushed = YES;
  [self.navigationController pushViewController:vc animated:YES];
}

- (void)feedDetailViewDidPressImage:(SWFeedItem *)feedItem rect:(CGRect)rect{
  ALPhotoListFullView *view = [[ALPhotoListFullView alloc] initWithFrames:@[[NSValue valueWithCGRect:rect]]
                                                                photoList:@[[feedItem.feed.picUrl stringByAppendingString:FEED_SMALL]]
                                                                    index:0];
  [view setFeedItem:feedItem];
  [[UIApplication sharedApplication].delegate.window addSubview:view];
}

- (void)feedDetailViewDidNeedReload:(NSNumber *)imageHeight row:(NSInteger)row{
  SWFeedItem *feed = [_model.feeds safeObjectAtIndex:row];
  if ([imageHeight isEqualToNumber:feed.feed.imageHeight]) {
    return;
  }
  feed.feed.imageHeight = imageHeight;
  __weak typeof(self)wSelf = self;
  dispatch_async(dispatch_get_main_queue(), ^{
    [wSelf.collectionView reloadDataAtIndex:row];
  });
}

- (void)feedDetailViewDidNeedOpenImagePicker:(SWFeedCollectionCell *)cell{
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
    SWFeedCollectionCell *cell = (SWFeedCollectionCell*)[wSelf.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:wSelf.currentIndex inSection:0]];
    [cell.interactModel sendImage:[info objectForKey:UIImagePickerControllerOriginalImage] replyUser:cell.commentInputView.replyUser];
  }];
}

#pragma mark Feed Interact VC Delegate
- (void)feedInteractVCDidDismiss:(SWFeedInteractVC *)vc row:(NSInteger)row likes:(NSMutableArray *)likes comments:(NSMutableArray *)comments{
  __weak typeof(self)wSelf = self;
  [wSelf dismissViewControllerAnimated:YES completion:^{
    SWFeedItem *feedItem = [wSelf.model.feeds safeObjectAtIndex:row];
    feedItem.likeCount = [NSNumber numberWithInteger:likes.count];
    feedItem.commentCount = [NSNumber numberWithInteger:comments.count];
    feedItem.likes = likes;
    feedItem.comments = comments;
    
    [wSelf.collectionView reloadDataAtIndex:wSelf.currentIndex];
  }];
}
@end
