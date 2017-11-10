//
//  SWEditAvatarVC.m
//  SeeWorld
//
//  Created by Albert Lee on 5/16/16.
//  Copyright © 2016 SeeWorld. All rights reserved.
//

#import "SWEditAvatarVC.h"
#import "GetQiniuTokenApi.h"
#import "GetQiniuTokenResponse.h"
#import "QNUploadManager.h"
#import "SWObject.h"
#import "QNResponseInfo.h"
#import "ModifyUserInfoApi.h"
@interface SWEditAvatarVC ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property(nonatomic, strong)UIImageView *avatarView;
@property(nonatomic, strong)UIView      *toolView;
@property(nonatomic, strong)UIButton    *btnLibrary;
@property(nonatomic, strong)UIButton    *btnCamera;
@property(nonatomic, strong)UIImageView *avatarCoverView;
@property(nonatomic, strong)UIImagePickerController *libraryPicker;
@property(nonatomic, strong)UIImagePickerController *cameraPicker;
@end

@implementation SWEditAvatarVC

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor colorWithRGBHex:0x000000];
  [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
  [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
  self.navigationItem.leftBarButtonItem = [UIBarButtonItem loadLeftBarButtonItemWithTitle:@"取消"
                                                                                    color:[UIColor whiteColor]
                                                                                     font:[UIFont systemFontOfSize:18]
                                                                                   target:self
                                                                                   action:@selector(onDismiss)];
  self.navigationItem.rightBarButtonItem = [UIBarButtonItem loadBarButtonItemWithTitle:@"儲存"
                                                                                 color:[UIColor colorWithRGBHex:0x00f8ff]
                                                                                  font:[UIFont systemFontOfSize:18]
                                                                                target:self
                                                                                action:@selector(onSave)];
  self.navigationItem.titleView = [[ALTitleLabel alloc] initWithTitle:@"編輯大頭照" color:[UIColor colorWithRGBHex:0x191d28]];
  
  _avatarView = [[UIImageView alloc] initWithFrame:CGRectMake(0, (UIScreenHeight-UIScreenWidth)/2.0, UIScreenWidth, UIScreenWidth)];
  [_avatarView sd_setImageWithURL:[NSURL URLWithString:[SWConfigManager sharedInstance].user.picUrl]];
  [self.view addSubview:_avatarView];
  
  _avatarCoverView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"profile_pic_mask_2"]];
  _avatarCoverView.frame = CGRectMake(0, 0, UIScreenWidth, 1110*UIScreenWidth/750);
  [self.view addSubview:_avatarCoverView];
  _avatarCoverView.center = CGPointMake(UIScreenWidth/2.0, UIScreenHeight/2.0);
  _avatarCoverView.alpha = 0.5;
  
  _toolView = [[UIView alloc] initWithFrame:CGRectMake(0, UIScreenHeight-48, UIScreenWidth, 48)];
  _toolView.backgroundColor = [UIColor colorWithRGBHex:0x1a2531];
  [self.view addSubview:_toolView];
  
  _btnLibrary = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, _toolView.height)];
  [_btnLibrary setImage:[UIImage imageNamed:@"profile_btn_img"] forState:UIControlStateNormal];
  [_toolView addSubview:_btnLibrary];
  
  _btnCamera = [[UIButton alloc] initWithFrame:CGRectMake(UIScreenWidth-60, 0, 60, _toolView.height)];
  [_btnCamera setImage:[UIImage imageNamed:@"profile_btn_shooting"] forState:UIControlStateNormal];
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
    _cameraPicker.navigationBar.tintColor = [UIColor whiteColor];
    _cameraPicker.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    _cameraPicker.allowsEditing = YES;
    _cameraPicker.delegate = self;
    [_btnCamera addTarget:self action:@selector(onCamera) forControlEvents:UIControlEventTouchUpInside];
  }
  
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
          ModifyUserInfoApi *api = [[ModifyUserInfoApi alloc] init];
          api.name = [SWConfigManager sharedInstance].user.name;
          api.gender = [[SWConfigManager sharedInstance].user.gender integerValue];
          api.head = imageURL;
          api.intro = [SWConfigManager sharedInstance].user.intro;
          [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
            SWFeedUserItem *user = [SWFeedUserItem feedUserItemByDic:[[request.responseString safeJsonDicFromJsonString] safeDicObjectForKey:@"data"]];
            if ([user.uId integerValue]>0) {
              [SWConfigManager sharedInstance].user = user;
              [[RCIM sharedRCIM] refreshUserInfoCache:[[RCUserInfo alloc] initWithUserId:[user.uId stringValue]
                                                                                    name:user.name
                                                                                portrait:user.picUrl]
                                           withUserId:[user.uId stringValue]];
              [[NSUserDefaults standardUserDefaults] setObject:[user dicValue] forKey:@"userInfo"];
              [[NSUserDefaults standardUserDefaults] synchronize];
              [SWHUD showCommonToast:@"保存成功"];
              [wSelf dismissViewControllerAnimated:YES completion:nil];
            }else{
              [SWHUD showCommonToast:@"保存失败"];
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
