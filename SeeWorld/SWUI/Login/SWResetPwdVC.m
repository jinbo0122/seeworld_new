//
//  SWResetPwdVC.m
//  SeeWorld
//
//  Created by Albert Lee on 6/5/16.
//  Copyright © 2016 SeeWorld. All rights reserved.
//

#import "SWResetPwdVC.h"
#import "ResetPasswordsApi.h"
#import "CommonResponse.h"
@interface SWResetPwdVC ()<UITextFieldDelegate>

@end

@implementation SWResetPwdVC{
  UIImageView *_iconMail;
  UIImageView *_iconPwd;
  
  UITextField *_txtNewPwd;
  UITextField *_txtPwd;
  
  UIImageView *_iconCheckEmail;
  UIImageView *_iconCheckPwd;
  
  UIButton    *_btnLogin;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.navigationItem.titleView = [[ALTitleLabel alloc] initWithTitle:@"重置密碼" color:[UIColor colorWithRGBHex:NAV_BAR_COLOR_HEX]];
  
  _iconMail = [[UIImageView alloc] initWithFrame:CGRectMake(37, 146, 21, 24)];
  _iconMail.image = [UIImage imageNamed:@"signin_register_icon_password"];
  [self.view addSubview:_iconMail];
  
  _iconPwd = [[UIImageView alloc] initWithFrame:CGRectMake(37, _iconMail.bottom+34, 21, 24)];
  _iconPwd.image = [UIImage imageNamed:@"signin_register_icon_password"];
  [self.view addSubview:_iconPwd];
  
  [self.view addSubview:[ALLineView lineWithFrame:CGRectMake(30, _iconMail.bottom+9, self.view.width-60, 2) colorHex:0x494949]];
  [self.view addSubview:[ALLineView lineWithFrame:CGRectMake(30, _iconPwd.bottom+9, self.view.width-60, 2) colorHex:0x494949]];
  
  
  _txtNewPwd = [[UITextField alloc] initWithFrame:CGRectMake(79, _iconMail.top, UIScreenWidth-109, 20)];
  _txtNewPwd.font = [UIFont systemFontOfSize:16];
  _txtNewPwd.secureTextEntry = YES;
  _txtNewPwd.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"請輸入您的新密碼"
                                                                    attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRGBHex:0x8a9bac]}] ;
  _txtNewPwd.tintColor = [UIColor colorWithRGBHex:0x34414e];
  _txtNewPwd.textColor = [UIColor colorWithRGBHex:0x34414e];
  [self.view addSubview:_txtNewPwd];
  
  
  _txtPwd = [[UITextField alloc] initWithFrame:CGRectMake(_txtNewPwd.left, _iconPwd.top+5, UIScreenWidth-109, 20)];
  _txtPwd.secureTextEntry = YES;
  _txtPwd.font = [UIFont systemFontOfSize:16];
  _txtPwd.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"請確認您的新密碼"
                                                                  attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRGBHex:0x8a9bac]}] ;
  _txtPwd.tintColor = [UIColor colorWithRGBHex:0x34414e];
  _txtPwd.textColor = [UIColor colorWithRGBHex:0x34414e];
  [self.view addSubview:_txtPwd];
  
  _iconCheckEmail = [[UIImageView alloc] initWithFrame:CGRectMake(UIScreenWidth-30-18, _iconMail.bottom-15, 18, 18)];
  [self.view addSubview:_iconCheckEmail];
  
  _iconCheckPwd = [[UIImageView alloc] initWithFrame:CGRectMake(UIScreenWidth-30-18, _iconPwd.bottom-15, 18, 18)];
  [self.view addSubview:_iconCheckPwd];
  
  _txtNewPwd.returnKeyType = UIReturnKeyDone;
  _txtPwd.returnKeyType = UIReturnKeyDone;
  
  _txtNewPwd.delegate = self;
  _txtPwd.delegate = self;
  
  [_txtNewPwd addTarget:self action:@selector(textDidChange:) forControlEvents:UIControlEventEditingChanged];
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

}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)onLogin{
  if (_txtNewPwd.text.length == 0){
    [SWHUD showCommonToast:@"請輸入新密碼！"];
    return;
  }
  
  if (_txtNewPwd.text.length < 6)
  {
    [SWHUD showCommonToast:@"密碼不能少於6位！"];
    return;
  }
  
  if (![_txtNewPwd.text isEqualToString:_txtPwd.text]) {
    [SWHUD showCommonToast:@"新密碼兩次輸入不一致！"];
    return;
  }
  ResetPasswordsApi *api = [[ResetPasswordsApi alloc] init];
  api.secret = _secret;
  api.resetPassword = _txtPwd.text;
  api.type = @(_type);
  api.account = _account;
  [SWHUD showWaiting];
  __weak typeof(self)wSelf = self;
  [api startWithModelClass:[CommonResponse class] completionBlock:^(ModelMessage *message) {
    [SWHUD hideWaiting];
    if (message.isSuccess){
      [wSelf.view endEditing:YES];
      [SWHUD showCommonToast:@"修改密碼成功"];
      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [wSelf.navigationController popToRootViewControllerAnimated:YES];
      });
    }else{
      [SWHUD showCommonToast:(message.message.length == 0? @"修改密碼失敗":message.message)];
    }
  }];
}

- (void)dismiss{
  [self.view endEditing:YES];
}

- (void)textDidChange:(UITextField *)textField{
  [_btnLogin setBackgroundColor:[UIColor colorWithRGBHex:(_txtPwd.text.length&&_txtNewPwd.text.length && [_txtPwd.text isEqualToString:_txtNewPwd.text])?0x45d9e9:0x75bad1]];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
  if ([string isEqualToString:@"\n"]) {
    [textField resignFirstResponder];
    return NO;
  }
  return YES;
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
