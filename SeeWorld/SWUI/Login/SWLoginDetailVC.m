//
//  SWLoginDetailVC.m
//  SeeWorld
//
//  Created by Albert Lee on 6/5/16.
//  Copyright © 2016 SeeWorld. All rights reserved.
//

#import "SWLoginDetailVC.h"
#import "LoginRequestApi.h"
#import "LoginResponse.h"
#import "SWFindPwdVC.h"
#import "SWRegisterVC.h"
#import "WeiboSDK.h"
#import "SWLoginFBAPI.h"
#import "SWAgreementVC.h"
#import "PDSelectSMSCodeVC.h"
#import "SWRegisterCheckPhoneAPI.h"
#import "SWSMSVerifyVC.h"
#import "SWDefine.h"
@interface SWLoginDetailVC ()<UITextFieldDelegate,PDSelectSMSCodeVCDelegate>

@end

@implementation SWLoginDetailVC{
  UIImageView *_iconMail;
  UIImageView *_iconPwd;
  
  UITextField *_txtEmail;
  UITextField *_txtPwd;
  
  UIImageView *_iconCheckEmail;
  UIImageView *_iconCheckPwd;
  
  UIButton    *_btnLogin;
  UIButton    *_btnForget;
  
  UIButton    *_btnRegister;
  UILabel     *_lblRegister;
  
  UIButton    *_btnFB;
  UIButton    *_btnWeibo;
  
  UIButton    *_btnPhone;
  NSString    *_areaCode;

}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.navigationItem.titleView = [[ALTitleLabel alloc] initWithTitle:@"登入" color:[UIColor colorWithRGBHex:NAV_BAR_COLOR_HEX]];
  
  _btnPhone = [[UIButton alloc] initWithFrame:CGRectMake(30, 30+iOSNavHeight, self.view.width-60, 35)];
  _btnPhone.customImageView = [[UIImageView alloc] initWithFrame:CGRectMake(7, 6, 22, 22)];
  _btnPhone.customImageView.image = [UIImage imageNamed:@"country"];
  [_btnPhone addSubview:_btnPhone.customImageView];
  _btnPhone.lblCustom = [UILabel initWithFrame:CGRectMake(_btnPhone.customImageView.right + 13, 0,
                                                          _btnPhone.width-_btnPhone.customImageView.right, _btnPhone.height)
                                       bgColor:[UIColor clearColor]
                                     textColor:[UIColor colorWithRGBHex:0x34414e]
                                          text:DEFAULT_AREACODE_STR
                                 textAlignment:NSTextAlignmentLeft
                                          font:[UIFont systemFontOfSize:16]];
  [_btnPhone addSubview:_btnPhone.lblCustom];
  [self.view addSubview:_btnPhone];
  
  _areaCode = DEFAULT_AREACODE;
  [_btnPhone addTarget:self action:@selector(onSelectCountry) forControlEvents:UIControlEventTouchUpInside];

  _iconMail = [[UIImageView alloc] initWithFrame:CGRectMake(37, _btnPhone.bottom+55-30, 22, 22)];
  _iconMail.image = [UIImage imageNamed:@"signin_register_icon_phone"];
  [self.view addSubview:_iconMail];
  
  _iconPwd = [[UIImageView alloc] initWithFrame:CGRectMake(37, _btnPhone.bottom+55*2-30, 22, 22)];
  _iconPwd.image = [UIImage imageNamed:@"signin_register_icon_password"];
  [self.view addSubview:_iconPwd];
  
  [self.view addSubview:[ALLineView lineWithFrame:CGRectMake(30, _btnPhone.bottom, self.view.width-60, 2) colorHex:0x494949]];
  [self.view addSubview:[ALLineView lineWithFrame:CGRectMake(30, _btnPhone.bottom+55, self.view.width-60, 2) colorHex:0x494949]];
  [self.view addSubview:[ALLineView lineWithFrame:CGRectMake(30, _btnPhone.bottom+55*2, self.view.width-60, 2) colorHex:0x494949]];
  
  
  _txtEmail = [[UITextField alloc] initWithFrame:CGRectMake(73, _iconMail.top+1, UIScreenWidth-109, 20)];
  _txtEmail.font = [UIFont systemFontOfSize:16];
  _txtEmail.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"輸入手機號碼或信箱"
                                                                    attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRGBHex:0x8a9bac]}] ;
  _txtEmail.tintColor = [UIColor colorWithRGBHex:0x34414e];
  _txtEmail.textColor = [UIColor colorWithRGBHex:0x34414e];
  _txtEmail.autocapitalizationType = UITextAutocapitalizationTypeNone;
  [self.view addSubview:_txtEmail];
  
  
  _txtPwd = [[UITextField alloc] initWithFrame:CGRectMake(_txtEmail.left, _iconPwd.top+1, UIScreenWidth-109, 20)];
  _txtPwd.secureTextEntry = YES;
  _txtPwd.font = [UIFont systemFontOfSize:16];
  _txtPwd.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"輸入登入密碼"
                                                                  attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRGBHex:0x8a9bac]}] ;
  _txtPwd.tintColor = [UIColor colorWithRGBHex:0x34414e];
  _txtPwd.textColor = [UIColor colorWithRGBHex:0x34414e];
  [self.view addSubview:_txtPwd];
  
  _iconCheckEmail = [[UIImageView alloc] initWithFrame:CGRectMake(UIScreenWidth-30-18, _iconMail.bottom-15, 18, 18)];
  [self.view addSubview:_iconCheckEmail];
  
  _iconCheckPwd = [[UIImageView alloc] initWithFrame:CGRectMake(UIScreenWidth-30-18, _iconPwd.bottom-15, 18, 18)];
  [self.view addSubview:_iconCheckPwd];
  
  _txtEmail.returnKeyType = UIReturnKeyDone;
  _txtPwd.returnKeyType = UIReturnKeyDone;
  
  _txtEmail.delegate = self;
  _txtPwd.delegate = self;
  
  [_txtEmail addTarget:self action:@selector(textDidChange:) forControlEvents:UIControlEventEditingChanged];
  [_txtPwd addTarget:self action:@selector(textDidChange:) forControlEvents:UIControlEventEditingChanged];
  
  _btnLogin = [[UIButton alloc] initWithFrame:CGRectMake(30, _iconPwd.bottom+72, self.view.width-60, 48)];
  [_btnLogin setBackgroundColor:[UIColor colorWithRGBHex:0x55acef]];
  [_btnLogin setTitle:@"登入" forState:UIControlStateNormal];
  [_btnLogin setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  [_btnLogin.titleLabel setFont:[UIFont systemFontOfSize:16]];
  [self.view addSubview:_btnLogin];
  [_btnLogin addTarget:self action:@selector(onLogin) forControlEvents:UIControlEventTouchUpInside];
  
  _btnLogin.layer.masksToBounds = YES;
  _btnLogin.layer.cornerRadius = 2.0;
  
  
  _btnForget = [[UIButton alloc] initWithFrame:CGRectMake(self.view.width-30-70, _btnLogin.bottom, 70, 30)];
  [_btnForget setTitle:@"忘記密碼？" forState:UIControlStateNormal];
  [_btnForget setTitleColor:[UIColor colorWithRGBHex:0x8e8e8e] forState:UIControlStateNormal];
  [_btnForget.titleLabel setFont:[UIFont systemFontOfSize:12]];
  [self.view addSubview:_btnForget];
  [_btnForget addTarget:self action:@selector(onForget) forControlEvents:UIControlEventTouchUpInside];
  
  _lblRegister = [UILabel initWithFrame:CGRectMake(0, _btnLogin.bottom+79, self.view.width, 12)
                                bgColor:[UIColor clearColor]
                              textColor:[UIColor whiteColor]
                                   text:@"還沒有SeeWorld帳號？"
                          textAlignment:NSTextAlignmentCenter
                                   font:[UIFont systemFontOfSize:12]];
  [self.view addSubview:_lblRegister];
  
  _btnRegister = [[UIButton alloc] initWithFrame:CGRectMake(0, _lblRegister.bottom, self.view.width, 30)];
  [_btnRegister setTitle:@"立即註冊" forState:UIControlStateNormal];
  [_btnRegister.titleLabel setFont:[UIFont systemFontOfSize:14]];
  [self.view addSubview:_btnRegister];
  [_btnRegister addTarget:self action:@selector(onRegister) forControlEvents:UIControlEventTouchUpInside];
  _lblRegister.hidden = _btnRegister.hidden = UIScreenHeight==480;
  
  
  _btnFB = [[UIButton alloc] initWithFrame:CGRectMake((self.view.width-115)/2.0, self.view.height-132-iphoneXBottomAreaHeight, 40, 40)];
  [_btnFB setImage:[UIImage imageNamed:@"signinr_btn_fb"] forState:UIControlStateNormal];
  [self.view addSubview:_btnFB];
  
  
  _btnWeibo = [[UIButton alloc] initWithFrame:CGRectMake(_btnFB.right+35, _btnFB.top, 40, 40)];
  [_btnWeibo setImage:[UIImage imageNamed:@"signinr_btn_wibo"] forState:UIControlStateNormal];
  [self.view addSubview:_btnWeibo];
  
  [_btnWeibo addTarget:self action:@selector(onWeibo) forControlEvents:UIControlEventTouchUpInside];
  [_btnFB addTarget:self action:@selector(onFB) forControlEvents:UIControlEventTouchUpInside];
  
  
  UILabel *intro = [UILabel initWithFrame:CGRectMake(0, _btnWeibo.bottom+13, self.view.width, 12)
                                  bgColor:[UIColor clearColor]
                                textColor:[UIColor colorWithRGBHex:0x55acef]
                                     text:@"第三方登入"
                            textAlignment:NSTextAlignmentCenter
                                     font:[UIFont systemFontOfSize:12]];
  [self.view addSubview:intro];
  
  UILabel *lblTermTitle = [UILabel initWithFrame:CGRectMake(10, self.view.height-40-iphoneXBottomAreaHeight, UIScreenWidth-20, 12)
                                         bgColor:[UIColor clearColor]
                                       textColor:[UIColor colorWithRGBHex:0x8e8e8e]
                                            text:@"使用SeeWorld+，即表示你同意SeeWorld的+"
                                   textAlignment:NSTextAlignmentCenter
                                            font:[UIFont systemFontOfSize:12]];
  [self.view addSubview:lblTermTitle];
  
  UIButton *btnTerm = [[UIButton alloc] initWithFrame:CGRectMake(0, lblTermTitle.bottom, UIScreenWidth, 26)];
  
  UILabel *lblTerm = [UILabel initWithFrame:CGRectMake(10, 7, UIScreenWidth-20, 12)
                                    bgColor:[UIColor clearColor]
                                  textColor:[UIColor colorWithRGBHex:0x8e8e8e]
                                       text:@"使用條款和隱私策略"
                              textAlignment:NSTextAlignmentCenter
                                       font:[UIFont systemFontOfSize:12]];
  [self.view addSubview:btnTerm];
  [btnTerm addSubview:lblTerm];
  [btnTerm addTarget:self action:@selector(onTermClicked) forControlEvents:UIControlEventTouchUpInside];
  
  UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
  [self.view addGestureRecognizer:gesture];
}

- (void)onTermClicked{
  SWAgreementVC *vc = [[SWAgreementVC alloc] init];
  vc.url = SWURLAgreement;
  [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated{
  [super viewWillDisappear:animated];
  if ([self isMovingFromParentViewController]) {
    [self.navigationController setNavigationBarHidden:YES];
  }
}

- (void)viewWillAppear:(BOOL)animated{
  [super viewWillAppear:animated];
  [self.navigationController setNavigationBarHidden:NO];
}

- (void)dismiss{
  [self.view endEditing:YES];
}

- (void)textDidChange:(UITextField *)textField{
  BOOL isEmail = [self isValidAccount:_txtEmail.text];
  _iconCheckEmail.image = isEmail?[UIImage imageNamed:@"signin_register_icon_correct"]:nil;
  if ([textField isEqual:_txtPwd]) {
    _iconCheckPwd.image = nil;
  }
  _txtPwd.textColor = [UIColor colorWithRGBHex:0x34414e];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
  if ([string isEqualToString:@"\n"]) {
    [textField resignFirstResponder];
    return NO;
  }
  return YES;
}

- (void)onSelectCountry{
  PDSelectSMSCodeVC *vc = [[PDSelectSMSCodeVC alloc] init];
  vc.delegate = self;
  [self.navigationController pushViewController:vc animated:YES];
}

- (void)smsDidReturnWithCountry:(NSString *)country code:(NSString *)code{
  _btnPhone.lblCustom.text = [NSString stringWithFormat:@"%@(%@)",country,code];
  _areaCode = [code copy];
}

- (BOOL)isValidAccount:(NSString *)text{
  return [self isValidEmail:text]||[self isValidPhone:text];
}


- (BOOL)isValidPhone:(NSString *)text{
  BOOL isPhone = NO;
  NSCharacterSet* notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
  if ([text rangeOfCharacterFromSet:notDigits].location == NSNotFound){
    isPhone = YES;
  }
  return isPhone;
}

- (BOOL)isValidEmail:(NSString *)checkString{
  BOOL stricterFilter = NO;
  NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
  NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
  NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
  NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
  return [emailTest evaluateWithObject:checkString];
}


- (void)onLogin{
  BOOL isEmail = [self isValidAccount:_txtEmail.text];
  if (_txtPwd.text.length&&isEmail) {
    NSString *email = _txtEmail.text;
    BOOL isPhoneLogin = [self isValidPhone:email];
    if (isPhoneLogin) {
      email = [NSString stringWithFormat:@"%@%@",[_areaCode substringFromIndex:1],_txtEmail.text];
    }
    LoginRequestApi *api = [[LoginRequestApi alloc] initWithUsername:email
                                                            password:_txtPwd.text];
    api.requestType = LoginTypeLogin;
    __weak typeof(_iconCheckPwd)iconPwd = _iconCheckPwd;
    __weak typeof(_txtPwd)txtPwd = _txtPwd;
    __weak typeof(_txtEmail)txtEmail = _txtEmail;
    __weak typeof(self)wSelf = self;
    [api startWithModelClass:[LoginResponse class] completionBlock:^(ModelMessage *message) {
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
        [[NSUserDefaults standardUserDefaults] setSafeStringObject:email
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
      }else{
        iconPwd.image = [UIImage imageNamed:@"signin_register_icon_error"];
        [PDProgressHUD showTip:@"您的密碼輸入有誤"];
        if (isPhoneLogin) {
          SWRegisterCheckPhoneAPI *api = [[SWRegisterCheckPhoneAPI alloc] init];
          api.tel = email;
          [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            if ([[[[request.responseString safeJsonDicFromJsonString] safeDicObjectForKey:@"data"] safeNumberObjectForKey:@"available"] boolValue]) {
              [[[UIAlertView alloc] initWithTitle:@"該手機號碼尚未註冊，是否立即註冊"
                                         message:nil
                                cancelButtonItem:[RIButtonItem itemWithLabel:SWStringCancel]
                                 otherButtonItems:[RIButtonItem itemWithLabel:@"去註冊" action:^{
                SWSMSVerifyVC *vc = [[SWSMSVerifyVC alloc] init];
                vc.prefix = [_areaCode substringFromIndex:1];
                vc.phone  = txtEmail.text;
                vc.pwd    = txtPwd.text;
                [wSelf.navigationController pushViewController:vc animated:YES];
              }], nil] show];
            }
          } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            [MBProgressHUD showTip:@"請求失敗"];
          }];
        }
      }
    }];
  }
}

- (void)onForget{
  SWFindPwdVC *vc = [[SWFindPwdVC alloc] init];
  [self.navigationController pushViewController:vc animated:YES];
}

- (void)onRegister{
  SWRegisterVC *vc = [[SWRegisterVC alloc] init];
  [self.navigationController pushViewController:vc animated:YES];
}

- (void)onFB{
  MBProgressHUD *hud = [MBProgressHUD showLoadingInView:self.view];
  FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
  [login logOut];
  [login logInWithReadPermissions: @[@"public_profile"]
               fromViewController:self
                          handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
                            if (!error && !result.isCancelled) {
                              NSString *openid = result.token.userID;
                              NSString *token = result.token.tokenString;
                              [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields":@"id,name,gender,picture.width(500).height(500)"}]
                               startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                                 if (!error) {
                                   NSLog(@"fetched user:%@", result);
                                   SWLoginFBAPI *api = [[SWLoginFBAPI alloc] init];
                                   api.name = [(NSDictionary *)result safeStringObjectForKey:@"name"];
                                   api.gender = [[(NSDictionary *)result safeStringObjectForKey:@"gender"] isEqualToString:@"male"]?@2:@1;
                                   api.head = [[[(NSDictionary *)result safeDicObjectForKey:@"picture"] safeDicObjectForKey:@"data"] safeStringObjectForKey:@"url"];
                                   api.openid = openid;
                                   api.token = token;
                                   [SWHUD showWaiting];
                                   [api startWithModelClass:[LoginResponse class] completionBlock:^(ModelMessage *message) {
                                     [SWHUD hideWaiting];
                                     [hud removeFromSuperview];
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
                                     }else{
                                       [SWHUD showCommonToast:@"登錄失敗"];
                                     }
                                   }];
                                 }else{
                                   [hud removeFromSuperview];
                                 }
                               }];
                            }else{
                              [hud removeFromSuperview];
                            }
                          }];
}

- (void)onWeibo{
  WBAuthorizeRequest *req = [[WBAuthorizeRequest alloc] init];
  req.redirectURI = SWWeiboRedirectURL;
  req.scope = @"all";
  [WeiboSDK sendRequest:req];
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
