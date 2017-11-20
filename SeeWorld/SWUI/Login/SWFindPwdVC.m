//
//  SWFindPwdVC.m
//  SeeWorld
//
//  Created by Albert Lee on 6/5/16.
//  Copyright © 2016 SeeWorld. All rights reserved.
//

#import "SWFindPwdVC.h"
#import "GetVerifycodeApi.h"
#import "CommonResponse.h"
#import "CheckVerifycodeApi.h"
#import "SWResetPwdVC.h"
#import "PDSelectSMSCodeVC.h"
#import <SMS_SDK/SMSSDK.h>
#import "SWDefine.h"
@interface SWFindPwdVC ()<UITextFieldDelegate,PDSelectSMSCodeVCDelegate>

@end

@implementation SWFindPwdVC{
  UIImageView *_iconMail;
  UIImageView *_iconCode;
  
  UITextField *_txtEmail;
  UITextField *_txtCode;
  
  UIImageView *_iconCheckEmail;
  
  UIButton    *_btnGetCode;
  UIButton    *_btnNext;
  
  UIButton    *_btnPhone;
  NSString    *_areaCode;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.navigationItem.titleView = [[ALTitleLabel alloc] initWithTitle:@"找回密碼" color:[UIColor colorWithRGBHex:NAV_BAR_COLOR_HEX]];
  
  _btnPhone = [[UIButton alloc] initWithFrame:CGRectMake(30, 20+iOSNavHeight, self.view.width-60, 35)];
  _btnPhone.lblCustom = [UILabel initWithFrame:_btnPhone.bounds
                                       bgColor:[UIColor clearColor]
                                     textColor:[UIColor colorWithRGBHex:0x34414e]
                                          text:DEFAULT_AREACODE_STR
                                 textAlignment:NSTextAlignmentLeft
                                          font:[UIFont systemFontOfSize:16]];
  [_btnPhone addSubview:_btnPhone.lblCustom];
  [self.view addSubview:_btnPhone];
  [self.view addSubview:[ALLineView lineWithFrame:CGRectMake(30, _btnPhone.bottom, self.view.width-60, 2) colorHex:0x494949]];
  
  _areaCode = DEFAULT_AREACODE;
  [_btnPhone addTarget:self action:@selector(onSelectCountry) forControlEvents:UIControlEventTouchUpInside];

  
  _iconMail = [[UIImageView alloc] initWithFrame:CGRectMake(37, 141, 22, 22)];
  _iconMail.image = [UIImage imageNamed:@"signin_register_icon_phone"];
  [self.view addSubview:_iconMail];
  
  _iconCode = [[UIImageView alloc] initWithFrame:CGRectMake(37, 314, 29, 14)];
  _iconCode.image = [UIImage imageNamed:@"forgetpassworld_icon"];
  [self.view addSubview:_iconCode];
  
  [self.view addSubview:[ALLineView lineWithFrame:CGRectMake(30, _iconMail.bottom+9, self.view.width-60, 2) colorHex:0x494949]];
  [self.view addSubview:[ALLineView lineWithFrame:CGRectMake(30, _iconCode.bottom+9, self.view.width-60, 2) colorHex:0x494949]];
  
  
  _txtEmail = [[UITextField alloc] initWithFrame:CGRectMake(79, _iconMail.top+1, UIScreenWidth-109, 20)];
  _txtEmail.font = [UIFont systemFontOfSize:16];
  _txtEmail.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"請輸入手機號碼或信箱"
                                                                    attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRGBHex:0x8a9bac]}] ;
  _txtEmail.tintColor = [UIColor colorWithRGBHex:0x34414e];
  _txtEmail.textColor = [UIColor colorWithRGBHex:0x34414e];
  _txtEmail.autocapitalizationType = UITextAutocapitalizationTypeNone;
  [self.view addSubview:_txtEmail];
  
  _iconCheckEmail = [[UIImageView alloc] initWithFrame:CGRectMake(UIScreenWidth-30-18, _iconMail.bottom-15, 18, 18)];
  [self.view addSubview:_iconCheckEmail];
  
  
  _txtCode = [[UITextField alloc] initWithFrame:CGRectMake(_txtEmail.left, _iconCode.top, UIScreenWidth-109, 20)];
  _txtCode.secureTextEntry = YES;
  _txtCode.font = [UIFont systemFontOfSize:16];
  _txtCode.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"請輸入您的驗證碼"
                                                                   attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRGBHex:0x8a9bac]}] ;
  _txtCode.tintColor = [UIColor colorWithRGBHex:0x34414e];
  _txtCode.textColor = [UIColor colorWithRGBHex:0x34414e];
  [self.view addSubview:_txtCode];
  
  _txtEmail.returnKeyType = UIReturnKeyDone;
  _txtCode.returnKeyType = UIReturnKeyDone;
  
  _txtEmail.delegate = self;
  _txtCode.delegate = self;
  
  [_txtEmail addTarget:self action:@selector(textDidChange:) forControlEvents:UIControlEventEditingChanged];
  [_txtCode addTarget:self action:@selector(textDidChange:) forControlEvents:UIControlEventEditingChanged];
  
  
  _btnGetCode = [[UIButton alloc] initWithFrame:CGRectMake(30, _iconMail.bottom+40, self.view.width-60, 48)];
  [_btnGetCode setBackgroundColor:[UIColor colorWithRGBHex:0x55acef]];
  [_btnGetCode setTitle:@"獲取驗證碼" forState:UIControlStateNormal];
  [_btnGetCode setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  [_btnGetCode.titleLabel setFont:[UIFont systemFontOfSize:16]];
  [self.view addSubview:_btnGetCode];
  [_btnGetCode addTarget:self action:@selector(onGetCode) forControlEvents:UIControlEventTouchUpInside];
  
  _btnGetCode.layer.masksToBounds = YES;
  _btnGetCode.layer.cornerRadius = 2.0;

  _btnNext = [[UIButton alloc] initWithFrame:CGRectMake(30, _iconCode.bottom+40, self.view.width-60, 48)];
  [_btnNext setBackgroundColor:[UIColor colorWithRGBHex:0x55acef]];
  [_btnNext setTitle:@"下一步" forState:UIControlStateNormal];
  [_btnNext setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  [_btnNext.titleLabel setFont:[UIFont systemFontOfSize:16]];
  [self.view addSubview:_btnNext];
  [_btnNext addTarget:self action:@selector(onNext) forControlEvents:UIControlEventTouchUpInside];
  
  _btnNext.layer.masksToBounds = YES;
  _btnNext.layer.cornerRadius = 2.0;

  UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
  [self.view addGestureRecognizer:gesture];
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

- (void)onSelectCountry{
  PDSelectSMSCodeVC *vc = [[PDSelectSMSCodeVC alloc] init];
  vc.delegate = self;
  [self.navigationController pushViewController:vc animated:YES];
}

- (void)smsDidReturnWithCountry:(NSString *)country code:(NSString *)code{
  _btnPhone.lblCustom.text = [NSString stringWithFormat:@"%@(%@)",country,code];
  _areaCode = [code copy];
}


- (void)textDidChange:(UITextField *)textField{
  BOOL isValid = [self isValidAccount:_txtEmail.text];
  _iconCheckEmail.image = isValid?[UIImage imageNamed:@"signin_register_icon_correct"]:nil;
  [_btnNext setBackgroundColor:[UIColor colorWithRGBHex:(_txtCode.text.length&&isValid)?0x45d9e9:0x88bdd0]];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
  if ([string isEqualToString:@"\n"]) {
    [textField resignFirstResponder];
    return NO;
  }
  return YES;
}

- (BOOL)isValidAccount:(NSString *)text{
  return [self isValidEmail:text]||[self isValidPhone:text];
}


- (BOOL)isValidEmail:(NSString *)checkString{
  BOOL stricterFilter = NO;
  NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
  NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
  NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
  NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
  return [emailTest evaluateWithObject:checkString];
}

- (BOOL)isValidPhone:(NSString *)text{
  BOOL isPhone = NO;
  NSCharacterSet* notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
  if ([text rangeOfCharacterFromSet:notDigits].location == NSNotFound){
    isPhone = YES;
  }
  return isPhone;
}

- (void)onGetCode{
  BOOL isEmail = [self isValidEmail:_txtEmail.text];
  BOOL isPhone = [self isValidPhone:_txtEmail.text];
  if (isEmail) {
    GetVerifycodeApi *api = [[GetVerifycodeApi alloc] init];
    api.email = _txtEmail.text;
    [SWHUD showWaiting];
    [api startWithModelClass:[CommonResponse class] completionBlock:^(ModelMessage *message) {
      [SWHUD hideWaiting];
      if (message.isSuccess){
        [SWHUD showCommonToast:@"请查看邮件获取验证码后输入验证码"];
      }else{
        [SWHUD showCommonToast:(message.message.length == 0? @"验证请求失败！":message.message)];
      }
    }];
  }else if (isPhone){
    __weak typeof(self)wSelf = self;
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS
                            phoneNumber:_txtEmail.text
                                   zone:[_areaCode substringFromIndex:1]
                       customIdentifier:nil
                                 result:^(NSError *error) {
                                   if (!error) {
                                     [wSelf setResendText:@59];
                                   }else{
                                     [MBProgressHUD showTip:@"驗證碼获取失败"];
                                   }
                                 }];
  }
}

- (void)setResendText:(NSNumber *)number{
  if ([number integerValue]<=0) {
    _btnGetCode.enabled = YES;
    [_btnGetCode setTitle:@"獲取驗證碼" forState:UIControlStateNormal];
    return;
  }
  _btnGetCode.enabled = NO;
  [_btnGetCode setTitle:[NSString stringWithFormat:@"重新獲取驗證碼(%@s)",number] forState:UIControlStateNormal];
  [self performSelector:@selector(setResendText:) withObject:@([number integerValue]-1) afterDelay:1.0];
}

- (void)onNext{
  BOOL isEmail = [self isValidEmail:_txtEmail.text];
  BOOL isPhone = [self isValidPhone:_txtEmail.text];
  if (isEmail&&_txtCode.text.length) {
    NSString *account = _txtEmail.text;
    CheckVerifycodeApi *api = [[CheckVerifycodeApi alloc] init];
    api.email = _txtEmail.text;
    api.code = _txtCode.text;
    
    [SWHUD showWaiting];
    [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
      [SWHUD hideWaiting];
      NSString *secret = [[[request.responseString safeJsonDicFromJsonString] safeDicObjectForKey:@"data"] safeStringObjectForKey:@"secret"];
      if (secret.length){
        SWResetPwdVC *vc = [[SWResetPwdVC alloc] init];
        vc.type = 0;
        vc.account = account;
        vc.secret = secret;
        [self.navigationController pushViewController:vc animated:YES];
      }else{
      }
    } failure:^(YTKBaseRequest *request) {
      [SWHUD hideWaiting];
    }];
  }else if(isPhone){
    __weak typeof(self)wSelf = self;
    NSString *account = [[_areaCode substringFromIndex:1] stringByAppendingString:_txtEmail.text];
    [SMSSDK commitVerificationCode:_txtCode.text
                       phoneNumber:_txtEmail.text
                              zone:[_areaCode substringFromIndex:1]
                            result:^(SMSSDKUserInfo *userInfo, NSError *error) {
                              if (!error) {
                                SWResetPwdVC *vc = [[SWResetPwdVC alloc] init];
                                vc.type = 1;
                                vc.secret = @"";
                                vc.account= account;
                                [wSelf.navigationController pushViewController:vc animated:YES];
                              }else{
                                [MBProgressHUD showTip:@"驗證碼輸入有誤"];
                              }
                            }];
  }
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
