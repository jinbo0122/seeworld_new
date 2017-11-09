//
//  SWSettingVC.m
//  SeeWorld
//
//  Created by Albert Lee on 5/16/16.
//  Copyright © 2016 SeeWorld. All rights reserved.
//

#import "SWSettingVC.h"
#import "SWSettingCell.h"
#import "AppDelegate.h"
#import "SWFeedbackVC.h"
#import "SWAboutVC.h"
#import "SWEditProfileVC.h"
@interface SWSettingVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong)UITableView *tableView;
@end

@implementation SWSettingVC{
  UIView *_footer;
  UIButton *_btnLogout;
}

- (void)viewWillAppear:(BOOL)animated{
  [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated{
  [super viewDidAppear:animated];
  [_tableView reloadData];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor colorWithRGBHex:0x1a2531];
  self.navigationItem.titleView = [[ALTitleLabel alloc] initWithTitle:@"設定" color:[UIColor whiteColor]];
  _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
  _tableView.dataSource = self;
  _tableView.delegate = self;
  _tableView.backgroundColor = [UIColor colorWithRGBHex:0x1a2531];
  _tableView.separatorInset = UIEdgeInsetsZero;
  _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  
  _footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, 128)];
  _tableView.tableFooterView = _footer;
  _btnLogout = [[UIButton alloc] initWithFrame:CGRectMake(29, 35, UIScreenWidth-58, 48)];
  [_btnLogout setBackgroundColor:[UIColor colorWithRGBHex:0x2d435b]];
  [_btnLogout setTitle:@"登出" forState:UIControlStateNormal];
  [_btnLogout setTintColor:[UIColor colorWithRGBHex:0xfbfcfc]];
  [_btnLogout.titleLabel setFont:[UIFont systemFontOfSize:16]];
  [_btnLogout addTarget:self action:@selector(onLogoutClicked) forControlEvents:UIControlEventTouchUpInside];
  [_footer addSubview:_btnLogout];
  [self.view addSubview:_tableView];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle{
  return UIStatusBarStyleLightContent;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
  return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  return (section==0||section==3)?1:2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  return indexPath.section==0?90:56;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  static NSString *iden = @"setting";
  SWSettingCell *cell = (SWSettingCell*)[tableView dequeueReusableCellWithIdentifier:iden];
  if (!cell) {
    cell = [[SWSettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
  }
  [cell refreshWithIndexPath:indexPath];
  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
  return section<2?16:(section==2?45:30);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
  UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, section<2?16:(section==2?50:30))];
  view.backgroundColor = [UIColor colorWithRGBHex:0x1a2531];
  
  if (section==2) {
    UILabel *label = [UILabel initWithFrame:CGRectMake(10, 10, UIScreenWidth-20, 25)
                                    bgColor:[UIColor clearColor]
                                  textColor:[UIColor colorWithRGBHex:0x596d80]
                                       text:@"當SeeWorld+帳號設為不公開時,只有經過你認可的用戶可以看見你的相片和影片。你現有的粉絲不會受影響"
                              textAlignment:NSTextAlignmentLeft
                                       font:[UIFont systemFontOfSize:10.0] numberOfLines:2];
    [view addSubview:label];
  }
  return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  
  if (indexPath.section==0) {
    SWEditProfileVC *vc = [[SWEditProfileVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
  }else if (indexPath.section==2){
    if (indexPath.row==0) {
      SWFeedbackVC *vc = [[SWFeedbackVC alloc] init];
      [self.navigationController pushViewController:vc animated:YES];
    }else{
      SWAboutVC *vc = [[SWAboutVC alloc] init];
      [self.navigationController pushViewController:vc animated:YES];
    }
  }else if (indexPath.section==3){
    __weak typeof(self)wSelf = self;
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
      [wSelf.tableView reloadData];
    }];
  }
}

- (void)onLogoutClicked{
  __weak typeof(self)wSelf = self;
  [[[UIActionSheet alloc] initWithTitle:@"提示"
                       cancelButtonItem:[RIButtonItem itemWithLabel:SWStringCancel]
                  destructiveButtonItem:[RIButtonItem itemWithLabel:@"確定登出？" action:^{
    [wSelf.navigationController popToRootViewControllerAnimated:NO];
    AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [delegate performSelector:@selector(logout) withObject:nil afterDelay:0.2];
  }] otherButtonItems:nil] showInView:self.view];
}
@end