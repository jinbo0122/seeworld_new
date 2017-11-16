//
//  SWEditCoverVC.m
//  SeeWorld
//
//  Created by Albert Lee on 5/16/16.
//  Copyright © 2016 SeeWorld. All rights reserved.
//

#import "SWEditCoverVC.h"
#import "GetQiniuTokenApi.h"
#import "GetQiniuTokenResponse.h"
#import "QNUploadManager.h"
#import "SWObject.h"
#import "QNResponseInfo.h"
#import "SWEditCoverAPI.h"
#import "GetUserInfoApi.h"
@interface SWEditCoverVC ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property(nonatomic, strong)UIImageView *avatarView;
@property(nonatomic, strong)UIView      *toolView;
@property(nonatomic, strong)UIButton    *btnLibrary;
@property(nonatomic, strong)UIButton    *btnCamera;
@property(nonatomic, strong)UIImageView *avatarCoverView;
@property(nonatomic, strong)UIImagePickerController *libraryPicker;
@property(nonatomic, strong)UIImagePickerController *cameraPicker;
@end

@implementation SWEditCoverVC

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor colorWithRGBHex:0xe8edf3];
  [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
  [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRGBHex:0xffffff]];
  self.navigationItem.leftBarButtonItem = [UIBarButtonItem loadLeftBarButtonItemWithTitle:@"取消"
                                                                                    color:[UIColor colorWithRGBHex:0x55acef]
                                                                                     font:[UIFont systemFontOfSize:18]
                                                                                   target:self
                                                                                   action:@selector(onDismiss)];
  self.navigationItem.rightBarButtonItem = [UIBarButtonItem loadBarButtonItemWithTitle:@"儲存"
                                                                                 color:[UIColor colorWithRGBHex:0x55acef]
                                                                                  font:[UIFont systemFontOfSize:18]
                                                                                target:self
                                                                                action:@selector(onSave)];
  self.navigationItem.titleView = [[ALTitleLabel alloc] initWithTitle:@"編輯封面" color:[UIColor colorWithRGBHex:NAV_BAR_COLOR_HEX]];
  
  _avatarView = [[UIImageView alloc] initWithFrame:CGRectMake(0, (UIScreenHeight-UIScreenWidth)/2.0, UIScreenWidth, UIScreenWidth)];
  if ([SWConfigManager sharedInstance].user.bghead.length>0) {
    [_avatarView sd_setImageWithURL:[NSURL URLWithString:[SWConfigManager sharedInstance].user.bghead]];
  }else{
    _avatarView.image = [UIImage imageNamed:@"profile_img_fontcover_default"];
  }
  _avatarView.contentMode = UIViewContentModeScaleAspectFit;
  [self.view addSubview:_avatarView];
  
  _toolView = [[UIView alloc] initWithFrame:CGRectMake(0, UIScreenHeight-64-iphoneXBottomAreaHeight, UIScreenWidth, 64+iphoneXBottomAreaHeight)];
  _toolView.backgroundColor = [UIColor colorWithRGBHex:0xffffff];
  [_toolView addSubview:[ALLineView lineWithFrame:CGRectMake(0, 0, _toolView.width, 0.5) colorHex:0xe7e6e6]];
  [self.view addSubview:_toolView];
  
  _btnLibrary = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, _toolView.width/2.0, 64)];
  [_btnLibrary setImage:[UIImage imageNamed:@"send_image"] forState:UIControlStateNormal];
  [_toolView addSubview:_btnLibrary];
  
  _btnCamera = [[UIButton alloc] initWithFrame:CGRectMake(_btnLibrary.right, 0, _btnLibrary.width, _btnLibrary.height)];
  [_btnCamera setImage:[UIImage imageNamed:@"send_camera"] forState:UIControlStateNormal];
  [_toolView addSubview:_btnCamera];
  
  _libraryPicker = [[UIImagePickerController alloc] init];
  _libraryPicker.navigationBar.tintColor = [UIColor whiteColor];
  _libraryPicker.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
  _libraryPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
  _libraryPicker.allowsEditing = YES;
  _libraryPicker.delegate = self;
  
  if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
    _cameraPicker = [[UIImagePickerController alloc] init];
    _cameraPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    _libraryPicker.navigationBar.tintColor = [UIColor whiteColor];
    _libraryPicker.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    _cameraPicker.allowsEditing = YES;
    _cameraPicker.delegate = self;
  }
  
  [_btnCamera addTarget:self action:@selector(onCamera) forControlEvents:UIControlEventTouchUpInside];
  [_btnLibrary addTarget:self action:@selector(onLibrary) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)onCamera{
  [self presentViewController:_cameraPicker animated:YES completion:nil];
}

- (void)onLibrary{
  [self presentViewController:_libraryPicker animated:YES completion:nil];
}

- (void)onDismiss{
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onSave{
  [SWHUD showWaiting];
  GetQiniuTokenApi *api = [[GetQiniuTokenApi alloc] init];
  __weak typeof(self)wSelf = self;
  [api startWithModelClass:[GetQiniuTokenResponse class] completionBlock:^(ModelMessage *message) {
    if (message.isSuccess){
      GetQiniuTokenResponse *resp = message.object;
      NSString *token = resp.data;
      QNUploadManager *manager = [[QNUploadManager alloc] init];
      NSData *imageData = UIImageJPEGRepresentation(wSelf.avatarView.image, 0.3);
      [manager putData:imageData key:[SWObject createUUID] token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
        if (info.ok && resp[@"key"]){
          NSString *imageURL = [NSString stringWithFormat:@"http://7xlsvh.com1.z0.glb.clouddn.com/%@",[resp valueForKey:@"key"]];
          [SWHUD hideWaiting];
          SWEditCoverAPI *api = [[SWEditCoverAPI alloc] init];
          api.bgHead = imageURL;
          [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
            if ([[[[request.responseString safeJsonDicFromJsonString] safeDicObjectForKey:@"meta"] safeNumberObjectForKey:@"code"] integerValue]==200) {
              GetUserInfoApi *userApi = [[GetUserInfoApi alloc] init];
              userApi.userId = [[SWConfigManager sharedInstance].user.uId stringValue];
              [userApi startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
                SWFeedUserItem *user = [SWFeedUserItem feedUserItemByDic:[[request.responseString safeJsonDicFromJsonString] safeDicObjectForKey:@"data"]];
                if ([user.uId integerValue]>0) {
                  [SWConfigManager sharedInstance].user = user;
                  [[NSUserDefaults standardUserDefaults] setObject:[user dicValue] forKey:@"userInfo"];
                  [[NSUserDefaults standardUserDefaults] synchronize];
                  [SWHUD showCommonToast:@"保存成功"];
                  [wSelf dismissViewControllerAnimated:YES completion:nil];
                }else{
                  [SWHUD showCommonToast:@"保存失败"];
                }
              } failure:^(YTKBaseRequest *request) {
                
              }];
            }
          } failure:^(YTKBaseRequest *request) {
            [SWHUD showCommonToast:@"保存失败"];
          }];
        }else{
          [SWHUD hideWaiting];
          [SWHUD showCommonToast:@"保存失败"];
        }
      } option:nil];
    }else{
      [SWHUD hideWaiting];
      [SWHUD showCommonToast:@"保存失败"];
    }
  }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
  [self dismissViewControllerAnimated:YES completion:nil];
  _avatarView.image = [info objectForKey:UIImagePickerControllerEditedImage];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
  return UIStatusBarStyleDefault;
}
@end
