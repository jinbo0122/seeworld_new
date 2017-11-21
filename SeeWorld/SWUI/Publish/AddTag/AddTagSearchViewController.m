//
//  AddTagSearchViewController.m
//  SeeWorld
//
//  Created by liufz on 15/9/12.
//  Copyright (c) 2015年 SeeWorld. All rights reserved.
//

#import "AddTagSearchViewController.h"
#import "AddTagCell.h"
#import "WTextField.h"
#import "SWHotTagsAPI.h"
@interface AddTagSearchViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (strong, nonatomic) WTextField *tagTextFeild;
@property (strong, nonatomic) UITableView *tagTableView;
@property (strong, nonatomic) UIView   *tagSearchBgView;

@property (strong, nonatomic) NSMutableArray  *hotTags;
@end

@implementation AddTagSearchViewController{
  UIButton *_btnCancel;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor whiteColor];
  
  _tagSearchBgView = [[UIView alloc] initWithFrame:CGRectMake(0,20+ iOSTopHeight, self.view.width, 56)];
  [self.view addSubview:_tagSearchBgView];
  
  _tagTextFeild = [[WTextField alloc] initWithFrame:CGRectMake(15, 12, self.view.width - 75, 32)];
  [_tagSearchBgView addSubview:_tagTextFeild];
  
  _btnCancel = [[UIButton alloc] initWithFrame:CGRectMake(self.view.width - 60, 0, 60, _tagSearchBgView.height)];
  [_btnCancel setTitle:SWStringCancel forState:UIControlStateNormal];
  [_btnCancel addTarget:self action:@selector(cancelClick:) forControlEvents:UIControlEventTouchUpInside];
  [_tagSearchBgView addSubview:_btnCancel];
  [_btnCancel setTitleColor:[UIColor colorWithRGBHex:0x677689] forState:UIControlStateNormal];
  [_btnCancel.titleLabel setFont:[UIFont systemFontOfSize:16]];
  
  [self.tagTextFeild addTarget:self action:@selector(textFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
  self.tagTextFeild.delegate = self;
  
  self.tagTextFeild.editingInsetPoint = CGPointMake(10, 0);
  self.tagTextFeild.textInsetPoint = CGPointMake(10, 0);
  
  _tagTextFeild.textColor = [UIColor colorWithRGBHex:0x28323d];
  _tagTextFeild.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"話題、地點、品牌、任務"
                                                                        attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],
                                                                                     NSForegroundColorAttributeName:[UIColor colorWithRGBHex:0x677689]}];
  _tagTextFeild.layer.masksToBounds = YES;
  _tagTextFeild.layer.borderColor = [UIColor colorWithRGBHex:0x28323d].CGColor;
  _tagTextFeild.layer.borderWidth = 0.5;
  _tagTextFeild.layer.cornerRadius  = 4.0;
  
  _tagTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _tagSearchBgView.bottom, self.view.width, self.view.height-_tagSearchBgView.bottom)
                                               style:UITableViewStylePlain];
  _tagTableView.dataSource = self;
  _tagTableView.delegate = self;
  _tagTableView.rowHeight = 44;
  _tagTableView.separatorInset = UIEdgeInsetsZero;
  _tagTableView.backgroundColor = [UIColor whiteColor];
  _tagTableView.separatorColor = [UIColor colorWithRGBHex:0xdbe0e5];
  [self.view addSubview:_tagTableView];
  
  _hotTags = [NSMutableArray array];
  __weak typeof(self)wSelf = self;
  SWHotTagsAPI *api = [[SWHotTagsAPI alloc] init];
  [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
    [wSelf.hotTags addObjectsFromArray:[[request.responseString safeJsonDicFromJsonString] safeArrayObjectForKey:@"data"]];
    [wSelf.tagTableView reloadData];
  } failure:^(__kindof YTKBaseRequest *request) {
    
  }];
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated navigationBarHidden:YES tabBarHidden:YES];
}

- (IBAction)cancelClick:(id)sender {
  [self.tagTextFeild endEditing:YES];
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  static NSString *identifier = @"AddTagCell";
  AddTagCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
  if (!cell) {
    cell = [[AddTagCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
  }
  if (indexPath.row == 0 && self.tagTextFeild.text.length > 0){
    cell.hotTagLabelText.text = [NSString stringWithFormat:@"添加標籤:%@", self.tagTextFeild.text];
  }else if ((indexPath.row == 0 && self.tagTextFeild.text.length == 0)||
            (indexPath.row == 1 && self.tagTextFeild.text.length > 0)){
    cell.hotTagLabelText.text = @"熱門標籤:";
  }else{
    cell.hotTagLabelText.text = [[_hotTags safeDicObjectAtIndex:indexPath.row-(self.tagTextFeild.text.length > 0?2:1)] safeStringObjectForKey:@"name"];
  }
  [cell.hotTagLabelText sizeToFit];
  cell.selectionStyle = UITableViewCellSelectionStyleNone;
  return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  if (self.tagTextFeild.text.length > 0){
    return 2+_hotTags.count;
  }else{
    return 1+_hotTags.count;
  }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  AddTagCell *cell = [tableView cellForRowAtIndexPath:indexPath];
  if (![cell.hotTagLabelText.text isEqualToString:@"熱門標籤:"]){
    [self.tagTextFeild endEditing:YES];
    !self.endInputTitleHandler ?: self.endInputTitleHandler((indexPath.row==0&&self.tagTextFeild.text.length)?self.tagTextFeild.text:cell.hotTagLabelText.text);
    [self dismissViewControllerAnimated:YES completion:nil];
  }
}

- (void)textFieldEditingChanged:(UITextField *)textField
{
  [self.tagTableView reloadData];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
  [self.tagTextFeild endEditing:YES];
  !self.endInputTitleHandler ?: self.endInputTitleHandler(self.tagTextFeild.text);
  [self dismissViewControllerAnimated:YES completion:nil];
  return YES;
}

@end
