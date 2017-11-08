//
//  TabViewController.m
//
//
//  Created by abc on 15/4/17.
//  Copyright (c) 2015年 Abc
//

#import "TabViewController.h"
#import "AppDelegate.h"
#import "UzysAssetsPickerController.h"
#import "Macros.h"
#import <TuSDK/TuSDK.h>
#import <TuSDKGeeV1/TuSDKGeeV1.h>
#import "AddTagViewController.h"
#import <INTULocationManager/INTULocationManager.h>
#import "SWPostEnterView.h"
#import "SWMineVC.h"

#define kTag_TabBar_Base 0
#define kTag_TabBar_FeedList kTag_TabBar_Base + 1
#define kTag_TabBar_Discovertory kTag_TabBar_Base + 2
#define kTag_TabBar_Publish kTag_TabBar_Base + 3
#define kTag_TabBar_Message kTag_TabBar_Base + 4
#define kTag_TabBar_Me kTag_TabBar_Base + 5

@interface TabViewController ()<UITabBarControllerDelegate,UzysAssetsPickerControllerDelegate,
TuSDKPFEditEntryControllerDelegate,SWPostEnterViewDelegate>
{
  // 图片编辑组件
  TuSDKCPPhotoEditMultipleComponent *_photoEditComponent;
  UIViewController *_tuPFEditEntryController;
}

@property (nonatomic, assign) NSInteger doubleClick;
@property (nonatomic, strong) UzysAssetsPickerController *photoPicker;
@property (nonatomic, strong) UINavigationController *noticeNav;
@property (nonatomic, strong) SWNoticeVC *noticeVC;
@property (nonatomic, strong) UINavigationController *mineNav;
@property (nonatomic, strong) SWMineVC *mineVC;
@end

@implementation TabViewController{
  UIImageView *_dot;
  UILabel *_lblDot;
}

- (void)onTuSDKPFEditEntry:(TuSDKPFEditEntryController *)controller action:(lsqTuSDKCPEditActionType)action{
  
}

- (void)onTuSDKPFEditEntry:(TuSDKPFEditEntryController *)controller result:(TuSDKResult *)result{
  
}

- (void)initControllers
{
  self.delegate = self;
  
  UIStoryboard *publishStoryBoard = [UIStoryboard storyboardWithName:@"Publish" bundle:[NSBundle mainBundle]];
  UINavigationController *publishViewCotroller = [publishStoryBoard instantiateInitialViewController];
  
  self.noticeVC = [[SWNoticeVC alloc] init];
  self.noticeNav = [[UINavigationController alloc] initWithRootViewController:self.noticeVC];
  
  SWHomeFeedVC *homeFeedVC = [[SWHomeFeedVC alloc] init];
  UINavigationController *feedListViewCotroller = [[UINavigationController alloc] initWithRootViewController:homeFeedVC];
  
  UITabBarItem *feedListItem = [[UITabBarItem alloc] initWithTitle:@""
                                                             image:[[UIImage imageNamed:@"tab_btn_home_default"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                               tag:kTag_TabBar_FeedList];
  feedListItem.selectedImage = [[UIImage imageNamed:@"tab_btn_home_pressed"]
                                imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
  feedListViewCotroller.tabBarItem = feedListItem;
  
  UITabBarItem *discovertoryItem = [[UITabBarItem alloc] initWithTitle:@""
                                                                 image:[[UIImage imageNamed:@"tab_btn_find_default"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                                   tag:kTag_TabBar_Discovertory];
  SWExploreVC *discovertoryVC = [[SWExploreVC alloc] init];
  UINavigationController *discovertoryCotroller = [[UINavigationController alloc] initWithRootViewController:discovertoryVC];
  discovertoryItem.selectedImage = [[UIImage imageNamed:@"tab_btn_find_pressed"]
                                    imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
  discovertoryCotroller.tabBarItem = discovertoryItem;
  
  UITabBarItem *publishItem = [[UITabBarItem alloc] initWithTitle:@"" image:[UIImage imageNamed:@"tab_btn_publish_default"]
                                                              tag:kTag_TabBar_Publish];
  publishItem.selectedImage = [[UIImage imageNamed:@"tab_btn_publish_default"]
                               imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
  publishItem.image = [[UIImage imageNamed:@"tab_btn_publish_default"]
                       imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
  publishViewCotroller.tabBarItem = publishItem;
  
  UITabBarItem *messageItem = [[UITabBarItem alloc] initWithTitle:@""
                                                            image:[[UIImage imageNamed:@"tab_btn_notice_default"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                              tag:kTag_TabBar_Publish];
  messageItem.selectedImage = [[UIImage imageNamed:@"tab_btn_notice_pressed"]
                               imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
  self.noticeNav.tabBarItem = messageItem;
  
  self.mineVC = [[SWMineVC alloc] init];
  self.mineNav = [[UINavigationController alloc] initWithRootViewController:self.mineVC];
  
  UITabBarItem *meItem = [[UITabBarItem alloc] initWithTitle:@""
                                                       image:[[UIImage imageNamed:@"tab_btn_profile_default"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                         tag:kTag_TabBar_Me];
  meItem.selectedImage = [[UIImage imageNamed:@"tab_btn_profile_pressed"]
                          imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
  self.mineNav.tabBarItem = meItem;
  
  [self setTabbarItemInset:feedListItem];
  feedListItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
  [self setTabbarItemInset:discovertoryItem];
  discovertoryItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
  [self setTabbarItemInset:publishItem];
  publishItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
  [self setTabbarItemInset:messageItem];
  messageItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
  [self setTabbarItemInset:meItem];
  meItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
  
  self.viewControllers = @[feedListViewCotroller, discovertoryCotroller, publishViewCotroller, self.noticeNav, self.mineNav];
  UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 35,0,70, self.tabBar.height)];
  [button setImage:[UIImage imageNamed:@"tab_btn_publish_default"] forState:UIControlStateNormal];
  [button addTarget:self action:@selector(showComposeView) forControlEvents:UIControlEventTouchUpInside];
  [self.tabBar addSubview:button];
  
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  [[UITabBar appearance] setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRGBHex:0x184866]]];
  [[UITabBar appearance] setTintColor:[UIColor whiteColor]];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hidePickerController) name:@"hidePickerController" object:nil];
  // Do any additional setup after loading the view.
  [self initControllers];
}

+ (void)dotAppearance{
  [TabViewController dotNotice:[SWNoticeModel sharedInstance].unreadNoticeCount msg:[[RCIMClient sharedRCIMClient] getTotalUnreadCount]];
}

+ (void)dotNotice:(NSInteger)unreadNoticeCount msg:(NSInteger)totalUnreadCount{
  TabViewController *tab = (TabViewController*)[UIApplication sharedApplication].delegate.window.rootViewController;
  if([tab isKindOfClass:[TabViewController class]]){
    [tab hideDotView:unreadNoticeCount<=0&&totalUnreadCount<=0 num:totalUnreadCount+unreadNoticeCount];
  }
}

- (void)hideDotView:(BOOL)hide num:(NSInteger)num{
  [_dot removeFromSuperview];
  [_lblDot removeFromSuperview];
  if (!hide) {
    _dot = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tab_pubup_notice"]];
    _dot.frame = CGRectMake(UIScreenWidth *7.1/10.0 + 15, -5, 26, 26);
    _lblDot = [UILabel initWithFrame:CGRectMake(0, 0, _dot.width, 24)
                             bgColor:[UIColor clearColor]
                           textColor:[UIColor whiteColor]
                                text:num>99?@"...":[@(num) stringValue]
                       textAlignment:NSTextAlignmentCenter
                                font:[UIFont systemFontOfSize:12]];
    [_dot addSubview:_lblDot];
    [self.tabBar addSubview:_dot];
    _dot.hidden = num==0;
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = num;
  }else{
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
  }
}

- (void)pushChat:(UIViewController *)vc{
  [self.noticeVC.titleView setSelectedIndex:1];
  [self.noticeNav popToRootViewControllerAnimated:NO];
  [self.noticeNav pushViewController:vc animated:YES];
}
- (void)popChatSetting{
  [self.noticeVC.titleView setSelectedIndex:1];
  [self.noticeNav popViewControllerAnimated:NO];
}

- (void)hidePickerController
{
  WS(weakSelf);
  [self.photoPicker dismissViewControllerAnimated:NO completion:^{
    [weakSelf.photoPicker dismissViewControllerAnimated:NO completion:^{
      UINavigationController *nav = weakSelf.viewControllers.firstObject;
      SWHomeFeedVC *vc = [nav.viewControllers safeObjectAtIndex:0];
      [vc forceRefresh];
      weakSelf.selectedIndex = 0;
      [weakSelf.mineVC refresh];
    }];
  }];
}

- (void)setTabbarItemInset:(UITabBarItem *)items
{
  //设置TabBar图片的偏移量
  [items setTitlePositionAdjustment:UIOffsetMake(0, 15)];
}


- (void)selectedTabBarAtIndex:(NSNotification *)notify
{
  NSInteger selectedIndex = [[[notify userInfo] objectForKey:@"tabBarIndex"] integerValue];
  [self setSelectedIndex:selectedIndex];
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
  if (item.tag == kTag_TabBar_Publish)
  {
    
  }
}

- (void)updateLocation
{
  INTULocationManager *locMgr = [INTULocationManager sharedInstance];
  [locMgr requestLocationWithDesiredAccuracy:INTULocationAccuracyCity
                                     timeout:10.0
                        delayUntilAuthorized:YES  // This parameter is optional, defaults to NO if omitted
                                       block:^(CLLocation *currentLocation, INTULocationAccuracy achievedAccuracy, INTULocationStatus status) {
                                         if (status == INTULocationStatusSuccess) {
                                           [[NSUserDefaults standardUserDefaults] setObject:@(currentLocation.coordinate.latitude) forKey:@"latitude"];
                                           [[NSUserDefaults standardUserDefaults] setObject:@(currentLocation.coordinate.longitude) forKey:@"longitude"];
                                         }
                                         else if (status == INTULocationStatusTimedOut) {
                                           // Wasn't able to locate the user with the requested accuracy within the timeout interval.
                                           // However, currentLocation contains the best location available (if any) as of right now,
                                           // and achievedAccuracy has info on the accuracy/recency of the location in currentLocation.
                                         }
                                         else {
                                           // An error occurred, more info is available by looking at the specific status returned.
                                         }
                                       }];
}

- (void)showComposeView{
  [SWPostEnterView showWithDelegate:self];
}

- (void)compose
{
  [self updateLocation];
  UzysAssetsPickerController *photoPicker = [[UzysAssetsPickerController alloc] init];
  photoPicker.delegate = self;
  photoPicker.maximumNumberOfSelectionVideo = 0;
  photoPicker.maximumNumberOfSelectionPhoto = 1;
  _photoPicker = photoPicker;
  [self presentViewController:photoPicker animated:YES completion:^{
  }];
}

- (void)startChat{
  SWSelectContactVC *vc = [[SWSelectContactVC alloc] init];
  UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
  [self presentViewController:nav animated:YES
                   completion:nil];
}

/**
 *  开启图片高级编辑
 *
 *  @param controller 来源控制器
 *  @param result     处理结果
 */
- (void)openEditAdvancedWithController:(UIViewController *)controller
                                result:(TuSDKResult *)result;
{
  if (!controller || !result) return;
  
  // 组件选项配置
  // @see-http://tusdk.com/docs/ios/api/Classes/TuSDKCPPhotoEditComponent.html
  _photoEditComponent =
  [TuSDKGeeV1 photoEditMultipleWithController:controller
                                callbackBlock:^(TuSDKResult *result, NSError *error, UIViewController *controller){
                                  if (error) {
                                    lsqLError(@"editMultiple error: %@", error.userInfo);
                                    return;
                                  }
                                  [result logInfo];
                                  UIImage *image = result.image;
                                  if (!image) {
                                    image = [result loadResultImage];
                                  }
                                  
                                  UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Publish" bundle:nil];
                                  AddTagViewController *vc = [sb instantiateViewControllerWithIdentifier:@"AddTagViewController"];
                                  vc.photoImage = image;
                                  [controller.navigationController pushViewController:vc animated:YES];
                                }];
  
  _photoEditComponent.inputImage = result.image;
  _photoEditComponent.inputTempFilePath = result.imagePath;
  _photoEditComponent.options.editMultipleOptions.saveToAlbum = NO;
  _photoEditComponent.options.editMultipleOptions.saveToTemp = NO;

  [_photoEditComponent showComponent];
}

/**
 *  获取组件返回错误信息
 *
 *  @param controller 控制器
 *  @param result     返回结果
 *  @param error      异常信息
 */
- (void)onComponent:(TuSDKCPViewController *)controller result:(TuSDKResult *)result error:(NSError *)error;
{
  lsqLDebug(@"onComponent: controller - %@, result - %@, error - %@", controller, result, error);
}

#pragma mark - UzysAssetsPickerControllerDelegate
- (void)uzysAssetsPickerController:(UzysAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
  [assets enumerateObjectsUsingBlock:^(ALAsset *asset, NSUInteger idx, BOOL *stop) {
    struct CGImage *fullScreenImage = asset.defaultRepresentation.fullScreenImage;
    UIImage *image = [UIImage imageWithCGImage:fullScreenImage];
    if (image)
    {
      TuSDKResult *result = [TuSDKResult result];
      result.image = image;
      result.imagePath = [self savePic:image];
      [self openEditAdvancedWithController:picker result:result];
    }
  }];
}

- (void)uzysAssetsPickerControllerDidExceedMaximumNumberOfSelection:(UzysAssetsPickerController *)picker{
  
}

//保存图片
- (NSString *)savePic:(UIImage *)image
{
  if (nil == image)
  {
    return nil;
  }
  
  //根据时间格式确保文件名唯一性
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  NSDate *date = [[NSDate alloc] init];
  [formatter setDateFormat:@"YYYY_MM_dd_HH_mm_ss"];
  //避免时间相同
  NSString *formatStr = [formatter stringFromDate:date];
  NSString *keyStr = [formatStr stringByAppendingString:@".png"];
  
  //写入文件
  NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
  NSString *path = paths.count > 0? [paths objectAtIndex:0]:@"";
  NSString *fullPath = [path stringByAppendingPathComponent:keyStr];
  
  //保存到沙盒
  [imageData writeToFile:fullPath atomically:NO];
  return fullPath;
}
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
  if (viewController == tabBarController.selectedViewController) {
    if ([viewController isKindOfClass:[UINavigationController class]]) {
      UINavigationController *nav = (UINavigationController *)viewController;
      if ([[nav.viewControllers safeObjectAtIndex:0] isKindOfClass:[SWHomeFeedVC class]]) {
        SWHomeFeedVC *vc = [nav.viewControllers safeObjectAtIndex:0];
        [vc forceRefresh];
      }else if ([[nav.viewControllers safeObjectAtIndex:0] isKindOfClass:[SWNoticeVC class]]) {
        SWNoticeVC *vc = [nav.viewControllers safeObjectAtIndex:0];
        [vc reloadModelData];
      }
    }
    return YES;
  }
  return YES;
}

#pragma mark Post Enter
- (void)postEnterViewDidReturnAction:(SWPostEnterView *)view{
  if (view.isNeedPhoto) {
    [self compose];
  }else if (view.isNeedChat){
    [self startChat];
  }
}
@end
