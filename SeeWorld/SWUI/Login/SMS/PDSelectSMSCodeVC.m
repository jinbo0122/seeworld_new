//
//  PDSelectSMSCodeVC.m
//  pandora
//
//  Created by Albert Lee on 10/13/14.
//  Copyright (c) 2014 Albert Lee. All rights reserved.
//

#import "PDSelectSMSCodeVC.h"
#import "PDSMSCodeCell.h"
#import "PDCountryIndex.h"
@interface PDSelectSMSCodeVC ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSMutableArray *smsArray;
@end

@implementation PDSelectSMSCodeVC
- (id)init{
  self = [super init];
  if (self) {
    self.smsArray = [[NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"sms" ofType:@"plist"]] mutableCopy];
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  self.view.backgroundColor = [UIColor clearColor];
  self.navigationItem.titleView = [[ALTitleLabel alloc] initWithTitle:@"選擇國家和地區" color:[UIColor whiteColor]];
  UILocalizedIndexedCollation *theCollation = [UILocalizedIndexedCollation currentCollation];
  NSMutableArray *temp = [NSMutableArray arrayWithCapacity:0];
  for (int i = 0; i<self.smsArray.count;i++){
    PDCountryIndex *item = [[PDCountryIndex alloc] init];
    item.countryName = [[self.smsArray safeDicObjectAtIndex:i] safeStringObjectForKey:@"cn"];
    item.countryCode = [[self.smsArray safeDicObjectAtIndex:i] safeStringObjectForKey:@"code"];
    item.countryNamePinyin = [[self.smsArray safeDicObjectAtIndex:i] safeStringObjectForKey:@"pinyin"];
    [temp safeAddObject:item];
  }
  
  for (PDCountryIndex *item in temp) {
    NSInteger sect = [theCollation sectionForObject:item collationStringSelector:@selector(getName)];//getLastName是实现中文安拼音检索的核心，见NameIndex类
    [item setSectionNum:sect]; //设定姓的索引编号
  }
  
  NSInteger highSection = [[theCollation sectionTitles] count]; //返回的应该是27，是a－z和＃
  NSMutableArray *sectionArrays = [NSMutableArray arrayWithCapacity:highSection]; //tableView 会被分成27个section
  for (int i=0; i<=highSection; i++) {
    NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:1];
    [sectionArrays safeAddObject:sectionArray];
  }
  for (PDCountryIndex *item in temp) {
    [(NSMutableArray *)[sectionArrays objectAtIndex:item.sectionNum] safeAddObject:item];
  }
  
  [self.smsArray removeAllObjects];
  for (NSMutableArray *sectionArray in sectionArrays) {
    NSArray *sortedSection = [theCollation sortedArrayFromArray:sectionArray collationStringSelector:@selector(getName)]; //同
    [self.smsArray safeAddObject:sortedSection];
  }
  
  self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth,self.view.height)
                                                style:UITableViewStylePlain];
  self.tableView.dataSource = self;
  self.tableView.delegate = self;
  self.tableView.backgroundColor = [UIColor whiteColor];
  if ([self.tableView respondsToSelector:@selector(setSectionIndexBackgroundColor:)]) {
    self.tableView.sectionIndexBackgroundColor = [UIColor whiteColor];
  }
  self.tableView.sectionIndexColor = [UIColor colorWithRGBHex:0x8e8e93];
  if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
  }
  
  UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, 50)];
  self.tableView.tableFooterView = footerView;
  [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
  return [self.smsArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  return [(NSArray *)[self.smsArray safeArrayObjectAtIndex:section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
  
  return [(NSArray *)[self.smsArray safeArrayObjectAtIndex:section] count] > 0?30:0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
  if ([(NSArray *)[self.smsArray safeArrayObjectAtIndex:section] count] > 0) {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, 30)];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *lblTitle = [UILabel initWithFrame:CGRectMake(15, 0, 100, 30)
                                                       bgColor:[UIColor clearColor]
                                                     textColor:[UIColor colorWithRGBHex:0x4c4c4c]
                                                          text:[[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:section]
                                                 textAlignment:NSTextAlignmentLeft
                                                          font:[UIFont systemFontOfSize:18]];
    [view addSubview:lblTitle];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 29.5, UIScreenWidth, 0.5)];
    line.backgroundColor = [UIColor colorWithRGBHex:0xd2d1d5];
    [view addSubview:line];
    
    return view;
  }
  else{
    return [UIView new];
  }
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
  return [[UILocalizedIndexedCollation currentCollation] sectionIndexTitles];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  static NSString *identifier = @"countryCell";
  PDSMSCodeCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
  if (!cell) {
    cell = [[PDSMSCodeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
  }
  PDCountryIndex *item = [[self.smsArray safeArrayObjectAtIndex:indexPath.section] safeObjectAtIndex:indexPath.row];
  cell.lblCountry.text = item.countryName;
  cell.lblCode.text = [@"+" stringByAppendingString:item.countryCode] ;
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  if (self.delegate&& [self.delegate respondsToSelector:@selector(smsDidReturnWithCountry:code:)]) {
    PDCountryIndex *item = [[self.smsArray safeArrayObjectAtIndex:indexPath.section] safeObjectAtIndex:indexPath.row];
    [self.delegate smsDidReturnWithCountry:item.countryName code:[@"+" stringByAppendingString:item.countryCode]];
    [self.navigationController popViewControllerAnimated:YES];
  }
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
