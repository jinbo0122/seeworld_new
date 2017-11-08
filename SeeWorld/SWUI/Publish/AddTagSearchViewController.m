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
@property (weak, nonatomic) IBOutlet WTextField *tagTextFeild;
@property (weak, nonatomic) IBOutlet UITableView *tagTableView;
@property (strong, nonatomic) NSMutableArray  *hotTags;
@end

@implementation AddTagSearchViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self.tagTextFeild addTarget:self action:@selector(textFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
  self.tagTableView.dataSource = self;
  self.tagTableView.delegate = self;
  self.tagTextFeild.delegate = self;
  
  self.tagTextFeild.editingInsetPoint = CGPointMake(10, 0);
  self.tagTextFeild.textInsetPoint = CGPointMake(10, 0);
  
  _tagTextFeild.textColor = [UIColor whiteColor];
  _tagTextFeild.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"標記品牌/地點/人物"
                                                                        attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],
                                                                                     NSForegroundColorAttributeName:[UIColor whiteColor]}];
  _tagTextFeild.layer.masksToBounds = YES;
  _tagTextFeild.layer.borderColor = [UIColor colorWithRGBHex:0x8b9cad].CGColor;
  _tagTextFeild.layer.borderWidth = 0.5;
  _tagTextFeild.layer.cornerRadius  = 4.0;
  
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
  AddTagCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddTagCell"];
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
