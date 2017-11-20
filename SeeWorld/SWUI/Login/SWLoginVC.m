//
//  SWLoginVC.m
//  SeeWorld
//
//  Created by Albert Lee on 6/5/16.
//  Copyright © 2016 SeeWorld. All rights reserved.
//

#import "SWLoginVC.h"
#import "SWLoginDetailVC.h"
#import "SWRegisterVC.h"
#import "SWRegisterProfileVC.h"
@interface SWLoginVC ()

@end

@implementation SWLoginVC{
  UIImageView *_logo;
  UIButton    *_btnRegister;
  UIButton    *_btnLogin;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor whiteColor];
  
  _logo = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.width-191)/2.0, 121, 191, 191)];
  _logo.image = [UIImage imageNamed:@"logo"];
  _logo.layer.masksToBounds = YES;
  _logo.layer.cornerRadius = _logo.height/2.0;
  [self.view addSubview:_logo];
  
  _btnRegister = [[UIButton alloc] initWithFrame:CGRectMake(30, UIScreenHeight-150-iphoneXBottomAreaHeight, self.view.width-60, 50)];
  [_btnRegister setBackgroundColor:[UIColor colorWithRGBHex:0x55acef]];
  [_btnRegister setTitle:@"註冊" forState:UIControlStateNormal];
  [_btnRegister setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  [_btnRegister.titleLabel setFont:[UIFont systemFontOfSize:16]];
  [self.view addSubview:_btnRegister];
  _btnRegister.layer.masksToBounds = YES;
  _btnRegister.layer.cornerRadius = 2.5;

  [_btnRegister addTarget:self action:@selector(onRegister) forControlEvents:UIControlEventTouchUpInside];
  
  _btnLogin = [[UIButton alloc] initWithFrame:CGRectMake(30, _btnRegister.bottom+20, self.view.width-60, 50)];
  [_btnLogin setTitle:@"登入" forState:UIControlStateNormal];
  [_btnLogin setTitleColor:[UIColor colorWithRGBHex:0x55acef] forState:UIControlStateNormal];
  [_btnLogin.titleLabel setFont:[UIFont systemFontOfSize:16]];
  _btnLogin.layer.masksToBounds = YES;
  _btnLogin.layer.cornerRadius = 2.5;
  _btnLogin.layer.borderWidth = 1.0;
  _btnLogin.layer.borderColor =[UIColor colorWithRGBHex:0x55acef].CGColor;
  [self.view addSubview:_btnLogin];
  [_btnLogin addTarget:self action:@selector(onLogin) forControlEvents:UIControlEventTouchUpInside];
  
  
  _btnRegister.layer.masksToBounds = YES;
  _btnRegister.layer.cornerRadius = 2.0;
  _btnLogin.layer.masksToBounds = YES;
  _btnLogin.layer.cornerRadius = 2.0;
//  UILabel *intro = [UILabel initWithFrame:CGRectMake(0, self.view.height-24, self.view.width, 9)
//                                  bgColor:[UIColor clearColor]
//                                textColor:[UIColor whiteColor]
//                                     text:@"seeworldplus.com 2011-2016 © All Rights Reserved"
//                            textAlignment:NSTextAlignmentCenter
//                                     font:[UIFont systemFontOfSize:9]];
//  [self.view addSubview:intro];
  
  [self.navigationController setNavigationBarHidden:YES];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)onLogin{
  SWLoginDetailVC *vc = [[SWLoginDetailVC alloc] init];
  [self.navigationController setNavigationBarHidden:NO];
  [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRGBHex:0xffffff]];
  self.navigationController.navigationBar.translucent = YES;
  [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
  [super viewWillAppear:animated];
  [self.navigationController setNavigationBarHidden:YES];
}

- (void)onRegister{
  SWRegisterVC *vc = [[SWRegisterVC alloc] init];
  [self.navigationController setNavigationBarHidden:NO];
  [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRGBHex:0xffffff]];
  self.navigationController.navigationBar.translucent = YES;
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
