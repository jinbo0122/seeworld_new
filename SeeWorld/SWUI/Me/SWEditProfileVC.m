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
#import "SWEditInfoVC.h"
@interface SWEditProfileVC ()<UITextFieldDelegate,SWMineHeaderViewDelegate>
@property(nonatomic, strong)SWMineHeaderView *header;

@property(nonatomic, strong)UIView  *editView;

@property(nonatomic, strong)UILabel *lblName;
@property(nonatomic, strong)UILabel *lblGender;
@property(nonatomic, strong)UILabel *lblIntro;

@property(nonatomic, strong)UIButton    *btnGender;
@property(nonatomic, strong)UIButton    *btnName;
@property(nonatomic, strong)UIButton    *btnIntro;

@property(nonatomic, strong)UIButton    *btnDone;

@end

@implementation SWEditProfileVC
- (void)viewDidAppear:(BOOL)animated{
  [super viewDidAppear:animated];
  [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
  [_header refreshWithUser:[SWConfigManager sharedInstance].user];
  _header.isEditMode = YES;
  
  _btnName.lblCustom.text = [SWConfigManager sharedInstance].user.name;
  _btnIntro.lblCustom.text = [SWConfigManager sharedInstance].user.intro;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor colorWithRGBHex:0xe8edf3];
  [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
  self.navigationItem.titleView = [[ALTitleLabel alloc] initWithTitle:@"編輯個人資料" color:[UIColor colorWithRGBHex:NAV_BAR_COLOR_HEX]];
  
  _header = [[SWMineHeaderView alloc] initWithFrame:CGRectMake(0, iOSNavHeight, UIScreenWidth, 288.5)];
  [self.view addSubview:_header];
  [_header refreshWithUser:[SWConfigManager sharedInstance].user];
  _header.isEditMode = YES;
  _header.delegate = self;
  
  _editView = [[UIView alloc] initWithFrame:CGRectMake(0, _header.bottom+30, UIScreenWidth, 45*3)];
  _editView.backgroundColor = [UIColor whiteColor];
  [self.view addSubview:_editView];
  
  _lblName = [UILabel initWithFrame:CGRectMake(15, 0, 50, 45)
                            bgColor:[UIColor clearColor]
                          textColor:[UIColor colorWithRGBHex:0x191d28]
                               text:SWStringNickName
                      textAlignment:NSTextAlignmentLeft
                               font:[UIFont systemFontOfSize:16]];
  [_editView addSubview:_lblName];
  
  _lblGender = [UILabel initWithFrame:CGRectMake(15, 45, 50, 45)
                              bgColor:[UIColor clearColor]
                            textColor:[UIColor colorWithRGBHex:0x191d28]
                                 text:@"性別"
                        textAlignment:NSTextAlignmentLeft
                                 font:[UIFont systemFontOfSize:16]];
  [_editView addSubview:_lblGender];
  
  _lblIntro = [UILabel initWithFrame:CGRectMake(15, 90, 50, 45)
                              bgColor:[UIColor clearColor]
                            textColor:[UIColor colorWithRGBHex:0x191d28]
                                 text:SWStringAboutMe
                        textAlignment:NSTextAlignmentLeft
                                 font:[UIFont systemFontOfSize:16]];
  [_editView addSubview:_lblIntro];
  
  [_editView addSubview:[ALLineView lineWithFrame:CGRectMake(0, 0, UIScreenWidth, 0.5) colorHex:0xc8c7cc]];
  [_editView addSubview:[ALLineView lineWithFrame:CGRectMake(0, 45, UIScreenWidth, 0.5) colorHex:0xc8c7cc]];
  [_editView addSubview:[ALLineView lineWithFrame:CGRectMake(0, 90, UIScreenWidth, 0.5) colorHex:0xc8c7cc]];
  [_editView addSubview:[ALLineView lineWithFrame:CGRectMake(0, _editView.height-0.5, UIScreenWidth, 0.5) colorHex:0xc8c7cc]];

  
  _btnName = [[UIButton alloc] initWithFrame:CGRectMake(_lblName.right, 0, UIScreenWidth-_lblName.right, 45)];
  _btnName.customImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_btnName.width-25, (_btnName.height-16)/2.0, 10, 16)];
  _btnName.customImageView.image = [UIImage imageNamed:@"gray_arrow"];
  [_editView addSubview:_btnName];
  [_btnName addSubview:_btnName.customImageView];
  _btnName.lblCustom = [UILabel initWithFrame:CGRectMake(0, 0, _btnName.width-30, _btnName.height)
                                        bgColor:[UIColor clearColor]
                                      textColor:[UIColor colorWithRGBHex:0x8e8e8e]
                                           text:[SWConfigManager sharedInstance].user.name
                                  textAlignment:NSTextAlignmentRight
                                           font:[UIFont systemFontOfSize:17]];
  [_btnName addSubview:_btnName.lblCustom];
  [_btnName addTarget:self action:@selector(onNameClick) forControlEvents:UIControlEventTouchUpInside];
  
  _btnGender = [[UIButton alloc] initWithFrame:CGRectMake(_lblGender.right, 45, UIScreenWidth-_lblGender.right, 45)];
  _btnGender.customImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_btnGender.width-25, (_btnGender.height-_btnName.customImageView.height)/2.0, _btnName.customImageView.width, _btnName.customImageView.height)];
  _btnGender.customImageView.image = [UIImage imageNamed:@"gray_arrow"];
  [_editView addSubview:_btnGender];
  [_btnGender addSubview:_btnGender.customImageView];
  _btnGender.lblCustom = [UILabel initWithFrame:CGRectMake(0, 0, _btnGender.width-30, _btnGender.height)
                                        bgColor:[UIColor clearColor]
                                      textColor:[UIColor colorWithRGBHex:0x8e8e8e]
                                           text:[[SWConfigManager sharedInstance].user.gender integerValue]==2?@"男":@"女"
                                  textAlignment:NSTextAlignmentRight
                                           font:[UIFont systemFontOfSize:17]];
  [_btnGender addSubview:_btnGender.lblCustom];
  [_btnGender addTarget:self action:@selector(onGenderClick) forControlEvents:UIControlEventTouchUpInside];
  
  _btnIntro = [[UIButton alloc] initWithFrame:CGRectMake(_lblIntro.right, 90, UIScreenWidth-_lblIntro.right, 45)];
  _btnIntro.customImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_btnIntro.width-25, (_btnGender.height-_btnName.customImageView.height)/2.0, _btnName.customImageView.width, _btnName.customImageView.height)];
  _btnIntro.customImageView.image = [UIImage imageNamed:@"gray_arrow"];
  [_editView addSubview:_btnIntro];
  [_btnIntro addSubview:_btnIntro.customImageView];
  _btnIntro.lblCustom = [UILabel initWithFrame:CGRectMake(0, 0, _btnIntro.width-30, _btnIntro.height)
                                        bgColor:[UIColor clearColor]
                                      textColor:[UIColor colorWithRGBHex:0x8e8e8e]
                                           text:[SWConfigManager sharedInstance].user.intro
                                  textAlignment:NSTextAlignmentRight
                                           font:[UIFont systemFontOfSize:17]];
  [_btnIntro addSubview:_btnIntro.lblCustom];
  [_btnGender addTarget:self action:@selector(onIntroClicked) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}



- (void)onNameClick{
  SWEditInfoVC *vc = [[SWEditInfoVC alloc] init];
  vc.titleText = SWStringNickName;
  [self.navigationController pushViewControllerWithCustomAnimation:vc];
}

- (void)onIntroClicked{
  SWEditInfoVC *vc = [[SWEditInfoVC alloc] init];
  vc.titleText = SWStringAboutMe;
  [self.navigationController pushViewControllerWithCustomAnimation:vc];
}

- (void)onGenderClick{
  __weak typeof(_btnGender)btnGender = _btnGender;
  __weak typeof(self)wSelf = self;
  SWActionSheetView *action = [[SWActionSheetView alloc] initWithFrame:[UIScreen mainScreen].bounds
                                                                 title:nil
                                                               content:@"男"];
  action.completeBlock = ^{
    btnGender.lblCustom.text = @"男";
    [wSelf onDoneClick];
  };
  action.cancelBlock = ^{
    btnGender.lblCustom.text = @"女";
    [wSelf onDoneClick];
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
  api.name = [SWConfigManager sharedInstance].user.name;
  api.gender = [_btnGender.lblCustom.text isEqualToString:@"男"]? 2:1;
  api.head = [SWConfigManager sharedInstance].user.picUrl;
  api.intro = [SWConfigManager sharedInstance].user.intro;
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
