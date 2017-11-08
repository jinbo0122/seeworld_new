//
//  SWBaseViewController.m
//  SeeWorld
//
//  Created by  on 15/8/3.
//  Copyright (c) 2015年 SeeWorld
//

#import "SWBaseTableViewController.h"


@interface SWBaseTableViewController ()<UIGestureRecognizerDelegate>
@property (nonatomic, strong) UILabel *lbTitle;
@end

@implementation SWBaseTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    if (nil == _lbTitle)
    {
        [self initTitle];
    }
}

- (void)viewWillAppear:(BOOL)animated navigationBarHidden:(BOOL)navigationBarHidden tabBarHidden:(BOOL)tabBarHidden
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = navigationBarHidden;
    self.tabBarController.tabBar.hidden = tabBarHidden;
  self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRGBHex:0x1a2531];
    self.navigationController.navigationBar.backgroundColor = [UIColor colorWithRGBHex:0x152c3e];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self viewWillAppear:animated navigationBarHidden:NO tabBarHidden:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)initTitle
{
    _lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    _lbTitle.font = [UIFont fontWithName:@"Helvetica" size:18.0f];
    _lbTitle.textColor = [UIColor hexChangeFloat:@"494949"];
    _lbTitle.textAlignment = NSTextAlignmentCenter;
    _lbTitle.backgroundColor = [UIColor clearColor];
    
    self.navigationItem.titleView = _lbTitle;
}

- (void)setTitle:(NSString *)title
{
    if (nil == _lbTitle)
    {
        [self initTitle];
    }
    
    _lbTitle.text = title;
}

- (void)showNextButton
{
    [self showRightButtonWithTitle:@"下一步" action:@selector(onNextButtonClicked:)];
}

- (void)showCancelButton
{
    [self showRightButtonWithTitle:SWStringCancel action:@selector(onCancelButtonClicked:)];
}

- (void)showSaveButton
{
    [self showRightButtonWithTitle:@"保存" action:@selector(onSaveButtonClicked:)];
}

- (void)showRightButtonWithTitle:(NSString *)title action:(SEL)selector
{
    _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_rightButton setTitle:title forState:UIControlStateNormal];
    [_rightButton setTitleColor:[UIColor hexChangeFloat:@"55ACEF"] forState:UIControlStateNormal];
    [_rightButton setTitleColor:[UIColor hexChangeFloat:@"494949"] forState:UIControlStateDisabled];
    _rightButton.frame = CGRectMake(0, 0, 30, 60);
    _rightButton.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:17.0f];
    [_rightButton sizeToFit];
    [_rightButton addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *btnNavRightItem = [[UIBarButtonItem alloc] initWithCustomView:_rightButton];
    self.navigationItem.rightBarButtonItem = btnNavRightItem;
}

- (void)onNextButtonClicked:(UIButton *)sender
{
}

- (void)onCancelButtonClicked:(UIButton *)sender
{
}

- (void)onBackButtonClicked:(UIButton *)sender
{
    [self.view endEditing:YES];
    [self popViewController];
}

- (void)onSaveButtonClicked:(UIButton *)sender
{
}

- (void)popViewController
{
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)pushViewControllerWithSBName:(NSString *)sbName identifier:(NSString *)identifier
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:sbName bundle:nil];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:identifier];
    [self pushViewController:vc];
}

- (void)pushViewController:(UIViewController *)viewController
{
    [self.view endEditing:YES];
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
