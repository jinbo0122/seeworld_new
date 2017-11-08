//
//  SWBaseViewController.h
//  SeeWorld
//
//  Created by  on 15/8/3.
//  Copyright (c) 2015年 SeeWorld
//

#import <UIKit/UIKit.h>
#import "SWColor.h"
#import "SWUI.h"

@interface SWBaseTableViewController : UITableViewController
@property (strong, nonatomic) UIButton *leftButton;
@property (strong, nonatomic) UIButton *rightButton;

- (void)viewWillAppear:(BOOL)animated navigationBarHidden:(BOOL)navigationBarHidden tabBarHidden:(BOOL)tabBarHidden;
- (void)popViewController;
- (void)pushViewControllerWithSBName:(NSString *)sbName identifier:(NSString *)identifier;
- (void)pushViewController:(UIViewController *)viewController;
- (void)showCancelButton;
- (void)showNextButton;
- (void)showRightButtonWithTitle:(NSString *)title action:(SEL)selector;
- (void)showSaveButton;
@end
