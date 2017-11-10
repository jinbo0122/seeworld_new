//
//  KKBaseViewController.m
//  KKShopping
//
//  Created by andaji on 13-8-13.
//  Copyright (c) 2013年 KiDulty. All rights reserved.
//

#import "ALBaseVC.h"

@interface ALBaseVC (){
}

@end

@implementation ALBaseVC
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.navigationItem.backBarButtonItem = nil;
  self.navigationItem.title = @" ";
  self.view.backgroundColor = [UIColor colorWithRGBHex:0xffffff];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)onBackBarBtnClick
{
  [self.navigationController popViewControllerCustomAnimation];
}
@end
