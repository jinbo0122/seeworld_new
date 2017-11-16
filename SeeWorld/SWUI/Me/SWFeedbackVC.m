//
//  SWFeedbackVC.m
//  SeeWorld
//
//  Created by Albert Lee on 5/16/16.
//  Copyright © 2016 SeeWorld. All rights reserved.
//

#import "SWFeedbackVC.h"
#import "FeedbacksApi.h"
#import "CommonResponse.h"
@interface SWFeedbackVC ()<UITextViewDelegate,UITextFieldDelegate>

@end

@implementation SWFeedbackVC{
  UIView *_bgView;
  UITextView *_txtView;
  UIImageView *_imageView;
  UILabel *_lblPlaceHolder;
  UILabel *_lblWordCount;
  UITextField *_txtContact;
  UIButton *_btnSubmit;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor colorWithRGBHex:0xebedf3];
  [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
  self.navigationItem.titleView = [[ALTitleLabel alloc] initWithTitle:@"回報問題" color:[UIColor colorWithRGBHex:NAV_BAR_COLOR_HEX]];
  
  _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, iOSNavHeight+20, UIScreenWidth, UIScreenHeight==480?200:UIScreenWidth)];
  _bgView.backgroundColor = [UIColor colorWithRGBHex:0xffffff];
  [self.view addSubview:_bgView];
  
  _imageView = [[UIImageView alloc] initWithFrame:CGRectMake((_bgView.width-85)/2.0, 85, 85, 85)];
  _imageView.image = [UIImage imageNamed:@"setting_img"];
  [_bgView addSubview:_imageView];
  
  _lblPlaceHolder = [UILabel initWithFrame:CGRectMake(10, _imageView.bottom+18, _bgView.width-20, 40)
                                   bgColor:[UIColor clearColor]
                                 textColor:[UIColor colorWithRGBHex:0xbbdef9]
                                      text:@"請在這裡填寫您對SeeWorld的意見\r我們將不斷地改進  感謝支持"
                             textAlignment:NSTextAlignmentCenter font:[UIFont systemFontOfSize:14] numberOfLines:2];
  [_bgView addSubview:_lblPlaceHolder];
  
  _lblWordCount = [UILabel initWithFrame:CGRectMake(15, _bgView.height-27, _bgView.width-30, 12)
                                 bgColor:[UIColor clearColor]
                               textColor:[UIColor colorWithRGBHex:0x6f8399]
                                    text:@""
                           textAlignment:NSTextAlignmentRight
                                    font:[UIFont systemFontOfSize:12]];
  [_bgView addSubview:_lblWordCount];
  
  _txtView = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, _bgView.width-20, _bgView.height-50)];
  _txtView.textColor = [UIColor colorWithRGBHex:0x93a0ab];
  _txtView.font = [UIFont systemFontOfSize:16];
  [_bgView addSubview:_txtView];
  _txtView.delegate = self;
  _txtView.backgroundColor = [UIColor clearColor];
  
  _txtContact = [[UITextField alloc] initWithFrame:CGRectMake(0, _bgView.bottom+20, _bgView.width, 45)];
  _txtContact.backgroundColor = [UIColor whiteColor];
  
  
  NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
  style.alignment = NSTextAlignmentCenter;
  _txtContact.attributedPlaceholder =  [[NSAttributedString alloc] initWithString:@"是否介意留下您的手機或郵箱"
                                                                       attributes:@{NSForegroundColorAttributeName: [UIColor colorWithRGBHex:0x93a0ab],
                                                                                    NSFontAttributeName:[UIFont systemFontOfSize:14],
                                                                                    NSParagraphStyleAttributeName:style}];
  _txtContact.textColor = [UIColor colorWithRGBHex:0x93a0ab];
  _txtContact.font = [UIFont systemFontOfSize:14];
  [_txtContact addSubview:[ALLineView lineWithFrame:CGRectMake(0, _txtContact.height-0.5, _txtContact.width, 0.5)
                                           colorHex:0xc8c7cc]];
  [_txtContact addSubview:[ALLineView lineWithFrame:CGRectMake(0, 0.5, _txtContact.width, 0.5)
                                           colorHex:0xc8c7cc]];
  _txtContact.delegate = self;
  _btnSubmit = [[UIButton alloc] initWithFrame:CGRectMake(10, _txtContact.bottom+47.5, _bgView.width-30, 50)];
  [_btnSubmit setBackgroundColor:[UIColor colorWithRGBHex:0x55acef]];
  [_btnSubmit setTitle:@"提交" forState:UIControlStateNormal];
  [_btnSubmit setTitleColor:[UIColor colorWithRGBHex:0xffffff] forState:UIControlStateNormal];
  [_btnSubmit.titleLabel setFont:[UIFont systemFontOfSize:16]];
  _btnSubmit.layer.masksToBounds = YES;
  _btnSubmit.layer.cornerRadius  = 3.0;
  [self.view addSubview:_btnSubmit];
  [self.view addSubview:_txtContact];
  
  UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
  [self.view addGestureRecognizer:gesture];
  
  [_btnSubmit addTarget:self action:@selector(onSubmitClick) forControlEvents:UIControlEventTouchUpInside];
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(keyboardWillShow:)
                                               name:UIKeyboardWillShowNotification
                                             object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(keyboardWillBeHidden:)
                                               name:UIKeyboardWillHideNotification
                                             object:nil];
}

- (void)dismiss{
  [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)textViewDidChange:(UITextView *)textView{
  _imageView.hidden = _lblPlaceHolder.hidden = textView.text.length>0;
  _lblWordCount.text = [NSString stringWithFormat:@"%d/200",[NSString convertToInt:textView.text]];
  _lblWordCount.textColor = [UIColor colorWithRGBHex:[NSString convertToInt:textView.text]>200?0xf4453c:0x6f8399];
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
  if ([text isEqualToString:@"\n"]) {
    //request feedback
    [_txtView resignFirstResponder];
    return NO;
  }
  return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
  if ([string isEqualToString:@"\n"]) {
    //request feedback
    [_txtContact resignFirstResponder];
    return NO;
  }
  return YES;
}

- (void)keyboardWillShow:(NSNotification *)notification{
  NSDictionary* keyboardInfo  = [notification userInfo];
  NSNumber    * duration      = [keyboardInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
  NSNumber    * curve         = [keyboardInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
  CGRect keyboadFrame          = [[keyboardInfo valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
  
  if ([_txtContact isFirstResponder]) {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    _txtContact.bottom = CGRectGetMinY(keyboadFrame);
    [UIView commitAnimations];
  }
}


- (void)keyboardWillBeHidden:(NSNotification *)notification{
  NSDictionary* keyboardInfo  = [notification userInfo];
  NSNumber    * duration      = [keyboardInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
  NSNumber    * curve         = [keyboardInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
  if ([_txtContact isFirstResponder]) {
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    _txtContact.top = _bgView.bottom+20;
    [UIView commitAnimations];
  }
}


- (void)onSubmitClick{
  if ([NSString convertToInt:_txtView.text]>200) {
    [MBProgressHUD showTip:@"不得超過200字"];
  }else if (_txtView.text.length==0){
    [MBProgressHUD showTip:@"不能为空"];
  }
  
  FeedbacksApi *api = [[FeedbacksApi alloc] init];
  api.content = _txtView.text;
  api.contact = _txtContact.text;
  
  [SWHUD showWaiting];
  __weak typeof(self)wSelf = self;
  [api startWithModelClass:[CommonResponse class] completionBlock:^(ModelMessage *message) {
    [SWHUD hideWaiting];
    if (message.isSuccess){
      [self.view endEditing:YES];
      [SWHUD showCommonToast:@"意见反馈成功"];
      [wSelf.navigationController popViewControllerAnimated:YES];
    }else{
      [SWHUD showCommonToast:(message.message.length == 0? @"意见反馈失败":message.message)];
    }
  }];
}

- (void)dealloc{
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
