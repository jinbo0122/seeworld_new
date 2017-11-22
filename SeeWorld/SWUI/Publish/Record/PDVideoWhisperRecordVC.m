//
//  PDVideoWhisperRecordVC.m
//  pandora
//
//  Created by Albert Lee on 27/10/2016.
//  Copyright © 2016 Albert Lee. All rights reserved.
//

#import "PDVideoWhisperRecordVC.h"
#import "PDVideoWhisperRecordTopView.h"
#import "PDVideoWhisperRecordBottomView.h"
#import "SCRecorder.h"
#import "PDVideoWhisperRecordProgressView.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "UzysAssetsPickerController.h"
#import "SWPostPreviewVC.h"
#import "AVAsset+VideoOrientation.h"
#import "SWPostVC.h"
#import <Photos/Photos.h>
@interface PDVideoWhisperRecordVC ()<UzysAssetsPickerControllerDelegate, SCRecorderDelegate,
SWPostPreviewVCDelegate>
@property(nonatomic, strong)SCRecorder *recorder;
@property(nonatomic, strong)NSURL      *videoUrl;
@property (nonatomic, strong) UzysAssetsPickerController *photoPicker;

@end

@implementation PDVideoWhisperRecordVC{
  UIView    *_cameraPreview;
  PDVideoWhisperRecordTopView       *_topView;
  PDVideoWhisperRecordBottomView    *_bottomView;
  PDVideoWhisperRecordProgressView  *_progressView;
  
  BOOL                              _hasRecordStart;
  NSTimeInterval                    _recordStartTime;
  
  UIButton                          *_btnChangeMode;
  UILabel                           *_lblChangeModeLabel[3];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self.navigationController setNavigationBarHidden:YES];
  self.view.backgroundColor = [UIColor colorWithRGBHex:0x000000];
  [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
  [[UIApplication sharedApplication] setStatusBarHidden:YES];
  //Add Camera View
  BOOL iPhone4 = UIScreenHeight==480;
  _cameraPreview = [[UIView alloc] initWithFrame:CGRectMake(0, 22.5+iOSTopHeight, self.view.width, self.view.width*(iPhone4?1:(4/3.0)))];
  _cameraPreview.backgroundColor = [UIColor clearColor];
  [self.view addSubview:_cameraPreview];
  
  _btnChangeMode = [[UIButton alloc] initWithFrame:CGRectMake((self.view.width-123)/2.0, _cameraPreview.bottom, 123, 47)];
  [self.view addSubview:_btnChangeMode];
  ALLineView *dot = [ALLineView lineWithFrame:CGRectMake((_btnChangeMode.width-6)/2.0, 16, 6, 6) colorHex:0x55acef];
  dot.layer.masksToBounds = YES;
  dot.layer.cornerRadius = dot.height/2.0;
  dot.userInteractionEnabled = NO;
  [_btnChangeMode addSubview:dot];
  [_btnChangeMode addTarget:self action:@selector(onChangeModeClicked) forControlEvents:UIControlEventTouchUpInside];
  for (NSInteger i=0; i<3; i++) {
    _lblChangeModeLabel[i] = [UILabel initWithFrame:CGRectMake(46.5*i, dot.bottom+4, 30, 21)
                                            bgColor:[UIColor clearColor]
                                          textColor:[UIColor whiteColor]
                                               text:@""
                                      textAlignment:NSTextAlignmentCenter
                                               font:[UIFont systemFontOfSize:14]];
    [_btnChangeMode addSubview:_lblChangeModeLabel[i]];
    _lblChangeModeLabel[i].userInteractionEnabled = NO;
  }
  _lblChangeModeLabel[1].text = @"視頻";
  _lblChangeModeLabel[1].textColor = [UIColor colorWithRGBHex:0x55acef];
  _lblChangeModeLabel[2].text = @"拍照";
  
  _topView = [[PDVideoWhisperRecordTopView alloc] initWithFrame:CGRectMake(0, iOSTopHeight, self.view.width, 45)];
  [self.view addSubview:_topView];
  [_topView.btnClose addTarget:self action:@selector(onCloseClicked:) forControlEvents:UIControlEventTouchUpInside];
  [_topView.btnFlash addTarget:self action:@selector(onFlashClicked:) forControlEvents:UIControlEventTouchUpInside];
  _topView.btnFlash.tag = 1;
  _bottomView = [[PDVideoWhisperRecordBottomView alloc] initWithFrame:CGRectMake(0, self.view.height-122-iphoneXBottomAreaHeight,
                                                                                 self.view.width, 122+iphoneXBottomAreaHeight)];
  [self.view addSubview:_bottomView];
  
  _progressView = [[PDVideoWhisperRecordProgressView alloc] initWithFrame:CGRectMake(0, _cameraPreview.bottom-33,
                                                                                     self.view.width, 33)];
  [self.view addSubview:_progressView];
  _progressView.duration = 0;
  
  _bottomView.btnFlipCamera.tag = 1;
  [_bottomView.btnRecord addTarget:self action:@selector(onRecordClicked:) forControlEvents:UIControlEventTouchUpInside];
  [_bottomView.btnAlbum addTarget:self action:@selector(onAlbumClicked:) forControlEvents:UIControlEventTouchUpInside];
  [_bottomView.btnDelete addTarget:self action:@selector(onDeleteClicked:) forControlEvents:UIControlEventTouchUpInside];
  [_bottomView.btnFlipCamera addTarget:self action:@selector(onFlipCameraClicked:) forControlEvents:UIControlEventTouchUpInside];
  [_bottomView.btnOkay addTarget:self action:@selector(onOkayClicked:) forControlEvents:UIControlEventTouchUpInside];
  [self refreshButttons];
  [self performSelector:@selector(initSCRecorder) withObject:nil afterDelay:0.1];
  [self.view bringSubviewToFront:_btnChangeMode];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(onRegisnActive)
                                               name:UIApplicationWillResignActiveNotification
                                             object:nil];
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(applicationDidBecomeActive:)
                                               name:UIApplicationDidBecomeActiveNotification
                                             object:nil];
  
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];
  [_recorder previewViewFrameChanged];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  [[UIApplication sharedApplication] setStatusBarHidden:YES];
  [self resetRecord];
}

- (void)viewDidDisappear:(BOOL)animated{
  [super viewDidDisappear:animated];
  [[UIApplication sharedApplication] setStatusBarHidden:NO];
  [_recorder stopRunning];
}

#pragma mark - Custom Methods
- (void)onChangeModeClicked{
  _btnChangeMode.tag = 1-_btnChangeMode.tag;
  if (_btnChangeMode.tag) {
    _lblChangeModeLabel[2].text = @"";
    _lblChangeModeLabel[0].text = @"視頻";
    _lblChangeModeLabel[1].text = @"拍照";
  }else{
    _lblChangeModeLabel[0].text = @"";
    _lblChangeModeLabel[1].text = @"視頻";
    _lblChangeModeLabel[2].text = @"拍照";
  }
}

- (void)refreshButttons{
  if (_hasRecordStart) {
    _bottomView.btnDelete.hidden = _bottomView.btnOkay.hidden = NO;
    _bottomView.btnAlbum.hidden = _bottomView.btnFlipCamera.hidden = YES;
  }else{
    _bottomView.btnDelete.hidden = _bottomView.btnOkay.hidden = YES;
    _bottomView.btnAlbum.hidden = _bottomView.btnFlipCamera.hidden = NO;
    
    if (_bottomView.btnFlipCamera.tag) {
      _topView.btnFlash.enabled = NO;
      [_topView.btnFlash setImage:[UIImage imageNamed:PDResourceBtnVideoWhisperFlashOff] forState:UIControlStateNormal];
      [_topView.btnFlash setImage:[UIImage imageNamed:PDResourceBtnVideoWhisperFlashOff] forState:UIControlStateDisabled];
    }else{
      _topView.btnFlash.enabled = YES;
      if (_topView.btnFlash.tag) {
        [_topView.btnFlash setImage:[UIImage imageNamed:PDResourceBtnVideoWhisperFlashOn] forState:UIControlStateNormal];
      }else{
        [_topView.btnFlash setImage:[UIImage imageNamed:PDResourceBtnVideoWhisperFlashOff] forState:UIControlStateNormal];
      }
    }
  }
  if (_bottomView.btnRecord.tag) {
    [_bottomView.btnRecord setImage:[UIImage imageNamed:PDResourceBtnVideoWhisperRecording] forState:UIControlStateNormal];
  }else{
    [_bottomView.btnRecord setImage:[UIImage imageNamed:PDResourceBtnVideoWhisperRecordPress] forState:UIControlStateNormal];
  }
}

- (void)onCloseClicked:(UIButton *)button{
  [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
  [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
  [[UIApplication sharedApplication] setStatusBarHidden:NO];
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onFlashClicked:(UIButton *)button{
  button.tag = 1-button.tag;
  [self refreshButttons];
  if (button.tag) {
    _recorder.flashMode = SCFlashModeLight;
  }else{
    _recorder.flashMode = SCFlashModeOff;
  }
}

- (void)onAlbumClicked:(UIButton *)button{
  UzysAssetsPickerController *photoPicker = [[UzysAssetsPickerController alloc] init];
  photoPicker.delegate = self;
  photoPicker.maximumNumberOfSelectionVideo = 1;
  if (!_isPostingVideo) {
    photoPicker.maximumNumberOfSelectionPhoto = 9 - (_startIndex-1000);
  }
  photoPicker.defaultSegIndex = 1;
  _photoPicker = photoPicker;
  UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:photoPicker];
  [nav.navigationBar setBarTintColor:[UIColor blackColor]];
  [nav setNavigationBarHidden:YES];
  [self presentViewController:nav animated:YES completion:^{
  }];
}

- (void)onDeleteClicked:(UIButton *)button{
  BOOL isRecording = [_recorder isRecording];
  
  if (isRecording) {
    _bottomView.btnRecord.tag = 1;
    [_bottomView.btnRecord sendActionsForControlEvents:UIControlEventTouchUpInside];
    __weak typeof(self)wSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
      [wSelf resetRecord];
    });
  }else{
    [self resetRecord];
  }
}

- (void)onFlipCameraClicked:(UIButton *)button{
  button.tag = 1-button.tag;
  
  if (button.tag) {
    _recorder.device = AVCaptureDevicePositionFront;
  }else{
    _topView.btnFlash.tag = 0;
    _recorder.device = AVCaptureDevicePositionBack;
  }
  
  [self refreshButttons];
}

- (void)onOkayClicked:(UIButton *)button{
  __weak typeof(self)wSelf = self;
  [_recorder pause:^{
    [wSelf.recorder.session mergeSegmentsUsingPreset:AVAssetExportPreset640x480
                                   completionHandler:^(NSURL * _Nullable outputUrl, NSError * _Nullable error) {
                                     if (!error && outputUrl) {
                                       wSelf.videoUrl = outputUrl;
                                       if ([wSelf.delegate respondsToSelector:@selector(videoWhisperRecordVCDidReturnVideoUrl:)]) {
                                         [wSelf.delegate videoWhisperRecordVCDidReturnVideoUrl:wSelf.videoUrl];
                                       }
                                       [wSelf saveVideoToAlbum:wSelf.videoUrl];
                                     }else{
                                       [PDProgressHUD showTip:@"请稍后重试"];
                                     }
                                     [wSelf.recorder.session removeAllSegments];
                                   }];
  }];
  [_recorder stopRunning];
}

- (void) saveVideoToAlbum:(NSURL*)videoURL{
  PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
  if (status == PHAuthorizationStatusAuthorized) {
    if (videoURL == nil) {
      return;
    }
    self.videoUrl = videoURL;
    __weak typeof(self)wSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
      __strong typeof(wSelf)sSelf = wSelf;
      if (sSelf.videoUrl) {
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        [library saveVideo:sSelf.videoUrl toAlbum:@"SeeWorld+" completion:nil failure:nil];
      }
    });
  }else if (status == PHAuthorizationStatusNotDetermined){
    __weak typeof(self)wSelf = self;
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
      if (status == PHAuthorizationStatusAuthorized) {
        [wSelf saveVideoToAlbum:videoURL];
      }else{
        [self showDisableAlert];
      }
    }];
  }else{
    [self showDisableAlert];
  }
}

- (void)showDisableAlert{
  UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil
                                                   message:@"請在手機系統的設置 > 隱私 > 照片中，允許抱抱訪問你的手機相冊。"
                                          cancelButtonItem:
                         [RIButtonItem itemWithLabel:SWStringOkay
                                              action:^{
                                                [[UIApplication sharedApplication] openURL:[NSURL  URLWithString:UIApplicationOpenSettingsURLString]];
                                              }]
                                          otherButtonItems:nil];
  [alert show];
}


- (void)onRecordClicked:(UIButton *)button{
  if (_btnChangeMode.tag) {
    [_recorder capturePhoto:^(NSError * _Nullable error, UIImage * _Nullable image) {
      if (!error) {
        UIImage *fixedImage = [image fixOrientation];
        SWPostPreviewVC *vc = [[SWPostPreviewVC alloc] init];
        vc.images = [@[fixedImage] mutableCopy];
        vc.delegate = self;
        vc.startIndex = _startIndex;
        vc.isModal = YES;
        [self presentViewController:vc animated:YES completion:nil];
      }
    }];
  }else{
    _hasRecordStart = YES;
    button.tag = 1-button.tag;
    [self refreshButttons];
    if (button.tag) {
      if (_recordStartTime == 0) {
        _recordStartTime = [[NSDate date] timeIntervalSince1970];
      }
      
      [_recorder record];
    }else{
      [_recorder pause];
    }
  }
}

- (void)resetRecord{
  [_recorder pause];
  _progressView.duration = 0;
  _hasRecordStart = NO;
  _bottomView.btnRecord.tag = 0;
  _recordStartTime = 0;
  _bottomView.btnOkay.customImageView.image = [UIImage imageNamed:PDResourceBtnVideoWhisperOkayDisable];
  _bottomView.btnOkay.lblCustom.textColor = [UIColor colorWithRGBHex:0x7f7e80];
  [_recorder.session removeAllSegments];
  [_recorder continuousFocusAtPoint:CGPointMake(0.5f, 0.5f)];
  [_recorder startRunning];
  [self refreshButttons];
}

- (void)onRegisnActive{
  if ([_recorder isRecording]) {
    _bottomView.btnRecord.tag = 1;
    [_bottomView.btnRecord sendActionsForControlEvents:UIControlEventTouchUpInside];
  }
}

- (void)applicationDidBecomeActive:(id)sender {
  // 切前台强制重置对焦点
  if (_recorder) {
    [_recorder continuousFocusAtPoint:CGPointMake(0.5f, 0.5f)];
  }
}

#pragma mark - UzysAssetsPickerControllerDelegate
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
      if (wSelf.fromPostVC) {
        if (wSelf.delegate && [wSelf.delegate respondsToSelector:@selector(videoWhisperRecordVCDidReturnVideoUrl:)]) {
          [wSelf.delegate videoWhisperRecordVCDidReturnVideoUrl:[asset defaultRepresentation].url];
        }
      }else{
        [wSelf dismissViewControllerAnimated:NO
                                  completion:^{
                                    [wSelf dismissViewControllerAnimated:NO
                                                              completion:^{
                                                                SWPostVC *vc = [[SWPostVC alloc] init];
                                                                vc.videoAsset = asset;
                                                                vc.videoThumbImage = image;
                                                                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
                                                                TabViewController *tabVC = (TabViewController *)[UIApplication sharedApplication].delegate.window.rootViewController;
                                                                [tabVC presentViewController:nav animated:YES completion:nil];
                                                              }];
                                  }];
      }
    }else{
      if (image && [image isKindOfClass:[UIImage class]]){
        [imageArray addObject:image];
      }
      
      if (idx == assets.count-1) {
        if (preview) {
          SWPostPreviewVC *vc = [[SWPostPreviewVC alloc] init];
          vc.images = [imageArray mutableCopy];
          vc.delegate = wSelf;
          vc.startIndex = _startIndex;
          [picker.navigationController setNavigationBarHidden:NO];
          [picker.navigationController pushViewController:vc animated:YES];
        }else{
          if (wSelf.fromPostVC){
            [self dismissViewControllerAnimated:YES
                                     completion:^{
                                       if (wSelf.delegate && [wSelf.delegate respondsToSelector:@selector(videoWhisperRecordVCDidReturnImages:tags:)]) {
                                         [wSelf.delegate videoWhisperRecordVCDidReturnImages:imageArray tags:@[]];
                                       }
                                     }];
          }
          else{
            [wSelf dismissViewControllerAnimated:NO
                                      completion:^{
                                        [wSelf dismissViewControllerAnimated:NO
                                                                  completion:^{
                                                                    SWPostVC *vc = [[SWPostVC alloc] init];
                                                                    vc.images = [imageArray mutableCopy];
                                                                    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
                                                                    TabViewController *tabVC = (TabViewController *)[UIApplication sharedApplication].delegate.window.rootViewController;
                                                                    [tabVC presentViewController:nav animated:YES completion:nil];
                                                                  }];
                                        
                                      }];
            
          }
          
        }
      }
    }
  }];
}

- (void)uzysAssetsPickerControllerDidExceedMaximumNumberOfSelection:(UzysAssetsPickerController *)picker{
  
}

- (void)postPreviewVCDidPressFinish:(SWPostPreviewVC *)previewVC images:(NSArray *)images tags:(NSArray *)tags{
  __weak typeof(self)wSelf = self;
  if (wSelf.fromPostVC) {
    [self dismissViewControllerAnimated:YES
                             completion:^{
                               if (wSelf.delegate && [wSelf.delegate respondsToSelector:@selector(videoWhisperRecordVCDidReturnImages:tags:)]) {
                                 [wSelf.delegate videoWhisperRecordVCDidReturnImages:images tags:tags];
                               }
                             }];
  }else{
    [self dismissViewControllerAnimated:YES
                             completion:^{
                               [wSelf dismissViewControllerAnimated:YES
                                                         completion:^{
                                                           SWPostVC *vc = [[SWPostVC alloc] init];
                                                           vc.images = [images mutableCopy];
                                                           vc.tags = [tags mutableCopy];
                                                           UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
                                                           TabViewController *tabVC = (TabViewController *)[UIApplication sharedApplication].delegate.window.rootViewController;
                                                           [tabVC presentViewController:nav animated:YES completion:nil];
                                                         }];
                               
                             }];
    
  }
}

#pragma mark - Video Picker
-(void) initSCRecorder {
  _recorder = [SCRecorder recorder];
  //_recorder.captureSessionPreset = [SCRecorderTools bestCaptureSessionPresetCompatibleWithAllDevices];
  _recorder.captureSessionPreset = AVCaptureSessionPreset640x480;
  _recorder.maxRecordDuration = CMTimeMake(180.0, 1);
  //_recorder.fastRecordMethodEnabled = YES;
  _recorder.device = AVCaptureDevicePositionFront;
  _recorder.delegate = self;
  _recorder.autoSetVideoOrientation = NO; //YES causes bad orientation for video from camera roll
  _recorder.previewView = _cameraPreview;
  _recorder.initializeSessionLazily = NO;
  
  NSError *error;
  if (![_recorder prepare:&error]) {
    NSLog(@"Prepare error: %@", error.localizedDescription);
  }
  
  [self prepareSession];
  [_recorder startRunning];
}

- (void)prepareSession {
  if (_recorder.session == nil) {
    SCRecordSession *session = [SCRecordSession recordSession];
    session.fileType = AVFileTypeMPEG4;
    _recorder.session = session;
  }
}

- (void)saveAndShowSession:(SCRecordSession *)recordSession {
  __weak typeof(self)wSelf = self;
  [wSelf.recorder.session mergeSegmentsUsingPreset:AVAssetExportPreset640x480
                                 completionHandler:^(NSURL * _Nullable outputUrl, NSError * _Nullable error) {
                                   if (!error && outputUrl) {
                                     wSelf.videoUrl = outputUrl;
                                     if ([wSelf.delegate respondsToSelector:@selector(videoWhisperRecordVCDidReturnVideoUrl:)]) {
                                       [wSelf.delegate videoWhisperRecordVCDidReturnVideoUrl:wSelf.videoUrl];
                                     }
                                     [wSelf saveVideoToAlbum:wSelf.videoUrl];
                                   }else{
                                     [PDProgressHUD showTip:@"请稍后重试"];
                                   }
                                   [wSelf.recorder.session removeAllSegments];
                                 }];
}


#pragma mark - SCRecorderDelegate
- (void)recorder:(SCRecorder *)recorder didCompleteSession:(SCRecordSession *)recordSession {
  [self saveAndShowSession:recordSession];
}

- (void)recorder:(SCRecorder *)recorder didBeginSegmentInSession:(SCRecordSession *)recordSession error:(NSError *)error {
  NSLog(@"Began record segment with error: %@", error);
}

- (void)recorder:(SCRecorder *)recorder didCompleteSegment:(SCRecordSessionSegment *)segment
       inSession:(SCRecordSession *)recordSession error:(NSError *)error {
  NSLog(@"Completed record segment at %@: %@ (frameRate: %f)", segment.url, error, segment.frameRate);
}


- (void)recorder:(SCRecorder *)recorder didAppendVideoSampleBufferInSession:(SCRecordSession *)recordSession {
  _progressView.duration = CMTimeGetSeconds(recordSession.duration);
  _bottomView.btnOkay.customImageView.image = [UIImage imageNamed:_progressView.duration>=3?PDResourceBtnVideoWhisperOkay:PDResourceBtnVideoWhisperOkayDisable];
  _bottomView.btnOkay.lblCustom.textColor = [UIColor colorWithRGBHex:_progressView.duration>=3?0xffffff:0x7f7e80];
  
}

- (void) recorderWillStartAdjustingExposure:(SCRecorder *)recorder {
  [_recorder continuousFocusAtPoint:CGPointMake(0.5f, 0.5f)];
}


- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [[UIApplication sharedApplication] setStatusBarHidden:YES];
  [self prepareSession];
  
}

- (void)viewWillDisappear:(BOOL)animated{
  [super viewWillDisappear:animated];
  [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

- (void) dealloc {
  _recorder.previewView = nil;
  _recorder.delegate = nil;
  _recorder = nil;
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
