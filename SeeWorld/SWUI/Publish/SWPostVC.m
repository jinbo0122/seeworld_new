//
//  SWPostVC.m
//  SeeWorld
//
//  Created by Albert Lee on 17/11/2017.
//  Copyright © 2017 SeeWorld. All rights reserved.
//

#import "SWPostVC.h"
#import "SWPostPhotoView.h"
#import "SWSelectLocationVC.h"
#import "SWPostCheckLinkAPI.h"
#import "UzysAssetsPickerController.h"
#import "SWPostLinkView.h"
#import "SWPostVideoView.h"
#import "SWPostPreviewVC.h"
#import <AVKit/AVKit.h>
#import "AVAsset+VideoOrientation.h"
#import "SWPostModel.h"
@interface SWPostVC ()<SWSelectLocationVCDelegate,UITextViewDelegate,UzysAssetsPickerControllerDelegate,
SWPostPhotoViewDelagate,SWPostPreviewVCDelegate,PDVideoWhisperRecordVCDelegate,SWPostModelDelegate>
@property (nonatomic, strong)UITextView  *txtContent;
@property (nonatomic, strong)UILabel     *lblLength;
@property (nonatomic, strong)UIView      *toolView;
@property (nonatomic, strong)SWPostPhotoView *photoView;
@property (nonatomic, strong)SWPostLinkView  *linkView;
@property (nonatomic, strong)SWPostVideoView *videoView;
@property (nonatomic, assign)BOOL         isPickerChooseForChangeSinglePic;
@property (nonatomic, assign)NSInteger    pickerChooseForChangeSingleIndex;

@property (nonatomic, assign)BOOL         isPostingLink;
@property (nonatomic, strong)NSString     *postingLink;
@property (nonatomic, strong)NSString     *postingLinkTitle;
@property (nonatomic, strong)NSString     *postingLinkImageUrl;
@property (nonatomic, assign)BOOL         enableRightBarItem;


@end

@implementation SWPostVC{
  UIImageView *_avatarView;
  UIView      *_lbsView;
  UIImageView *_iconLBS;
  UILabel     *_lblLBS;
  
  UILabel     *_lblPlaceHolder;
  
  UIButton    *_btnCamera;
  UIButton    *_btnAlbum;
  UIButton    *_btnLBS;
  
  SWPostModel *_model;
}

- (id)init{
  if (self = [super init]) {
    _model = [[SWPostModel alloc] init];
    _model.delegate = self;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.navigationItem.leftBarButtonItem = [UIBarButtonItem loadLeftBarButtonItemWithTitle:SWStringCancel
                                                                                    color:[UIColor colorWithRGBHex:0x55acef]
                                                                                     font:[UIFont systemFontOfSize:16]
                                                                                   target:self
                                                                                   action:@selector(onCancel)];
  self.view.backgroundColor = [UIColor whiteColor];
  self.navigationItem.titleView = [[ALTitleLabel alloc] initWithTitle:@"發狀態" color:[UIColor colorWithRGBHex:NAV_BAR_COLOR_HEX]];
  [self rightBar];
  _avatarView = [[UIImageView alloc] initWithFrame:CGRectMake(10, iOSNavHeight+10, 45, 45)];
  _avatarView.layer.masksToBounds = YES;
  _avatarView.layer.cornerRadius = _avatarView.height/2.0;
  [_avatarView sd_setImageWithURL:[NSURL URLWithString:[[SWConfigManager sharedInstance].user.picUrl stringByAppendingString:@"-avatar210"]]];
  [self.view addSubview:_avatarView];
  
  _lbsView = [[UIView alloc] initWithFrame:CGRectMake(_avatarView.right+24, _avatarView.top, self.view.width-10-24-_avatarView.right, _avatarView.height)];
  _iconLBS = [[UIImageView alloc] initWithFrame:CGRectMake(0, (_lbsView.height-24)/2.0, 26, 24)];
  _iconLBS.image = [UIImage imageNamed:@"send_location"];
  [_lbsView addSubview:_iconLBS];
  
  _lblLBS = [UILabel initWithFrame:CGRectZero
                           bgColor:[UIColor clearColor]
                         textColor:[UIColor colorWithRGBHex:0x191d28]
                              text:@"" textAlignment:NSTextAlignmentLeft
                              font:[UIFont systemFontOfSize:17]];
  [_lbsView addSubview:_lblLBS];
  [self.view addSubview:_lbsView];
  
  _lbsView.hidden = YES;
  
  
  _txtContent = [[UITextView alloc] initWithFrame:CGRectMake(15, _avatarView.bottom+15, UIScreenWidth-30, 50)];
  [self.view addSubview:_txtContent];
  _txtContent.textColor = [UIColor colorWithRGBHex:0x191d28];
  _txtContent.font = [UIFont systemFontOfSize:18];
  _txtContent.tintColor = [UIColor colorWithRGBHex:0x191d28];
  _txtContent.delegate = self;
  _txtContent.backgroundColor = [UIColor colorWithRGBHex:0xffffff];
  [_txtContent becomeFirstResponder];
  
  _lblPlaceHolder = [UILabel initWithFrame:CGRectMake(25, _txtContent.top + 7, 0, 0)
                                   bgColor:[UIColor clearColor]
                                 textColor:[UIColor colorWithRGBHex:0x667887 alpha:0.7]
                                      text:@"這一刻的想法..."
                             textAlignment:NSTextAlignmentLeft
                                      font:[UIFont systemFontOfSize:18]];
  [_lblPlaceHolder sizeToFit];
  [self.view addSubview:_lblPlaceHolder];
  
  _lblLength = [UILabel initWithFrame:CGRectMake(0, _txtContent.bottom+5, _txtContent.width, 19)
                              bgColor:[UIColor clearColor]
                            textColor:[UIColor colorWithRGBHex:0x8b9cad]
                                 text:@"0/2000"
                        textAlignment:NSTextAlignmentRight font:[UIFont systemFontOfSize:14]];
  [self.view addSubview:_lblLength];
  
  [[NSNotificationCenter defaultCenter]
   addObserver:self
   selector:@selector(keyboardWillShow:)
   name:UIKeyboardWillShowNotification
   object:self.view.window];
  
  [[NSNotificationCenter defaultCenter]
   addObserver:self
   selector:@selector(keyboardWillHide:)
   name:UIKeyboardWillHideNotification
   object:self.view.window];
  
  UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onNothing)];
  [self.view addGestureRecognizer:tapGesture];
  
  
  _toolView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.height-64-iphoneXBottomAreaHeight, self.view.width, 64+iphoneXBottomAreaHeight)];
  _toolView.backgroundColor = [UIColor whiteColor];
  [self.view addSubview:_toolView];
  [_toolView addSubview:[ALLineView lineWithFrame:CGRectMake(0, 0, _toolView.width, 0.5) colorHex:0xe7e6e6]];
  
  _btnCamera = [[UIButton alloc] initWithFrame:CGRectMake(3 , 0, 48, _toolView.height-iphoneXBottomAreaHeight)];
  [_btnCamera setImage:[UIImage imageNamed:@"send_camera_export"] forState:UIControlStateNormal];
  [_toolView addSubview:_btnCamera];
  [_btnCamera addTarget:self action:@selector(onCameraClicked) forControlEvents:UIControlEventTouchUpInside];

  _btnAlbum = [[UIButton alloc] initWithFrame:CGRectMake(_btnCamera.right, 0, 48, _btnCamera.height)];
  [_btnAlbum addTarget:self action:@selector(onAlbumClicked) forControlEvents:UIControlEventTouchUpInside];
  [_toolView addSubview:_btnAlbum];
  [_btnAlbum setImage:[UIImage imageNamed:@"send_image_export"] forState:UIControlStateNormal];
  
  _btnLBS = [[UIButton alloc] initWithFrame:CGRectMake(_btnAlbum.right, 0, 48, _btnCamera.height)];
  [_btnLBS setImage:[UIImage imageNamed:@"send_location_export"] forState:UIControlStateNormal];
  [_toolView addSubview:_btnLBS];
  
  [_btnLBS addTarget:self action:@selector(onLBSClicked) forControlEvents:UIControlEventTouchUpInside];
  
  if (_images.count) {
    _btnAlbum.tag = 1;
  }else{
    _images = [NSMutableArray array];
    _tags = [NSMutableArray array];
  }
  [self initImages];
  
  _videoView = [[SWPostVideoView alloc] initWithFrame:CGRectMake(12, _photoView.top+5, self.view.width-24, 169)];
  [self.view addSubview:_videoView];
  [_videoView addTarget:self action:@selector(onVideoClicked) forControlEvents:UIControlEventTouchUpInside];
  [self refreshVideo];
  
  if (_enableLBS) {
    [_btnLBS sendActionsForControlEvents:UIControlEventTouchUpInside];
  }
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark Custom
- (void)rightBar{
  if (_enableRightBarItem) {
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem loadBarButtonItemWithTitle:@"發佈"
                                                                                   color:[UIColor colorWithRGBHex:0x69b4f4]
                                                                                    font:[UIFont systemFontOfSize:16]
                                                                                  target:self
                                                                                  action:@selector(onPost)];
  }else{
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem loadBarButtonItemWithTitle:@"發佈"
                                                                                   color:[UIColor colorWithRGBHex:0xc4c5c7]
                                                                                    font:[UIFont systemFontOfSize:16]
                                                                                  target:self
                                                                                  action:@selector(onNothing)];
  }
}

- (void)onNothing{
  [self.view endEditing:YES];
}

- (void)onPost{
  if (self.txtContent.text.length > 2000){
    [[[SWAlertView alloc] initWithTitle:@"發佈內容最大字數為2000字"
                             cancelText:SWStringOkay
                            cancelBlock:^{
                              
                            } okText:nil
                                okBlock:^{
                                  
                                }] show];
    return;
  }
  self.view.userInteractionEnabled = NO;
  if ([self isPostingLink]) {
    [_model postLink:_postingLink content:_txtContent.text];
  }else if ([self isPostingVideo]){
    if (_videoAsset) {
      [_model postVideoWithAsset:_videoAsset thumbImage:_videoThumbImage content:_txtContent.text];
    }else if (_videoURLAsset){
      NSTimeInterval duration = CMTimeGetSeconds(_videoURLAsset.duration);
      if (duration > 120 && ![[SWConfigManager sharedInstance].user.admin boolValue]) {
        [PDProgressHUD showTip:@"視頻不能超過兩分鐘"];
        return;
      }
      [_model postVideo:_videoURLAsset.URL thumbImage:_videoThumbImage content:_txtContent.text];
    }
  }else if (_images.count){
    [_model postPhoto:_images tags:_tags content:_txtContent.text];
  }else if (_txtContent.text.length){
    [_model postContent:_txtContent.text];
  }
}

- (void)onCancel{
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onLBSClicked{
  SWSelectLocationVC *vc = [[SWSelectLocationVC alloc] init];
  vc.delegate = self;
  UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
  [self presentViewController:nav animated:YES completion:nil];
}

- (void)initImages{
  if (!_photoView) {
    _photoView = [[SWPostPhotoView alloc] initWithFrame:CGRectMake(0, _txtContent.bottom+20, self.view.width, 260)];
    _photoView.delegate = self;
    [self.view addSubview:_photoView];
  }
  [self refreshImages];
  [self.view bringSubviewToFront:_toolView];
}

- (void)refreshImages{
  if (_images.count == 0) {
    if (_txtContent.text.length) {
      _enableRightBarItem = YES;
    }else{
      _enableRightBarItem = NO;
    }
  }else{
    _enableRightBarItem = YES;
    _videoAsset = nil;
    _videoURLAsset = nil;
    _videoURLAsset = nil;
  }
  
  [self rightBar];
  
  [_photoView refreshWithPhotos:_images];
  _btnAlbum.tag = _images.count>0?1:0;
}

- (BOOL)isPostingVideo{
  return ((_videoThumbImage && _videoAsset) || (_videoThumbImage && _videoURLAsset));
}

- (void)onCameraClicked{
  __weak typeof(self)wSelf = self;
  if ([SWUtility checkCameraWithBlock:^{[wSelf onCameraClicked];}]) {
    [SWUtility checkMicWithBlock:^{
      PDVideoWhisperRecordVC *vc = [[PDVideoWhisperRecordVC alloc] init];
      vc.delegate = wSelf;
      vc.startIndex = 1000+wSelf.images.count;
      vc.fromPostVC = YES;
      vc.isPostingVideo = [wSelf isPostingVideo];
      UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
      [wSelf presentViewController:nav animated:YES completion:nil];
    }];
  }
}

- (void)onAlbumClicked{
  if (_images.count == 9) {
    [PDProgressHUD showTip:@"至多上傳9張圖片"];
    return;
  }else if (_isPostingLink){
    [PDProgressHUD showTip:@"正在發佈超鏈接"];
    return;
  }
  
  UzysAssetsPickerController *photoPicker = [[UzysAssetsPickerController alloc] init];
  photoPicker.delegate = self;
  if (![self isPostingVideo]) {
    photoPicker.maximumNumberOfSelectionPhoto = 9-_images.count;
  }
  if (_images.count == 0) {
    photoPicker.maximumNumberOfSelectionVideo = 1;
  }
  _isPickerChooseForChangeSinglePic = NO;
  UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:photoPicker];
  [nav.navigationBar setBarTintColor:[UIColor blackColor]];
  [nav setNavigationBarHidden:YES];

  [self presentViewController:nav animated:YES completion:^{
  }];
}

- (void)onVideoClicked{
  AVPlayerViewController *vc = [[AVPlayerViewController alloc] init];
  AVURLAsset *asset;
  if (_videoURLAsset) {
    asset = _videoURLAsset;
  }else if (_videoAsset){
    asset = [AVURLAsset assetWithURL:[[_videoAsset defaultRepresentation] url]];
  }
  AVPlayerItem *item = [AVPlayerItem playerItemWithAsset: asset];
  AVPlayer * player = [[AVPlayer alloc] initWithPlayerItem: item];
  vc.player = player;
  [vc.view setFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.width)];
  vc.showsPlaybackControls = YES;
  [self presentViewController:vc animated:YES completion:nil];
  [player play];
}

- (void)refreshVideo{
  if ([self isPostingVideo]) {
    _photoView.hidden = YES;
    _videoView.hidden = NO;
    [_videoView refreshWithThumb:_videoThumbImage];
    _enableRightBarItem = YES;
    [self rightBar];
    [_images removeAllObjects];
    [_tags removeAllObjects];
  }else{
    _videoView.hidden = YES;
  }
}

#pragma mark Model
- (void)postModelDidPostFeed:(SWPostModel *)model{
  self.view.userInteractionEnabled = YES;
}

- (void)postModelDidPostFeedFailed:(SWPostModel *)model{
  self.view.userInteractionEnabled = YES;
}

#pragma mark Camera
- (void)videoWhisperRecordVCDidReturnVideoUrl:(NSURL *)videoUrl{
  AVURLAsset *asset = [AVURLAsset assetWithURL:videoUrl];
  CGSize videoSize = [[[asset tracksWithMediaType:AVMediaTypeVideo] safeObjectAtIndex:0] naturalSize];
  LBVideoOrientation orientation = [asset videoOrientation];
  if (orientation == LBVideoOrientationUp ||
      orientation == LBVideoOrientationDown) {
    videoSize = CGSizeMake(videoSize.height, videoSize.width);
  }
  [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
  _videoURLAsset = asset;
  _videoThumbImage = [asset.URL.absoluteString getThumnailImageWithURL:videoSize.width height:videoSize.height];
  [self dismissViewControllerAnimated:YES completion:nil];
  [self refreshVideo];
}

- (void)videoWhisperRecordVCDidReturnImages:(NSArray *)images tags:(NSArray *)tags{
  [self postPreviewVCDidPressFinish:nil images:images tags:tags];
}

#pragma mark Post Photo View
- (void)postPhotoViewDidNeedDelete:(NSInteger)tag{
  [_images removeObjectAtIndex:tag];
  [self refreshImages];
  
  if (_images.count == 0) {
    [self textViewDidChange:_txtContent];
  }
}

- (void)postPhotoViewDidNeedChoose:(NSInteger)tag{
  UzysAssetsPickerController *photoPicker = [[UzysAssetsPickerController alloc] init];
  photoPicker.delegate = self;
  photoPicker.maximumNumberOfSelectionPhoto = tag<0?(9-_images.count):1;
  if (_images.count == 0) {
    photoPicker.maximumNumberOfSelectionVideo = 1;
  }
  
  _isPickerChooseForChangeSinglePic = YES;
  _pickerChooseForChangeSingleIndex = tag;
  UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:photoPicker];
  [nav.navigationBar setBarTintColor:[UIColor blackColor]];
  [nav setNavigationBarHidden:YES];

  [self presentViewController:nav animated:YES completion:^{
  }];
}

#pragma mark Image Picker Delegate
- (void)uzysAssetsPickerController:(UzysAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets preview:(BOOL)preview{
  NSMutableArray *imageArray = [NSMutableArray array];
  __weak typeof(self)wSelf = self;
  [assets enumerateObjectsUsingBlock:^(ALAsset *asset, NSUInteger idx, BOOL *stop) {
    struct CGImage *fullScreenImage = asset.defaultRepresentation.fullScreenImage;
    UIImage *image = [UIImage imageWithCGImage:fullScreenImage];
    BOOL isVideo = NO;
    if ([[asset valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypeVideo]) {
      isVideo = YES;
    }
    
    if (isVideo) {
      [wSelf dismissViewControllerAnimated:NO
                                completion:^{
                                  wSelf.videoAsset = asset;
                                  wSelf.videoThumbImage = image;
                                  [wSelf refreshVideo];
                                }];
    }else{
      if (image && [image isKindOfClass:[UIImage class]]){
        [imageArray addObject:image];
      }
      
      if (idx == assets.count-1) {
        if (preview) {
          SWPostPreviewVC *vc = [[SWPostPreviewVC alloc] init];
          vc.images = [imageArray mutableCopy];
          vc.delegate = self;
          if (wSelf.isPickerChooseForChangeSinglePic&& wSelf.pickerChooseForChangeSingleIndex >=0) {
            vc.startIndex = 1000+wSelf.pickerChooseForChangeSingleIndex;
          }else{
            vc.startIndex = 1000+wSelf.images.count;
          }
          [picker.navigationController setNavigationBarHidden:NO];
          [picker.navigationController pushViewController:vc animated:YES];
        }else{
          [wSelf dismissViewControllerAnimated:NO
                                    completion:^{
                                      if (wSelf.isPickerChooseForChangeSinglePic&& wSelf.pickerChooseForChangeSingleIndex >=0) {
                                        [wSelf.images replaceObjectAtIndex:wSelf.pickerChooseForChangeSingleIndex withObject:[imageArray safeObjectAtIndex:0]];
                                        for (NSInteger i=0; i<wSelf.tags.count; i++) {
                                          NSArray *tagArray = [wSelf.tags safeArrayObjectAtIndex:i];
                                          if (tagArray.count>0 && [[tagArray[0] safeNumberObjectForKey:@"imageId"] integerValue] == wSelf.pickerChooseForChangeSingleIndex) {
                                            [wSelf.tags removeObjectAtIndex:i];
                                            break;
                                          }
                                        }
                                        [wSelf refreshImages];
                                      }else{
                                        [wSelf.images addObjectsFromArray:imageArray];
                                        [wSelf initImages];
                                      }
                                    }];
          
        }
      }
    }
  }];
}

- (void)postPreviewVCDidPressFinish:(SWPostPreviewVC *)vc images:(NSArray *)images tags:(NSArray *)tags{
  __weak typeof(self)wSelf = self;
  [self dismissViewControllerAnimated:NO
                            completion:^{
                              if (wSelf.isPickerChooseForChangeSinglePic&& wSelf.pickerChooseForChangeSingleIndex >=0) {
                                [wSelf.images replaceObjectAtIndex:wSelf.pickerChooseForChangeSingleIndex withObject:[images safeObjectAtIndex:0]];
                                [wSelf refreshImages];
                              }else{
                                [wSelf.images addObjectsFromArray:images];
                                [wSelf initImages];
                              }
                              
                              for (NSInteger i=0; i<tags.count; i++) {
                                NSArray *imageTags = [tags safeArrayObjectAtIndex:i];
                                NSInteger localIndex = -1;

                                for (NSInteger j=0; j<_tags.count; j++) {
                                  NSArray *localImageTags = [_tags safeArrayObjectAtIndex:j];
                                  if (localImageTags.count>0 &&
                                      imageTags.count>0&&
                                      [[localImageTags[0] safeNumberObjectForKey:@"imageId"] integerValue] ==
                                      [[imageTags[0] safeNumberObjectForKey:@"imageId"] integerValue]) {
                                    localIndex = j;
                                    break;
                                  }
                                }
                                
                                if (localIndex>=0) {
                                  [wSelf.tags replaceObjectAtIndex:localIndex withObject:imageTags];
                                }else{
                                  [wSelf.tags addObject:imageTags];
                                }
                              }
                            }];

}

#pragma mark Location Delegate
- (void)selectLocationVCDidReturnWithLocation:(CLLocation *)location placemark:(NSString *)placemark{
  if (placemark) {
    _lblLBS.text = placemark;
    [_lblLBS sizeToFit];
    _lblLBS.left = _iconLBS.right+7;
    _lblLBS.top = (_lbsView.height-_lblLBS.height)/2.0;
    _lbsView.hidden = NO;
    [_btnLBS setImage:[UIImage imageNamed:@"send_location"] forState:UIControlStateNormal];
    _model.locationName = placemark;
    [[NSUserDefaults standardUserDefaults] setObject:@(location.coordinate.latitude) forKey:@"SWLocationLatitude"];
    [[NSUserDefaults standardUserDefaults] setObject:@(location.coordinate.longitude) forKey:@"SWLocationLongitude"];
  }else{
    _lblLBS.text = @"";
    _lbsView.hidden = YES;
    _model.locationName = @"";
    [_btnLBS setImage:[UIImage imageNamed:@"send_location_export"] forState:UIControlStateNormal];
  }
  [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark Text
- (void)dealloc{
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}
//键盘升起时动画
- (void)keyboardWillShow:(NSNotification*)notif{
  CGRect keyboardEndFrameWindow;
  [[notif.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardEndFrameWindow];
  CATransition* animation = [CATransition animation];
  animation.type = kCATransitionFade;
  animation.duration = 0.25;
  __weak typeof(self)wSelf = self;
  [UIView animateWithDuration:0.25 animations:^{
    wSelf.toolView.bottom = CGRectGetMinY(keyboardEndFrameWindow)+iphoneXBottomAreaHeight;
  } completion:nil];
}

//键盘关闭时动画
- (void)keyboardWillHide:(NSNotification*)notif{
  CATransition* animation = [CATransition animation];
  animation.type = kCATransitionFade;
  animation.duration = 0.25;
  __weak typeof(self)wSelf = self;
  [UIView animateWithDuration:0.25 animations:^{
    wSelf.toolView.bottom = wSelf.view.height;
  } completion:nil];
}

- (NSString *)urlString:(NSString *)urlString{
  NSURL *url = [NSURL URLWithString:urlString];
  NSArray * components = [urlString componentsSeparatedByString:@"."];
  if (url && url.scheme && url.host && (components.count == 3 || components.count == 4)){
    return urlString;
  }else{
    if (components.count == 3 || components.count == 4) {
      BOOL valid = YES;
      NSCharacterSet *alphaSet = [NSCharacterSet alphanumericCharacterSet];
      for (NSString * string in components) {
        valid = [[string stringByTrimmingCharactersInSet:alphaSet] isEqualToString:@""];
        if (!valid) {
          return nil;
        }
      }
      NSString *urlStringNew = [@"http://" stringByAppendingString:urlString];
      NSURL *urlNew = [NSURL URLWithString:urlStringNew];
      if (urlNew && urlNew.scheme && urlNew.host && [urlString componentsSeparatedByString:@"."].count == 3){
        return urlStringNew;
      }
    }
    return nil;
  }
}

- (void)textViewDidChange:(UITextView *)textView{
  _lblPlaceHolder.hidden = textView.text.length;
  _lblLength.text = [NSString stringWithFormat:@"%lu/2000", (unsigned long)textView.text.length];
  //根据大小改变颜色
  NSInteger num = 2000 - textView.text.length;
  if (num < 0){
    _lblLength.textColor = [UIColor hexChangeFloat:@"F4453C"];
  }else {
    _lblLength.textColor = [UIColor hexChangeFloat:@"8b9cad"];
  }
  
  if ([self urlString:textView.text] && !_btnCamera.tag && !_btnAlbum.tag && !_isPostingLink) {
    [self checkLinkWithString:[self urlString:textView.text]];
  }
  
  if (textView.text.length == 0) {
    _isPostingLink = NO;
    if ([self isPostingVideo]) {
      _videoView.hidden = NO;
      _photoView.hidden = YES;
      _linkView.hidden = YES;
    }else{
      _videoView.hidden = YES;
      _photoView.hidden = NO;
      _linkView.hidden = YES;
    }
  }
  
  if (textView.text.length || [self isPostingVideo] || _images.count>0) {
    _enableRightBarItem = YES;
  }else{
    _enableRightBarItem = NO;
  }
  [self rightBar];
}

- (void)checkLinkWithString:(NSString *)string{
  SWPostCheckLinkAPI *api = [[SWPostCheckLinkAPI alloc] init];
  api.link = string;
  __weak typeof(self)wSelf = self;
  [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
    NSDictionary *dic = [request.responseString safeJsonDicFromJsonString];
    if ([[[	dic safeDicObjectForKey:@"data"] safeStringObjectForKey:@"title"] length]>0 && !wSelf.isPostingLink) {
      wSelf.isPostingLink = YES;
      wSelf.postingLink = string;
      wSelf.postingLinkTitle = [[dic safeDicObjectForKey:@"data"] safeStringObjectForKey:@"title"];
      wSelf.postingLinkImageUrl = [[dic safeDicObjectForKey:@"data"] safeStringObjectForKey:@"image"];
      
      [wSelf refreshUrl];
    }
  } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
    
  }];
}

- (void)refreshUrl{
  if (!_linkView) {
    _linkView = [[SWPostLinkView alloc] initWithFrame:CGRectMake(12, _photoView.top+5, self.view.width-24, 62)];
    [self.view addSubview:_linkView];
    [self.view bringSubviewToFront:_toolView];
  }
  _enableRightBarItem = YES;
  [self rightBar];
  _txtContent.text = _postingLink;
  [_linkView refreshWithTitle:_postingLinkTitle image:_postingLinkImageUrl];
  _photoView.hidden = YES;
  _videoView.hidden = YES;
  
}

@end
