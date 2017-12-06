//
//  SWRegisterVC.m
//  SeeWorld
//
//  Created by Albert Lee on 6/5/16.
//  Copyright © 2016 SeeWorld. All rights reserved.
//

#import "SWRegisterVC.h"
#import "ResetPasswordsApi.h"
#import "CommonResponse.h"
#import "SWRegisterProfileVC.h"
#import "SWAgreementVC.h"
#import "PDSelectSMSCodeVC.h"
#import "SWRegisterCheckPhoneAPI.h"
#import "SWSMSVerifyVC.h"
#import "SWDefine.h"
@interface SWRegisterVC ()<UITextFieldDelegate,PDSelectSMSCodeVCDelegate>

@end

@implementation SWRegisterVC{
  UIButton    *_btnPhone;
  UITextField *_txtPhone;
  UITextField *_txtPwd;
  
  UIImageView *_iconCheckPhone;
  UIImageView *_iconCheckPwd;
  UIImageView *_iconMail;
  UIImageView *_iconPwd;
  
  UIButton    *_btnLogin;
  
  NSString    *_areaCode;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.navigationItem.titleView = [[ALTitleLabel alloc] initWithTitle:@"註冊" color:[UIColor colorWithRGBHex:NAV_BAR_COLOR_HEX]];
  
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
                                          font:[UIFont systemFontOfSize:18]];
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
  
  _txtPhone = [[UITextField alloc] initWithFrame:CGRectMake(73, _btnPhone.bottom+10, UIScreenWidth-109, 55)];
  _txtPhone.font = [UIFont systemFontOfSize:18];
  _txtPhone.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"輸入手機號碼"
                                                                   attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRGBHex:0x8a9bac]}] ;
  _txtPhone.tintColor = [UIColor colorWithRGBHex:0x34414e];
  _txtPhone.textColor = [UIColor colorWithRGBHex:0x34414e];
  _txtPhone.autocapitalizationType = UITextAutocapitalizationTypeNone;
  _txtPhone.keyboardType = UIKeyboardTypePhonePad;
  [self.view addSubview:_txtPhone];
  
  
  _txtPwd = [[UITextField alloc] initWithFrame:CGRectMake(_txtPhone.left, _txtPhone.bottom, _txtPhone.width, _txtPhone.height)];
  _txtPwd.secureTextEntry = YES;
  _txtPwd.font = [UIFont systemFontOfSize:18];
  _txtPwd.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"輸入密碼，長度不小於6位"
                                                                  attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRGBHex:0x8a9bac]}] ;
  _txtPwd.tintColor = [UIColor colorWithRGBHex:0x34414e];
  _txtPwd.textColor = [UIColor colorWithRGBHex:0x34414e];
  [self.view addSubview:_txtPwd];
  
  [self.view addSubview:[ALLineView lineWithFrame:CGRectMake(30,_btnPhone.bottom-2, self.view.width-60, 2) colorHex:0x494949]];
  [self.view addSubview:[ALLineView lineWithFrame:CGRectMake(30, _txtPhone.bottom-2, self.view.width-60, 2) colorHex:0x494949]];
  [self.view addSubview:[ALLineView lineWithFrame:CGRectMake(30, _txtPwd.bottom-2, self.view.width-60, 2) colorHex:0x494949]];

  
  _iconCheckPhone = [[UIImageView alloc] initWithFrame:CGRectMake(UIScreenWidth-30-18, _btnPhone.bottom+(55-18)/2.0, 18, 18)];
  [self.view addSubview:_iconCheckPhone];
  
  _iconCheckPwd = [[UIImageView alloc] initWithFrame:CGRectMake(UIScreenWidth-30-18, _txtPhone.bottom+(55-18)/2.0, 18, 18)];
  [self.view addSubview:_iconCheckPwd];
  
  _txtPhone.returnKeyType = UIReturnKeyDone;
  _txtPwd.returnKeyType = UIReturnKeyDone;
  
  _txtPhone.delegate = self;
  _txtPwd.delegate = self;
  
  [_txtPhone addTarget:self action:@selector(textDidChange:) forControlEvents:UIControlEventEditingChanged];
  [_txtPwd addTarget:self action:@selector(textDidChange:) forControlEvents:UIControlEventEditingChanged];
  
  _btnLogin = [[UIButton alloc] initWithFrame:CGRectMake(30, 346, self.view.width-60, 48)];
  [_btnLogin setBackgroundColor:[UIColor colorWithRGBHex:0x55acef]];
  [_btnLogin setTitle:@"下一步" forState:UIControlStateNormal];
  [_btnLogin setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  [_btnLogin.titleLabel setFont:[UIFont systemFontOfSize:16]];
  _btnLogin.layer.masksToBounds = YES;
  _btnLogin.layer.cornerRadius = 2.5;
  [self.view addSubview:_btnLogin];
  [_btnLogin addTarget:self action:@selector(onRegister) forControlEvents:UIControlEventTouchUpInside];
  
  UILabel *lblTermTitle = [UILabel initWithFrame:CGRectMake(10, self.view.height-40-iphoneXBottomAreaHeight, UIScreenWidth-20, 12)
                                         bgColor:[UIColor clearColor]
                                       textColor:[UIColor colorWithRGBHex:0x8e8e8e]
                                            text:@"使用SeeWorld+，即表示你同意SeeWorld+的"
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
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
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

- (void)onTermClicked{
  ALWebVC *vc = [[ALWebVC alloc] init];
  vc.url = SWURLAgreement;
  [self.navigationController pushViewController:vc animated:YES];
}

- (void)onRegister{
  if (![self isValidPhone:_txtPhone.text]){
    [SWHUD showCommonToast:@"請輸入正確的手機號碼！"];
    return;
  }
  
  if (_txtPwd.text.length < 6){
    [SWHUD showCommonToast:@"密碼不能少於6位！"];
    return;
  }
  PDProgressHUD *hud = [PDProgressHUD showLoadingInView:self.view];
  __weak typeof(self)wSelf = self;
  SWRegisterCheckPhoneAPI *api = [[SWRegisterCheckPhoneAPI alloc] init];
  api.tel = [[_areaCode substringFromIndex:1] stringByAppendingString:_txtPhone.text];
  [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
    [hud removeFromSuperview];
    if ([[[[request.responseString safeJsonDicFromJsonString] safeDicObjectForKey:@"data"] safeNumberObjectForKey:@"available"] boolValue]) {
      SWSMSVerifyVC *vc = [[SWSMSVerifyVC alloc] init];
      vc.prefix = [_areaCode substringFromIndex:1];
      vc.phone  = _txtPhone.text;
      vc.pwd    = _txtPwd.text;
      [wSelf.navigationController pushViewController:vc animated:YES];
    }else{
      __weak typeof(self)wSelf = self;
      [[[UIAlertView alloc] initWithTitle:@"該手機號碼已註冊，是否前去登錄？" message:nil
                         cancelButtonItem:[RIButtonItem itemWithLabel:SWStringCancel]
                         otherButtonItems:[RIButtonItem itemWithLabel:@"去登陸" action:^{
        [wSelf.navigationController popViewControllerAnimated:YES];
      }], nil] show];
    }
  } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
    [hud removeFromSuperview];
    [MBProgressHUD showTip:@"請求失敗"];
  }];

}

- (void)dismiss{
  [self.view endEditing:YES];
}

- (BOOL)isValidPhone:(NSString *)text{
  BOOL isPhone = NO;
  NSCharacterSet* notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
  if ([_txtPhone.text rangeOfCharacterFromSet:notDigits].location == NSNotFound){
    isPhone = YES;
  }
  return isPhone;
}

- (void)textDidChange:(UITextField *)textField{
  BOOL isPhone = [self isValidPhone:_txtPhone.text];
  _iconCheckPhone.image = isPhone?[UIImage imageNamed:@"signin_register_icon_correct"]:nil;
  if ([textField isEqual:_txtPwd]) {
    _iconCheckPwd.image = _txtPwd.text.length>6?[UIImage imageNamed:@"signin_register_icon_correct"]:nil;
  }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
  if ([string isEqualToString:@"\n"]) {
    [textField resignFirstResponder];
    return NO;
  }
  return YES;
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
@end
