//
//  SWChatModel.m
//  SeeWorld
//
//  Created by Albert Lee on 12/22/15.
//  Copyright © 2015 SeeWorld. All rights reserved.
//

#import "SWChatModel.h"
#import "GetUserInfoApi.h"
#import "SWRongTokenAPI.h"
//#define RongCloudAppKey @"8brlm7ufrhvc3"
#define RongCloudAppKey @"lmxuhwagx9j2d"
@interface SWChatModel()<RCIMReceiveMessageDelegate,RCIMUserInfoDataSource,RCIMGroupInfoDataSource>

@end

@implementation SWChatModel{
  BOOL _hasInit;
}
+ (SWChatModel *)sharedInstance{
  static dispatch_once_t once;
  static SWChatModel   *chatModel = nil;
  dispatch_once(&once, ^{
    chatModel = [[SWChatModel alloc] init];
  });
  return chatModel;
}

- (id)init{
  if (self = [super init]) {
    self.chats = [NSMutableArray array];
  }
  return self;
}

- (void)connect{
  if (!_hasInit) {
    [[RCIM sharedRCIM] initWithAppKey:RongCloudAppKey];
    _hasInit = YES;
  }
  NSString *uId = [[NSUserDefaults standardUserDefaults] safeStringObjectForKey:@"userId"];
  NSString *name = [[NSUserDefaults standardUserDefaults] safeStringObjectForKey:@"userName"];
  NSString *picUrl = [[NSUserDefaults standardUserDefaults] safeStringObjectForKey:@"userPicUrl"];
  NSString *token = [[NSUserDefaults standardUserDefaults] safeStringObjectForKey:@"rongToken"];
  
  __weak typeof(self)wSelf = self;
  [RCIM sharedRCIM].currentUserInfo = [[RCUserInfo alloc] initWithUserId:uId name:name portrait:picUrl];
  [[RCIM sharedRCIM] connectWithToken:token
                              success:^(NSString *userId) {
                                [[NSNotificationCenter defaultCenter] postNotificationName:@"RCIMConnected" object:nil];
                              } error:^(RCConnectErrorCode status) {
                                [wSelf getToken];
                              } tokenIncorrect:^{
                                [wSelf getToken];
                              }];
  [RCIM sharedRCIM].receiveMessageDelegate = self;
  [RCIM sharedRCIM].globalNavigationBarTintColor = [UIColor colorWithRGBHex:0xffffff];
  [RCIM sharedRCIM].globalMessageAvatarStyle = RC_USER_AVATAR_CYCLE;
  [RCIM sharedRCIM].enableMessageAttachUserInfo=YES;
  [[RCIM sharedRCIM] setUserInfoDataSource:self];
  [[RCIM sharedRCIM] setGroupInfoDataSource:self];
}

- (void)getToken{
  SWRongTokenAPI *api = [[SWRongTokenAPI alloc] init];
  api.name = [[NSUserDefaults standardUserDefaults] safeStringObjectForKey:@"userName"];
  api.picUrl = [[NSUserDefaults standardUserDefaults] safeStringObjectForKey:@"userPicUrl"];
  
  __weak typeof(self)wSelf = self;
  [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
    NSDictionary *dic = [request.responseString safeJsonDicFromJsonString];
    NSString *token = [[dic safeDicObjectForKey:@"data"] safeStringObjectForKey:@"rongtoken"];
    if ([[token substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"\""]&&token.length>2) {
      token = [token substringWithRange:NSMakeRange(1, token.length-2)];
    }
    [[NSUserDefaults standardUserDefaults] setSafeStringObject:token forKey:@"rongToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [wSelf connect];
  } failure:^(YTKBaseRequest *request) {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
      [wSelf getToken];
    });
  }];
}

- (void)getChats{
  __weak typeof(self)wSelf = self;
  
  if (wSelf.delegate && [wSelf.delegate respondsToSelector:@selector(chatModelDidLoadChats:)]) {
    [wSelf.delegate chatModelDidLoadChats:wSelf];
  }
}

- (void)saveUser:(NSString *)uId name:(NSString *)name picUrl:(NSString *)picUrl{
  if (!uId||!name||!picUrl) {
    return;
  }
  [[NSUserDefaults standardUserDefaults] setObject:@{@"name":name,@"picUrl":picUrl,@"time":[NSNumber numberWithDouble:[NSDate currentTime]]}
                                            forKey:uId];
  [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)onRCIMReceiveMessage:(RCMessage *)message left:(int)left{
  dispatch_async(dispatch_get_main_queue(), ^{
    [TabViewController dotAppearance];
  });
}

- (void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *))completion{
  if (!completion) {
    return;
  }
  
  if (!userId) {
    completion(nil);
    return;
  }
  
  NSDictionary *dic = [[NSUserDefaults standardUserDefaults] safeDicObjectForKey:userId];
  NSString *name = [dic safeStringObjectForKey:@"name"];
  NSString *picUrl = [dic safeStringObjectForKey:@"picUrl"];
  NSTimeInterval time = [[dic safeNumberObjectForKey:@"time"] doubleValue];
  if (name.length>0 && picUrl.length>0 && [NSDate currentTime]-time<3600) {
    RCUserInfo *user = [[RCUserInfo alloc]init];
    user.userId = userId;
    user.name = name;
    user.portraitUri = picUrl;
    return completion(user);
  }else{
    GetUserInfoApi *api = [[GetUserInfoApi alloc] init];
    api.userId = userId;
    [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
      NSDictionary *dic = [request.responseString safeJsonDicFromJsonString];
      NSDictionary *user = [dic safeDicObjectForKey:@"data"];
      [[SWChatModel sharedInstance] saveUser:userId name:[user safeStringObjectForKey:@"name"] picUrl:[user safeStringObjectForKey:@"head"]];
      RCUserInfo *userInfo = [[RCUserInfo alloc] init];
      userInfo.userId = userId;
      userInfo.name = [user safeStringObjectForKey:@"name"];
      userInfo.portraitUri = [user safeStringObjectForKey:@"head"];
      return completion(userInfo);
    } failure:^(YTKBaseRequest *request) {
      completion(nil);
    }];
  }
}

- (void)getGroupInfoWithGroupId:(NSString *)groupId completion:(void (^)(RCGroup *))completion{
  
}
@end
