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
  self.view.backgroundColor = [UIColor colorWithRGBHex:0x1a2531];
  [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
  self.navigationItem.titleView = [[ALTitleLabel alloc] initWithTitle:@"回報問題" color:[UIColor colorWithRGBHex:NAV_BAR_COLOR_HEX]];

  _bgView = [[UIView alloc] initWithFrame:CGRectMake(26, iOSNavHeight+26, UIScreenWidth-52, UIScreenHeight==480?200:300)];
  _bgView.backgroundColor = [UIColor colorWithRGBHex:0x314153];
  [self.view addSubview:_bgView];
  
  _imageView = [[UIImageView alloc] initWithFrame:CGRectMake((_bgView.width-78)/2.0, 46, 78, 78)];
  _imageView.image = [UIImage imageNamed:@"setting_img"];
  [_bgView addSubview:_imageView];
  
  _lblPlaceHolder = [UILabel initWithFrame:CGRectMake(10, _imageView.bottom+25, _bgView.width-20, 35)
                                   bgColor:[UIColor clearColor]
                                 textColor:[UIColor colorWithRGBHex:0x6f8399]
                                      text:@"請在這裡填寫您對SeeWorld的意見\r我們將不斷地改進  感謝支持"
                             textAlignment:NSTextAlignmentCenter font:[UIFont systemFontOfSize:12] numberOfLines:2];
  [_bgView addSubview:_lblPlaceHolder];
  
  _lblWordCount = [UILabel initWithFrame:CGRectMake(15, _bgView.height-27, _bgView.width-30, 12)
                                   bgColor:[UIColor clearColor]
                                 textColor:[UIColor colorWithRGBHex:0x6f8399]
                                      text:@""
                             textAlignment:NSTextAlignmentRight
                                    font:[UIFont systemFontOfSize:12]];
  [_bgView addSubview:_lblWordCount];
  
  _txtView = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, _bgView.width-20, _bgView.height-50)];
  _txtView.textColor = [UIColor whiteColor];
  _txtView.font = [UIFont systemFontOfSize:16];
  [_bgView addSubview:_txtView];
  _txtView.delegate = self;
  _txtView.backgroundColor = [UIColor clearColor];
  
  _txtContact = [[UITextField alloc] initWithFrame:CGRectMake(26, _bgView.bottom+20, _bgView.width, 30)];
  _txtContact.attributedPlaceholder =  [[NSAttributedString alloc] initWithString:@"是否介意留下您的手機或郵箱"
                                                                       attributes:@{NSForegroundColorAttributeName: [UIColor colorWithRGBHex:0x596d80]}];
  _txtContact.textColor = [UIColor whiteColor];
  _txtContact.font = [UIFont systemFontOfSize:12];
  [_txtContact addSubview:[ALLineView lineWithFrame:CGRectMake(0, _txtContact.height-0.5, _txtContact.width, 0.5)
                                           colorHex:0x7c8794]];
  _txtContact.delegate = self;
  _btnSubmit = [[UIButton alloc] initWithFrame:CGRectMake(26, _txtContact.bottom+50, _bgView.width, 48)];
  [_btnSubmit setBackgroundColor:[UIColor colorWithRGBHex:0x1f6b86]];
  [_btnSubmit setTitle:@"提交" forState:UIControlStateNormal];
  [_btnSubmit setTitleColor:[UIColor colorWithRGBHex:0xfbfcfc] forState:UIControlStateNormal];
  [_btnSubmit.titleLabel setFont:[UIFont systemFontOfSize:16]];
  [self.view addSubview:_btnSubmit];
  [self.view addSubview:_txtContact];
  
  UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
  [self.view addGestureRecognizer:gesture];
  
  [_btnSubmit addTarget:self action:@selector(onSubmitClick) forControlEvents:UIControlEventTouchUpInside];
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
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
