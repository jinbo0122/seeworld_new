//
//  SWEditProfileVC.m
//  SeeWorld
//
//  Created by Albert Lee on 5/16/16.
//  Copyright © 2016 SeeWorld. All rights reserved.
//

#import "SWEditProfileVC.h"
#import "SWMineHeaderView.h"
#import "ModifyUserInfoApi.h"
#import "SWEditAvatarVC.h"
#import "SWEditCoverVC.h"
#import "SWActionSheetView.h"
@interface SWEditProfileVC ()<UITextFieldDelegate,SWMineHeaderViewDelegate>
@property(nonatomic, strong)SWMineHeaderView *header;

@property(nonatomic, strong)UIView  *editView;

@property(nonatomic, strong)UILabel *lblName;
@property(nonatomic, strong)UILabel *lblGender;

@property(nonatomic, strong)UITextField *txtName;
@property(nonatomic, strong)UIButton    *btnGender;

@property(nonatomic, strong)UIButton    *btnDone;

@end

@implementation SWEditProfileVC
- (void)viewDidAppear:(BOOL)animated{
  [super viewDidAppear:animated];
  [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
  [_header refreshWithUser:[SWConfigManager sharedInstance].user];
  _header.isEditMode = YES;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor colorWithRGBHex:0xe8edf3];
  [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
  self.navigationItem.titleView = [[ALTitleLabel alloc] initWithTitle:@"編輯個人資料" color:[UIColor colorWithRGBHex:NAV_BAR_COLOR_HEX]];
  
  _editView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, UIScreenHeight)];
  [self.view addSubview:_editView];
    
  _header = [[SWMineHeaderView alloc] initWithFrame:CGRectMake(0, iOSNavHeight, UIScreenWidth, 183)];
  [self.view addSubview:_header];
  [_header refreshWithUser:[SWConfigManager sharedInstance].user];
  _header.isEditMode = YES;
  _header.delegate = self;
  
  _lblName = [UILabel initWithFrame:CGRectMake(32, 330, 45, 16)
                            bgColor:[UIColor clearColor]
                          textColor:[UIColor colorWithRGBHex:0x191d28]
                               text:@"姓名"
                      textAlignment:NSTextAlignmentLeft
                               font:[UIFont systemFontOfSize:16]];
  [_editView addSubview:_lblName];
  
  _lblGender = [UILabel initWithFrame:CGRectMake(32, _lblName.bottom+50, 45, 16)
                              bgColor:[UIColor clearColor]
                            textColor:[UIColor colorWithRGBHex:0x191d28]
                                 text:@"性別"
                        textAlignment:NSTextAlignmentLeft
                                 font:[UIFont systemFontOfSize:16]];
  [_editView addSubview:_lblGender];
  
  
  [_editView addSubview:[ALLineView lineWithFrame:CGRectMake(32, _lblName.bottom+10, UIScreenWidth-64, 0.5) colorHex:0x7c8794]];
  [_editView addSubview:[ALLineView lineWithFrame:CGRectMake(32, _lblGender.bottom+10, UIScreenWidth-64, 0.5) colorHex:0x7c8794]];
  
  if (UIScreenHeight==480) {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(onDoneClick)];
  }else{
    _btnDone = [[UIButton alloc] initWithFrame:CGRectMake(30, UIScreenHeight-48-(UIScreenHeight==568?22:52), UIScreenWidth-60, 48)];
    [_btnDone setBackgroundColor:[UIColor colorWithRGBHex:0xffffff]];
    [_btnDone setTitle:@"完成" forState:UIControlStateNormal];
    [_btnDone setTitleColor:[UIColor colorWithRGBHex:NAV_BAR_COLOR_HEX] forState:UIControlStateNormal];
    [_btnDone.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [_editView addSubview:_btnDone];
    [_btnDone addTarget:self action:@selector(onDoneClick) forControlEvents:UIControlEventTouchUpInside];
  }
  
  _txtName = [[UITextField alloc] initWithFrame:CGRectMake(90, _lblName.top, UIScreenWidth-120, 16)];
  _txtName.font = [UIFont systemFontOfSize:16];
  _txtName.textColor = [UIColor colorWithRGBHex:0x191d28];
  _txtName.text = [SWConfigManager sharedInstance].user.name;
  [_editView addSubview:_txtName];
  
  _btnGender = [[UIButton alloc] initWithFrame:CGRectMake(90, _lblGender.top, UIScreenWidth-120, 16)];
  _btnGender.customImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_btnGender.width-20, 0, 11.5, 20)];
  _btnGender.customImageView.image = [UIImage imageNamed:@"setting_btn_enter"];
  [_editView addSubview:_btnGender];
  [_btnGender addSubview:_btnGender.customImageView];
  _btnGender.lblCustom = [UILabel initWithFrame:CGRectMake(0, 0, 100, 16)
                                        bgColor:[UIColor clearColor]
                                      textColor:[UIColor colorWithRGBHex:0x191d28]
                                           text:[[SWConfigManager sharedInstance].user.gender integerValue]==2?@"男":@"女"
                                  textAlignment:NSTextAlignmentLeft
                                           font:[UIFont systemFontOfSize:16]];
  [_btnGender addSubview:_btnGender.lblCustom];
  [_btnGender addTarget:self action:@selector(onGenderClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
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

- (void)onGenderClick{
  __weak typeof(_btnGender)btnGender = _btnGender;
  SWActionSheetView *action = [[SWActionSheetView alloc] initWithFrame:[UIScreen mainScreen].bounds
                                                                 title:nil
                                                               content:@"男"];
  action.completeBlock = ^{
    btnGender.lblCustom.text = @"男";
  };
  action.cancelBlock = ^{
    btnGender.lblCustom.text = @"女";
  };
  [action.btnCancel setTitle:@"女" forState:UIControlStateNormal];
  [action show];
}

- (void)mineHeaderViewDidNeedEditAvatar:(SWMineHeaderView *)header{
  SWEditAvatarVC *vc = [[SWEditAvatarVC alloc] init];
  UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
  [self presentViewController:nav animated:YES completion:nil];
}

- (void)mineHeaderViewDidNeedEditCover:(SWMineHeaderView *)header{
  SWEditCoverVC *vc = [[SWEditCoverVC alloc] init];
  UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
  [self presentViewController:nav animated:YES completion:nil];
}

- (void)onDoneClick{
  ModifyUserInfoApi *api = [[ModifyUserInfoApi alloc] init];
  api.name = _txtName.text;
  api.gender = [_btnGender.lblCustom.text isEqualToString:@"男"]? 2:1;
  api.head = [SWConfigManager sharedInstance].user.picUrl;
  api.intro = @"";
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
}

@end
