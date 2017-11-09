//
//  SWSMSVerifyVC.m
//  SeeWorld
//
//  Created by Albert Lee on 13/10/2016.
//  Copyright © 2016 SeeWorld. All rights reserved.
//

#import "SWSMSVerifyVC.h"
#import "SWRegisterProfileVC.h"
#import <SMS_SDK/SMSSDK.h>
@interface SWSMSVerifyVC ()<UITextFieldDelegate>

@end

@implementation SWSMSVerifyVC{
  UIImageView *_bgView;
  
  UILabel *_lblTitle;
  UILabel *_lblPhone;
  
  UILabel *_lblCode[4];
  
  UIButton *_btnNext;
  UIButton *_btnResend;
  
  UITextField *_txtCode;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.navigationItem.titleView = [[ALTitleLabel alloc] initWithTitle:@"輸入驗證碼" color:[UIColor whiteColor]];
  
  _bgView = [[UIImageView alloc] initWithFrame:self.view.bounds];
  _bgView.image = [UIImage imageNamed:@"register_bg"];
  _bgView.contentMode = UIViewContentModeScaleAspectFill;
  [self.view addSubview:_bgView];
  
  _lblTitle = [UILabel initWithFrame:CGRectMake(0, iOSNavHeight+30, self.view.width, 13)
                             bgColor:[UIColor clearColor]
                           textColor:[UIColor whiteColor]
                                text:@"正在發送驗證碼，請稍等"
                       textAlignment:NSTextAlignmentCenter
                                font:[UIFont systemFontOfSize:13]];
  [self.view addSubview:_lblTitle];
  
  _lblPhone = [UILabel initWithFrame:CGRectMake(0, _lblTitle.bottom+10, self.view.width, 30)
                             bgColor:[UIColor clearColor]
                           textColor:[UIColor whiteColor]
                                text:[NSString stringWithFormat:@"+%@ %@",_prefix,_phone]
                       textAlignment:NSTextAlignmentCenter
                                font:[UIFont systemFontOfSize:21]];
  [self.view addSubview:_lblPhone];
  
  CGFloat width = 45;
  CGFloat gap   = (self.view.width-width*4-10)/5.0;
  CGFloat initX = gap+5;
  
  _txtCode = [[UITextField alloc] initWithFrame:CGRectMake(0, iOSNavHeight, self.view.width, 20)];
  [self.view addSubview:_txtCode];
  [_txtCode addTarget:self action:@selector(onTxtChanged:) forControlEvents:UIControlEventEditingChanged];
  _txtCode.keyboardType = UIKeyboardTypeNumberPad;
  _txtCode.delegate = self;
  _txtCode.returnKeyType = UIReturnKeyDone;
  _txtCode.textColor = [UIColor clearColor];
  _txtCode.tintColor = [UIColor clearColor];
  
  for (NSInteger i=0; i<4; i++) {
    _lblCode[i] =[UILabel initWithFrame:CGRectMake(initX + (width+gap)*i, _lblPhone.bottom+31, width, width)
                                bgColor:[UIColor whiteColor]
                              textColor:[UIColor colorWithRGBHex:0x4A90E2]
                                   text:@""
                          textAlignment:NSTextAlignmentCenter
                                   font:[UIFont systemFontOfSize:30]];
    [self.view addSubview:_lblCode[i]];
  }
  
  _btnNext = [[UIButton alloc] initWithFrame:CGRectMake(30, _lblCode[0].bottom+50, self.view.width-60, 50)];
  [_btnNext setBackgroundColor:[UIColor colorWithRGBHex:0x45D9E9]];
  [_btnNext setTitle:@"下一步" forState:UIControlStateNormal];
  [_btnNext setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  [_btnNext.titleLabel setFont:[UIFont systemFontOfSize:18]];
  [self.view addSubview:_btnNext];
  [_btnNext addTarget:self action:@selector(onNextClicked) forControlEvents:UIControlEventTouchUpInside];
  
  _btnResend = [[UIButton alloc] initWithFrame:CGRectMake(50, _btnNext.bottom, self.view.width-100, 40)];
  [_btnResend setTitle:@"重新獲取" forState:UIControlStateNormal];
  [_btnResend setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  [_btnResend.titleLabel setFont:[UIFont systemFontOfSize:13]];
  [self.view addSubview:_btnResend];
  [_btnResend addTarget:self action:@selector(onSendClicked:) forControlEvents:UIControlEventTouchUpInside];
  [_btnResend sendActionsForControlEvents:UIControlEventTouchUpInside];
  [_txtCode becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (void)onSendClicked:(UIButton *)button{
  __weak typeof(self)wSelf = self;
  [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS
                          phoneNumber:_phone
                                 zone:_prefix
                     customIdentifier:nil
                               result:^(NSError *error) {
                                 if (!error) {
                                   [wSelf setResendText:@59];
                                 }
                               }];
}

- (void)setResendText:(NSNumber *)number{
  _lblTitle.text = @"驗證碼已發送到手機";
  if ([number integerValue]<=0) {
    _btnResend.enabled = YES;
    [_btnResend setTitle:@"重新獲取" forState:UIControlStateNormal];
    return;
  }
  _btnResend.enabled = NO;
  [_btnResend setTitle:[NSString stringWithFormat:@"重新獲取驗證碼(%@s)",number] forState:UIControlStateNormal];
  [self performSelector:@selector(setResendText:) withObject:@([number integerValue]-1) afterDelay:1.0];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
  if ([string isEqualToString:@"\n"]) {
    [textField resignFirstResponder];
    return NO;
  }
  return YES;
}

- (void)onTxtChanged:(UITextField *)txtField{
  for (NSInteger i=0; i<4; i++) {
    if (txtField.text.length<=i) {
      _lblCode[i].text = @"";
    }else{
      _lblCode[i].text = [txtField.text substringWithRange:NSMakeRange(i, 1)];
    }
  }
}

- (void)onNextClicked{
  if (_txtCode.text.length>=4) {
    NSString *code = [_txtCode.text substringToIndex:4];
    __weak typeof(self)wSelf = self;
    [SMSSDK commitVerificationCode:code
                       phoneNumber:_phone
                              zone:_prefix
                            result:^(SMSSDKUserInfo *userInfo, NSError *error) {
                              if (!error) {
                                [wSelf registerDetail];
                              }else{
                                [MBProgressHUD showTip:@"驗證碼輸入有誤"];
                              }
                            }];
  }else{
    [MBProgressHUD showTip:@"請輸入驗證碼"];
  }
}

- (void)registerDetail{
  SWRegisterProfileVC *vc = [[SWRegisterProfileVC alloc] init];
  vc.phone = [_prefix stringByAppendingString:_phone];
  vc.pwd = _pwd;
  [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRGBHex:0x65a3b5]];
  [self.navigationController pushViewController:vc animated:YES];
  
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
