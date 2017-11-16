//
//  AppDelegate.m
//  SeeWorld
//
//  Created by  on 15/8/3.
//  Copyright (c) 2015年 SeeWorld
//

#import "AppDelegate.h"
#import "SWFoundation.h"
#import "SWDefine.h"
#import "WXApi.h"
#import "WeiboSDK.h"
#import "SWLoginVC.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "TabViewController.h"
#import "SWLoginWBAPI.h"
#import "LoginResponse.h"
#import <SMS_SDK/SMSSDK.h>
@interface AppDelegate ()<GeTuiSdkDelegate,WeiboSDKDelegate,WBHttpRequestDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  // Override point for customization after application launch.
  [self createFolders];
  UINavigationBar* appearanceNavigationBar = [UINavigationBar appearance];
  if ([[UINavigationBar class] instancesRespondToSelector:@selector(setBackIndicatorImage:)]){
    appearanceNavigationBar.backIndicatorImage = [[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    appearanceNavigationBar.backIndicatorTransitionMaskImage = [[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    appearanceNavigationBar.tintColor = [UIColor colorWithRGBHex:NAV_BAR_COLOR_HEX];
    appearanceNavigationBar.barTintColor = [UIColor whiteColor];
    appearanceNavigationBar.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:20],
                                                    NSForegroundColorAttributeName:[UIColor whiteColor]};
  }
  [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil]
   setDefaultTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRGBHex:NAV_BAR_COLOR_HEX],
                              NSFontAttributeName:[UIFont systemFontOfSize:16]}];
  [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil]
   setBackgroundColor:[UIColor clearColor]];
  
//  UIOffset backButtonTextOffset = UIOffsetMake(0, -40);
//  [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:backButtonTextOffset
//                                                       forBarMetrics:UIBarMetricsDefault];
#if TARGET_IPHONE_SIMULATOR
#else
  [WXApi registerApp:SWWeixinAPI];
#endif
  
  [WeiboSDK registerApp:SWWeiboAPI];
  
  // [1]:使用 APPID/APPKEY/APPSECRENT 创建个推实例
  [self startGetuiSdkWith:@"pZPgtsRvqP9CJZ4ScARGT3" appKey:@"SiIjKsP8ps6PyJlq4RQLZ4" appSecret:@"XjTRT1LzhL82iujISWRyo"];
  // [2]:注册 APNS
  [self registerRemoteNotification];
  
  [[RCIMClient sharedRCIMClient] recordLaunchOptionsEvent:launchOptions];
  // [2-EXT]: 获取启动时收到的 APN 数据
  
  NSDictionary*message=[launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
  if (message) {
    [self handleNotification:message];
  }
  
  
  YTKNetworkConfig *config = [YTKNetworkConfig sharedConfig];
  config.baseUrl = Base_URL;
  
  [SWConfigManager sharedInstance];
  
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  self.window.backgroundColor = [UIColor whiteColor];
  
  NSString *jwt = [[NSUserDefaults standardUserDefaults] safeStringObjectForKey:@"jwt"];
  if (jwt.length > 0)
  {
    [[SWChatModel sharedInstance] connect];
    TabViewController *tabVC = [[TabViewController alloc] init];
    self.window.rootViewController = tabVC;
  }
  else
  {
    SWLoginVC *vc = [[SWLoginVC alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    self.window.rootViewController = nav;
  }
  
  [self.window makeKeyAndVisible];
  
  if (launchOptions[UIApplicationLaunchOptionsURLKey] == nil) {
    [FBSDKAppLinkUtility fetchDeferredAppLink:^(NSURL *url, NSError *error) {
      if (error) {
      }else if (url) {
      }else{
      }
    }];
  }
  [SMSSDK registerApp:@"17e13a6c92280" withSecret:@"1ee42041e0f56c2dafeb335fc64035a7"];  
  return [[FBSDKApplicationDelegate sharedInstance] application:application
                                  didFinishLaunchingWithOptions:launchOptions];;
}

- (void)registerRemoteNotification{
  [[UIApplication sharedApplication] registerForRemoteNotifications];
  [[UIApplication sharedApplication] registerUserNotificationSettings:
   [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeSound |UIUserNotificationTypeAlert)
                                     categories:[NSSet setWithArray:[[UIUserNotificationCategory alloc] actionsForContext:UIUserNotificationActionContextDefault]]]];
}

- (void)handleNotification:(NSDictionary *)message{
  [[SWNoticeModel sharedInstance] reloadNotices];
}

- (void)logout
{
  [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"jwt"];
  [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userId"];
  [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"rongToken"];
  [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userInfo"];
  [SWConfigManager sharedInstance].user = nil;
  SWLoginVC *vc = [[SWLoginVC alloc] init];
  UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
  self.window.rootViewController = nav;
  [[RCIMClient sharedRCIMClient] logout];
  self.window.rootViewController = nav;
}

- (void)applicationWillResignActive:(UIApplication *)application {
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
  [[SWNoticeModel sharedInstance] endRefreshing];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
  // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
  // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
  // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  [FBSDKAppEvents activateApp];
  [SWLocationManager checkLocation];
  [[SWNoticeModel sharedInstance] startRefreshing];
  [[SWNoticeModel sharedInstance] syncGetuiCID];
  [[UIApplication sharedApplication] cancelAllLocalNotifications];
  [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
  [FBSDKAppEvents activateApp];
}

- (void)applicationWillTerminate:(UIApplication *)application {
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
  NSString *urlString = [url absoluteString];
  if ([urlString length]>12 && [[urlString substringWithRange:NSMakeRange(0, [SWWeiboAPI length]+2)] isEqualToString:[@"wb" stringByAppendingString:SWWeiboAPI]]) {
    return [WeiboSDK handleOpenURL:url delegate:self];
  }
  return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                        openURL:url
                                              sourceApplication:sourceApplication
                                                     annotation:annotation];
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
  NSString *urlString = [url absoluteString];
  if ([urlString length]>12 && [[urlString substringWithRange:NSMakeRange(0, [SWWeiboAPI length]+2)] isEqualToString:[@"wb" stringByAppendingString:SWWeiboAPI]]) {
    return [WeiboSDK handleOpenURL:url delegate:self];
  }
  
  return YES;
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
  NSMutableString* token = [NSMutableString stringWithFormat:@"%@",deviceToken];
  [token replaceOccurrencesOfString:@" " withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [token length])];
  NSString *newToken = [token substringWithRange:NSMakeRange(1, [token length]-2)];
  [[NSUserDefaults standardUserDefaults] setValue:newToken forKey:@"deviceToken"];
  [[NSUserDefaults standardUserDefaults] synchronize];
  
  [GeTuiSdk registerDeviceToken:newToken];
  
  
  NSString *rong =
  [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<"
                                                         withString:@""]
    stringByReplacingOccurrencesOfString:@">"
    withString:@""]
   stringByReplacingOccurrencesOfString:@" "
   withString:@""];
  
  [[RCIMClient sharedRCIMClient] setDeviceToken:rong];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
  [[RCIMClient sharedRCIMClient] recordRemoteNotificationEvent:userInfo];
  [self handleNotification:userInfo];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
  //设置假deviceToken，为模拟器用的
  [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"deviceToken"];
  [[NSUserDefaults standardUserDefaults] synchronize];
  
  [GeTuiSdk registerDeviceToken:@""];
  [[RCIMClient sharedRCIMClient] setDeviceToken:@""];
}

- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
  [GeTuiSdk resume]; // 恢复个推 SDK 运行
  completionHandler(UIBackgroundFetchResultNewData);
}


- (void)didReceiveWeiboRequest:(WBBaseRequest *)request{
  
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response{
  if ([response isKindOfClass:[WBAuthorizeResponse class]]) {
    WBAuthorizeResponse *authResp = (WBAuthorizeResponse *)response;
    [[NSUserDefaults standardUserDefaults] setObject:response.userInfo forKey:@"WBUserInfo"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:authResp.accessToken forKey:@"access_token"];
    [params setObject:authResp.userID forKey:@"uid"];
    [WBHttpRequest requestWithURL:@"https://api.weibo.com/2/users/show.json"
                       httpMethod:@"GET"
                           params:params
                         delegate:self
                          withTag:@"getUserInfo"];
  }
}

- (void)request:(WBHttpRequest *)request didReceiveResponse:(NSURLResponse *)response{
  
}

- (void)request:(WBHttpRequest *)request didFinishLoadingWithResult:(NSString *)result{
  NSDictionary *resultDic = [result safeJsonDicFromJsonString];
  SWLoginWBAPI *api = [[SWLoginWBAPI alloc] init];
  api.name = [resultDic safeStringObjectForKey:@"screen_name"];
  api.gender = [[resultDic safeStringObjectForKey:@"gender"] isEqualToString:@"m"]?@2:@1;
  api.head = [resultDic safeStringObjectForKey:@"avatar_large"];
  NSDictionary *dic = [[NSUserDefaults standardUserDefaults] safeDicObjectForKey:@"WBUserInfo"];
  api.openid = [dic safeStringObjectForKey:@"uid"];
  api.token = [dic safeStringObjectForKey:@"access_token"];
  [SWHUD showWaiting];
  [api startWithModelClass:[LoginResponse class] completionBlock:^(ModelMessage *message) {
    [SWHUD hideWaiting];
    if (message.isSuccess) {
      TabViewController *tabVC = [[TabViewController alloc] init];
      [UIApplication sharedApplication].keyWindow.rootViewController = tabVC;
      [[NSUserDefaults standardUserDefaults] setSafeStringObject:((LoginResponse *)(message.object)).data.jwt
                                                          forKey:@"jwt"];
      [[NSUserDefaults standardUserDefaults] setSafeStringObject:((LoginResponse *)(message.object)).data.name
                                                          forKey:@"userName"];
      [[NSUserDefaults standardUserDefaults] setSafeStringObject:((LoginResponse *)(message.object)).data.userId
                                                          forKey:@"userId"];
      [[NSUserDefaults standardUserDefaults] setSafeStringObject:((LoginResponse *)(message.object)).data.rongToken
                                                          forKey:@"rongToken"];
      [[NSUserDefaults standardUserDefaults] setSafeStringObject:((LoginResponse *)(message.object)).data.head
                                                          forKey:@"userPicUrl"];
      [[NSUserDefaults standardUserDefaults] setSafeNumberObject:[NSNumber numberWithInt:((LoginResponse *)(message.object)).data.gender]
                                                          forKey:@"userGender"];
      [[NSUserDefaults standardUserDefaults] synchronize];
      [[SWConfigManager sharedInstance] getUser:((LoginResponse *)(message.object)).data.userId
                                completionBlock:^(SWFeedUserItem *user) {
                                  [SWConfigManager sharedInstance].user = user;
                                } failedBlock:^{
                                  
                                }];
      [[SWNoticeModel sharedInstance] syncGetuiCID];
      [[SWChatModel sharedInstance] connect];
    }else{
      [SWHUD showCommonToast:@"登錄失敗"];
    }
  }];
}

- (void)startGetuiSdkWith:(NSString *)appID appKey:(NSString *)appKey appSecret:(NSString *)appSecret {
  NSError *err = nil;
  //[1-1]:通过 AppId、 appKey 、appSecret 启动 SDK
  [GeTuiSdk startSdkWithAppId:appID
                       appKey:appKey
                    appSecret:appSecret
                     delegate:self];
  //[1-2]:设置是否后台运行开关
  [GeTuiSdk runBackgroundEnable:YES];
  //[1-3]:设置地理围栏功能,开启 LBS 定位服务和是否允许 SDK 弹出用户定位请求,请求
  //NSLocationAlwaysUsageDescription 权限,如果 UserVerify 设置为 NO,需第三方负责提示用户定位授权。
  [GeTuiSdk lbsLocationEnable:NO andUserVerify:NO];
  if (err) {
    
  }
}

- (void)GeTuiSdkDidRegisterClient:(NSString *)clientId{
  [[NSUserDefaults standardUserDefaults] setSafeStringObject:clientId forKey:@"GetuiCID"];
  [[NSUserDefaults standardUserDefaults] synchronize];
  
  [[SWNoticeModel sharedInstance] syncGetuiCID];
}

-(void)GeTuiSdkDidReceivePayload:(NSString*)payloadId andTaskId:(NSString*)taskId andMessageId:(NSString *)aMsgId fromApplication:(NSString *)appId
{
  [[SWNoticeModel sharedInstance] reloadNotices];
}

- (void)createFolders
{
  [[NSFileManager defaultManager] createDirectoryAtPath:IMAGEDPath withIntermediateDirectories:YES attributes:nil error:nil];
}

@end
