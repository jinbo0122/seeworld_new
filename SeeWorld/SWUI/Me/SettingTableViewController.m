//
//  SettingTableViewController.m
//  SeeWorld
//
//  Created by liufz on 15/9/17.
//  Copyright © 2015年 SeeWorld. All rights reserved.
//

#import "SettingTableViewController.h"
#import "AppDelegate.h"
#import "RegisterProfileViewController.h"
#import "FeedBackViewController.h"
#import "ResetPasswordViewController.h"
#import "SWAboutViewController.h"

@interface SettingTableViewController ()<UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *personName;
@property (weak, nonatomic) IBOutlet UIImageView *personImage;
@property (strong, nonatomic) IBOutletCollection(NSLayoutConstraint) NSArray *lineHeightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *cacheSizeLabel;
@property (strong, nonatomic) IBOutlet UISwitch *pushSwitch;
@end

@implementation SettingTableViewController

- (void)awakeFromNib
{

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showBackButton];
    self.title = @"设置";
    self.personName.text = self.person.name;
    self.personImage.layer.cornerRadius = self.personImage.height/2;
    self.personImage.layer.masksToBounds = YES;
    self.personImage.contentMode = UIViewContentModeScaleToFill;
    [self.personImage sd_setImageWithURL:[NSURL URLWithString:self.person.head]];
    
    CGFloat size = [[SDImageCache sharedImageCache] getSize]/1024.0/1024.0;
    NSString *fileSize = [NSString stringWithFormat:@"%1.lfM", size];
    self.cacheSizeLabel.text = fileSize;
    for (NSLayoutConstraint* constraint in _lineHeightConstraint)
    {
        constraint.constant = 0.5;
    }
  
  _pushSwitch.on = [[SWNoticeModel sharedInstance] pushOpenStatus];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated navigationBarHidden:NO tabBarHidden:YES];
}

#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (0 == indexPath.section) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Profile" bundle:nil];
        RegisterProfileViewController *vc = [sb instantiateViewControllerWithIdentifier:@"RegisterProfileViewController"];
        vc.profileType = eProfileViewTypeEdit;
        vc.person = self.person;
        vc.headerImage.image = self.personImage.image;
        [self pushViewController:vc];
    }
    else if (1 == indexPath.section)
    {
        if ( 1 == indexPath.row)
        {
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Setting" bundle:nil];
            FeedBackViewController *vc = [sb instantiateViewControllerWithIdentifier:@"FeedBackViewController"];
            [self pushViewController:vc];
        }
        else if (2 == indexPath.row)
        {
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Setting" bundle:nil];
            ResetPasswordViewController *vc = [sb instantiateViewControllerWithIdentifier:@"ResetPasswordViewController"];
            [self pushViewController:vc];
        }
    }
    else if (2 == indexPath.section)
    {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Setting" bundle:nil];
        SWAboutViewController *vc = [sb instantiateViewControllerWithIdentifier:@"SWAboutViewController"];
        [self pushViewController:vc];

    }
    else if (3 == indexPath.section)
    {
        // 清除缓存
        dispatch_async(
                       dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
                       , ^{
                           [[SDImageCache sharedImageCache] clearDisk];
                           [[SDImageCache sharedImageCache] clearMemory];
                       });
        [self performSelector:@selector(caches) withObject:nil afterDelay:1];
        
    }
    else if (4 == indexPath.section) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定退出登录?" delegate:self cancelButtonTitle:SWStringCancel otherButtonTitles:SWStringOkay,nil];
        [alert show];
    }
 }

- (void)caches
{
    [SWHUD showCommonToast:@"清除成功"];
    NSString *fileSize = [NSString stringWithFormat:@"%1.lfM", 0.0];
    self.cacheSizeLabel.text = fileSize;
}
- (IBAction)notificationSwitchChanged:(UISwitch *)sender {
  [[SWNoticeModel sharedInstance] pushOpen:sender.on];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (1 == buttonIndex) {
        [self.navigationController popToRootViewControllerAnimated:NO];
        AppDelegate *delegate = [UIApplication sharedApplication].delegate;
        [delegate performSelector:@selector(logout) withObject:nil afterDelay:0.2];
    }
}

@end
