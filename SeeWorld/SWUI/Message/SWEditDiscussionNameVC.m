//
//  SWEditDiscussionNameVC.m
//  SeeWorld
//
//  Created by Albert Lee on 1/7/16.
//  Copyright © 2016 SeeWorld. All rights reserved.
//

#import "SWEditDiscussionNameVC.h"

@interface SWEditDiscussionNameVC ()
@property(nonatomic, strong)RCDiscussion *discussion;
@end

@implementation SWEditDiscussionNameVC{
  UITextField *_txtField;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor colorWithRGBHex:0x1a2531];
  self.navigationItem.titleView = [[ALTitleLabel alloc] initWithTitle:SWStringDiscussionName color:[UIColor whiteColor]];
  [self.view addSubview:[ALLineView lineWithFrame:CGRectMake(0,iOS7NavHeight+ 10, self.view.width, 0.5) colorHex:0xc8c7cc]];
  [self.view addSubview:[ALLineView lineWithFrame:CGRectMake(0,iOS7NavHeight+ 55, self.view.width, 0.5) colorHex:0xc8c7cc]];
  [self.view addSubview:[ALLineView lineWithFrame:CGRectMake(0,iOS7NavHeight+ 10.5, self.view.width, 44.5) colorHex:0xffffff]];

  _txtField = [[UITextField alloc] initWithFrame:CGRectMake(10, iOS7NavHeight+10.5, self.view.width-20, 44.5)];
  _txtField.textColor = [UIColor colorWithRGBHex:0x4a4a4a];
  _txtField.font = [UIFont systemFontOfSize:17];
  [self.view addSubview:_txtField];
  
  __weak typeof(_txtField)field = _txtField;
  [[RCIMClient sharedRCIMClient] getDiscussion:self.targetId success:^(RCDiscussion *discussion) {
    field.text = discussion.discussionName;
  } error:^(RCErrorCode status) {
    
  }];
  
  [_txtField becomeFirstResponder];
  
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:SWStringSave
                                                                            style:UIBarButtonItemStylePlain
                                                                           target:self action:@selector(onSave)];
}

- (void)onSave{
  __weak typeof(self)wSelf = self;
  MBProgressHUD *hud = [MBProgressHUD showLoadingInView:self.view];
  __weak typeof(hud)wHud = hud;
  [[RCIMClient sharedRCIMClient] setDiscussionName:self.targetId
                                              name:_txtField.text
                                           success:^{
                                             dispatch_async(dispatch_get_main_queue(), ^{
                                               [wHud hide:YES];
                                               [wSelf.navigationController popViewControllerAnimated:YES];
                                             });
                                           } error:^(RCErrorCode status) {
                                             
                                           }];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
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
