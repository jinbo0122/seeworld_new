//
//  SWRegisterProfileVC.m
//  SeeWorld
//
//  Created by Albert Lee on 6/5/16.
//  Copyright © 2016 SeeWorld. All rights reserved.
//

#import "SWRegisterProfileVC.h"
#import "SWActionSheetView.h"
#import "GetQiniuTokenApi.h"
#import "GetQiniuTokenResponse.h"
#import "QNUploadManager.h"
#import "SWObject.h"
#import "QNResponseInfo.h"
#import "LoginRequestApi.h"
#import "SWLoginVC.h"
#import "SWAgreementVC.h"
#import "LoginResponse.h"
@interface SWRegisterProfileVC ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,
UITextFieldDelegate>
@property(nonatomic, strong)UILabel *lblName;
@property(nonatomic, strong)UILabel *lblGender;

@property(nonatomic, strong)UITextField *txtName;
@property(nonatomic, strong)UIButton    *btnGender;

@property(nonatomic, strong)UIButton    *btnNext;

@property(nonatomic, strong)UIButton    *btnLibrary;
@property(nonatomic, strong)UIButton    *btnCamera;

@property(nonatomic, strong)UIView      *avatarBgView;
@property(nonatomic, strong)UIImageView *avatarView;
@property(nonatomic, strong)UIImagePickerController *libraryPicker;
@property(nonatomic, strong)UIImagePickerController *cameraPicker;

@property(nonatomic, strong)UIButton    *btnAgreement;


@end

@implementation SWRegisterProfileVC{
  UIImageView *_bgView;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.navigationItem.titleView = [[ALTitleLabel alloc] initWithTitle:@"個人資料" color:[UIColor whiteColor]];
  
  _bgView = [[UIImageView alloc] initWithFrame:self.view.bounds];
  _bgView.image = [UIImage imageNamed:@"first_profile_bg"];
  _bgView.contentMode = UIViewContentModeScaleAspectFill;
  [self.view addSubview:_bgView];
  
  
  _lblName = [UILabel initWithFrame:CGRectMake(32, 264, 40, 16)
                            bgColor:[UIColor clearColor]
                          textColor:[UIColor colorWithRGBHex:0xfbfcfc]
                               text:@"姓名"
                      textAlignment:NSTextAlignmentLeft
                               font:[UIFont systemFontOfSize:16]];
  [self.view addSubview:_lblName];
  
  _lblGender = [UILabel initWithFrame:CGRectMake(32, _lblName.bottom+50, 40, 16)
                              bgColor:[UIColor clearColor]
                            textColor:[UIColor colorWithRGBHex:0xfbfcfc]
                                 text:@"性別"
                        textAlignment:NSTextAlignmentLeft
                                 font:[UIFont systemFontOfSize:16]];
  [self.view addSubview:_lblGender];
  
  _txtName = [[UITextField alloc] initWithFrame:CGRectMake(90, _lblName.top, UIScreenWidth-120, 16)];
  _txtName.font = [UIFont systemFontOfSize:16];
  _txtName.textColor = [UIColor whiteColor];
  _txtName.text = [SWConfigManager sharedInstance].user.name;
  _txtName.tintColor = [UIColor whiteColor];
  _txtName.returnKeyType = UIReturnKeyDone;
  _txtName.delegate = self;
  [self.view addSubview:_txtName];
  [_txtName addTarget:self action:@selector(checkInfoValid) forControlEvents:UIControlEventEditingChanged];
  
  _btnGender = [[UIButton alloc] initWithFrame:CGRectMake(90, _lblGender.top, UIScreenWidth-120, 16)];
  _btnGender.customImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_btnGender.width-20, 0, 11.5, 20)];
  _btnGender.customImageView.image = [UIImage imageNamed:@"setting_btn_enter"];
  [self.view addSubview:_btnGender];
  [_btnGender addSubview:_btnGender.customImageView];
  _btnGender.lblCustom = [UILabel initWithFrame:CGRectMake(0, 0, 100, 16)
                                        bgColor:[UIColor clearColor]
                                      textColor:[UIColor whiteColor]
                                           text:@""
                                  textAlignment:NSTextAlignmentLeft
                                           font:[UIFont systemFontOfSize:16]];
  [_btnGender addSubview:_btnGender.lblCustom];
  [_btnGender addTarget:self action:@selector(onGenderClick) forControlEvents:UIControlEventTouchUpInside];
  
  [self.view addSubview:[ALLineView lineWithFrame:CGRectMake(32, _lblName.bottom+10, UIScreenWidth-64, 1.0) colorHex:0xffffff]];
  [self.view addSubview:[ALLineView lineWithFrame:CGRectMake(32, _lblGender.bottom+10, UIScreenWidth-64, 1.0) colorHex:0xffffff]];
  
  _btnNext = [[UIButton alloc] initWithFrame:CGRectMake(30, 437, self.view.width-60, 48)];
  [_btnNext setBackgroundColor:[UIColor colorWithRGBHex:0x75bad1]];
  [_btnNext setTitle:@"下一步" forState:UIControlStateNormal];
  [_btnNext setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  [_btnNext.titleLabel setFont:[UIFont systemFontOfSize:16]];
  [self.view addSubview:_btnNext];
  [_btnNext addTarget:self action:@selector(onNext) forControlEvents:UIControlEventTouchUpInside];
  _btnNext.layer.masksToBounds = YES;
  _btnNext.layer.cornerRadius = 2.0;
  
  
  _btnLibrary = [[UIButton alloc] initWithFrame:CGRectMake((self.view.width-199)/2.0, 147, 48, 40)];
  [_btnLibrary setImage:[UIImage imageNamed:@"profile_btn_img"] forState:UIControlStateNormal];
  [self.view addSubview:_btnLibrary];
  
  _avatarBgView = [[UIView alloc] initWithFrame:CGRectMake(_btnLibrary.right, 110, 111, 111)];
  _avatarBgView.layer.masksToBounds = YES;
  _avatarBgView.layer.cornerRadius = _avatarBgView.width/2.0;
  _avatarBgView.layer.borderWidth = 1.0;
  _avatarBgView.layer.borderColor = [UIColor whiteColor].CGColor;
  [self.view addSubview:_avatarBgView];
  
  _avatarView = [[UIImageView alloc] initWithFrame:CGRectMake(18, 18, _avatarBgView.width-36, _avatarBgView.width-36)];
  _avatarView.layer.masksToBounds = YES;
  _avatarView.layer.cornerRadius = _avatarView.width/2.0;
  _avatarView.backgroundColor = [UIColor colorWithRGBHex:0xa0d9e4];
  [_avatarBgView addSubview:_avatarView];
  
  _btnCamera = [[UIButton alloc] initWithFrame:CGRectMake(_avatarBgView.right, _btnLibrary.top, 48, 40)];
  [_btnCamera setImage:[UIImage imageNamed:@"profile_btn_shooting"] forState:UIControlStateNormal];
  [self.view addSubview:_btnCamera];
  
  _libraryPicker = [[UIImagePickerController alloc] init];
  _libraryPicker.navigationBar.tintColor = [UIColor whiteColor];
  _libraryPicker.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
  _libraryPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
  _libraryPicker.allowsEditing = YES;
  _libraryPicker.delegate = self;
  
  _cameraPicker = [[UIImagePickerController alloc] init];
  if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
    _cameraPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    _cameraPicker.navigationBar.tintColor = [UIColor whiteColor];
    _cameraPicker.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    _cameraPicker.allowsEditing = YES;
    _cameraPicker.delegate = self;
  }
  
  
  [_btnCamera addTarget:self action:@selector(onCamera) forControlEvents:UIControlEventTouchUpInside];
  [_btnLibrary addTarget:self action:@selector(onLibrary) forControlEvents:UIControlEventTouchUpInside];
  
  
  _btnAgreement = [[UIButton alloc] initWithFrame:CGRectMake(0, self.view.height-51, self.view.width, 51)];
  _btnAgreement.lblCustom = [UILabel initWithFrame:CGRectMake(0, 22, _btnAgreement.width, 9)
                                           bgColor:[UIColor clearColor]
                                         textColor:[UIColor whiteColor]
                                              text:@"使用See World＋ 即表示您同意See World＋的隱私條款  "
                                     textAlignment:NSTextAlignmentCenter
                                              font:[UIFont systemFontOfSize:9]];
  [_btnAgreement addSubview:_btnAgreement.lblCustom];
  [self.view addSubview:_btnAgreement];
  [_btnAgreement addTarget:self action:@selector(onAgreeClicked) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
  if ([string isEqualToString:@"\n"]) {
    [textField resignFirstResponder];
    return NO;
  }
  return YES;
}

- (void)onAgreeClicked{
  SWAgreementVC *vc = [[SWAgreementVC alloc] init];
  vc.url = SWURLAgreement;
  [self.navigationController pushViewController:vc animated:YES];
}

- (void)onGenderClick{
  [self.view endEditing:YES];
  __weak typeof(_btnGender)btnGender = _btnGender;
  __weak typeof(self)wSelf = self;
  
  SWActionSheetView *action = [[SWActionSheetView alloc] initWithFrame:[UIScreen mainScreen].bounds
                                                                 title:nil
                                                               content:@"男"];
  action.completeBlock = ^{
    btnGender.lblCustom.text = @"男";
    [wSelf checkInfoValid];
  };
  action.cancelBlock = ^{
    btnGender.lblCustom.text = @"女";
    [wSelf checkInfoValid];
  };
  [action.btnCancel setTitle:@"女" forState:UIControlStateNormal];
  [action.btnCancel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  [action show];
}

- (BOOL)checkInfoValid{
  BOOL isValid = _btnGender.lblCustom.text.length>0 && _txtName.text.length>0 && _avatarView.image;
  [_btnNext setBackgroundColor:[UIColor colorWithRGBHex:isValid?0x45d9e9:0x75bad1]];
  return isValid;
}

- (void)onNext{
  if (!_txtName.text.length) {
    [MBProgressHUD showTip:@"您的昵稱还没有填寫"];
  }else if (!_btnGender.lblCustom.text.length) {
    [MBProgressHUD showTip:@"您的性別還沒有選擇"];
  }else if (!_avatarView.image) {
    [MBProgressHUD showTip:@"您的大頭照還沒有上傳"];
  }
  if ([self checkInfoValid]) {
    GetQiniuTokenApi *api = [[GetQiniuTokenApi alloc] init];
    UIImage *avatar = _avatarView.image;
    NSString *phone = _phone;
    NSString *pwd = self.pwd;
    NSString *name = _txtName.text;
    NSInteger gender = [_btnGender.lblCustom.text isEqualToString:@"男"]?2:1;
    [api startWithModelClass:[GetQiniuTokenResponse class] completionBlock:^(ModelMessage *message) {
      if (message.isSuccess){
        GetQiniuTokenResponse *resp = message.object;
        NSString *token = resp.data;
        QNUploadManager *manager = [[QNUploadManager alloc] init];
        NSData *imageData = [avatar imageWithCompression:800.0];
        [manager putData:imageData key:[SWObject createUUID] token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
          if (info.ok && resp[@"key"]){
            NSString *imageURL = [NSString stringWithFormat:@"http:/7xlsvh.com1.z0.glb.clouddn.com/%@",[resp valueForKey:@"key"]];
            NSDictionary *dic = @{@"name":name,@"gender":D2IStr(gender),@"header":SStr(imageURL), @"username":phone ,@"password":pwd};
            LoginRequestApi *api = [[LoginRequestApi alloc] initWithDic:dic];
            api.requestType = LoginTypeRegist;
            [api startWithModelClass:[SWModel class] completionBlock:^(ModelMessage *message) {
              [SWHUD hideWaiting];
              if (message.isSuccess) {
                LoginRequestApi *loginApi = [[LoginRequestApi alloc] initWithUsername:phone
                                                                             password:pwd];
                loginApi.requestType = LoginTypeLogin;
                [loginApi startWithModelClass:[LoginResponse class] completionBlock:^(ModelMessage *message) {
                  [SWHUD hideWaiting];
                  if (message.isSuccess) {
                    TabViewController *tabVC = [[TabViewController alloc] init];
                    [UIApplication sharedApplication].keyWindow.rootViewController = tabVC;
                    [[NSUserDefaults standardUserDefaults] setSafeStringObject:((LoginResponse *)(message.object)).data.jwt
                                                                        forKey:@"jwt"];
                    [[NSUserDefaults standardUserDefaults] setSafeStringObject:((LoginResponse *)(message.object)).data.name
                                                                        forKey:@"userName"];
                    [[NSUserDefaults standardUserDefaults] setSafeStringObject:((LoginResponse *)(message.object)).data.userId
                                                                        forKey:@"userId"];
                    [[NSUserDefaults standardUserDefaults] setSafeStringObject:((LoginResponse *)(message.object)).data.rongToken
                                                                        forKey:@"rongToken"];
                    [[NSUserDefaults standardUserDefaults] setSafeStringObject:phone
                                                                        forKey:@"email"];
                    [[NSUserDefaults standardUserDefaults] setSafeStringObject:((LoginResponse *)(message.object)).data.head
                                                                        forKey:@"userPicUrl"];
                    [[NSUserDefaults standardUserDefaults] setSafeNumberObject:[NSNumber numberWithInt:((LoginResponse *)(message.object)).data.gender]
                                                                        forKey:@"userGender"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    [[SWConfigManager sharedInstance] getUser:((LoginResponse *)(message.object)).data.userId
                                              completionBlock:^(SWFeedUserItem *user) {
                                                [SWConfigManager sharedInstance].user = user;
                                              } failedBlock:^{
                                                
                                              }];
                    [[SWNoticeModel sharedInstance] syncGetuiCID];
                    [[SWChatModel sharedInstance] connect];
                  }
                }];
              }else{
                [SWHUD showCommonToast:(message.message.length == 0? @"注册失败":message.message)];
              }
            }];
          }else{
            [SWHUD hideWaiting];
            [SWHUD showCommonToast:(message.message.length == 0? @"注册失败":message.message)];
          }
        } option:nil];
      }else{
        [SWHUD hideWaiting];
        [SWHUD showCommonToast:(message.message.length == 0? @"注册失败":message.message)];
      }
    }];
    
    [SWHUD showWaiting];
  }
}

- (void)onCamera{
  [self presentViewController:_cameraPicker animated:YES completion:nil];
}

- (void)onLibrary{
  [self presentViewController:_libraryPicker animated:YES completion:nil];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
  [self dismissViewControllerAnimated:YES completion:nil];
  [self checkInfoValid];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
  [self dismissViewControllerAnimated:YES completion:nil];
  _avatarView.image = [info objectForKey:UIImagePickerControllerEditedImage];
  [self checkInfoValid];
}


@end
