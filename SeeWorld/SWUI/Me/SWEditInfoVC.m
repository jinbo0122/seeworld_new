//
//  SWEditInfoVC.m
//  SeeWorld
//
//  Created by Albert Lee on 16/11/2017.
//  Copyright © 2017 SeeWorld. All rights reserved.
//

#import "SWEditInfoVC.h"
#import "ModifyUserInfoApi.h"
@interface SWEditInfoVC ()<UITextFieldDelegate>
@property(nonatomic, strong)UITextField *txtField;
@end

@implementation SWEditInfoVC

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor colorWithRGBHex:0xe8edf3];
  self.navigationItem.titleView = [[ALTitleLabel alloc] initWithTitle:_titleText color:[UIColor colorWithRGBHex:NAV_BAR_COLOR_HEX]];
  self.navigationItem.rightBarButtonItem = [UIBarButtonItem loadBarButtonItemWithTitle:SWStringOkay
                                                                                 color:[UIColor colorWithRGBHex:NAV_BAR_COLOR_HEX]
                                                                                  font:[UIFont systemFontOfSize:16]
                                                                                target:self
                                                                                action:@selector(onDoneClick)];
  
  
  [self.view addSubview:[ALLineView lineWithFrame:CGRectMake(0, iOSNavHeight+10, self.view.width, 45) colorHex:0xffffff]];
  [self.view addSubview:[ALLineView lineWithFrame:CGRectMake(0, iOSNavHeight+10, self.view.width, 0.5) colorHex:0xc8c7cc]];
  [self.view addSubview:[ALLineView lineWithFrame:CGRectMake(0, iOSNavHeight+10+44.5, self.view.width, 0.5) colorHex:0xc8c7cc]];
  
  _txtField = [[UITextField alloc] initWithFrame:CGRectMake(10, iOSNavHeight + 10, UIScreenWidth-20, 45)];
  _txtField.font = [UIFont systemFontOfSize:17];
  _txtField.textColor = [UIColor colorWithRGBHex:0x4a4a4a];
  if ([_titleText isEqualToString:SWStringAboutMe]) {
    _txtField.text = [SWConfigManager sharedInstance].user.intro;
  }else if ([_titleText isEqualToString:SWStringNickName]) {
    _txtField.text = [SWConfigManager sharedInstance].user.name;
  }
  _txtField.delegate = self;
  _txtField.clearButtonMode = UITextFieldViewModeAlways;
  [self.view addSubview:_txtField];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
  if ([string isEqualToString:@"\n"]) {
    //request feedback
    [textField resignFirstResponder];
    return NO;
  }
  return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
  return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
  return YES;
}

- (BOOL)onDoneClick{
  if (![_txtField.text length]) {
    [SWHUD showCommonToast:@"不能為空"];
    return NO;
  }
  
  ModifyUserInfoApi *api = [[ModifyUserInfoApi alloc] init];
  if ([_titleText isEqualToString:SWStringAboutMe]) {
    api.intro = [SWConfigManager sharedInstance].user.intro;
    api.name = [SWConfigManager sharedInstance].user.name;
  }else if ([_titleText isEqualToString:SWStringNickName]) {
    api.name = [SWConfigManager sharedInstance].user.name;
    api.intro = [SWConfigManager sharedInstance].user.intro;
  }
  api.gender = [[SWConfigManager sharedInstance].user.gender integerValue];
  api.head = [SWConfigManager sharedInstance].user.picUrl;
  __weak typeof(self)wSelf = self;
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
      [wSelf.navigationController popViewControllerAnimated:YES];
    }else{
      [SWHUD showCommonToast:@"保存失败"];
    }
  } failure:^(YTKBaseRequest *request) {
    [SWHUD showCommonToast:@"保存失败"];
  }];
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
