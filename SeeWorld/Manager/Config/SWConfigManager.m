//
//  SWConfigManager.m
//  SeeWorld
//
//  Created by Albert Lee on 5/16/16.
//  Copyright © 2016 SeeWorld. All rights reserved.
//

#import "SWConfigManager.h"
#import "GetUserInfoApi.h"
@implementation SWConfigManager
DEF_SINGLETON;

- (id)init{
  if (self = [super init]) {
    NSString *uId = [[NSUserDefaults standardUserDefaults] safeStringObjectForKey:@"userId"];
    self.user = [SWFeedUserItem feedUserItemByDic:[[NSUserDefaults standardUserDefaults] safeDicObjectForKey:@"userInfo"]];
    if (uId.length>0) {
      __weak typeof(self)wSelf = self;
      [self getUser:uId completionBlock:^(SWFeedUserItem *user){
        wSelf.user = user;
        [[NSUserDefaults standardUserDefaults] setObject:[user dicValue] forKey:@"userInfo"];
        [[NSUserDefaults standardUserDefaults] synchronize];
      } failedBlock:^{
        
      }];
    }
  }
  return self;
}

- (void)getUser:(NSString *)uId completionBlock:(COMPLETION_BLOCK_WITH_USER)completionBlock failedBlock:(COMPLETION_BLOCK)failedBlock{
  GetUserInfoApi *api = [[GetUserInfoApi alloc] init];
  api.userId = uId;
  [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
    SWFeedUserItem *user = [SWFeedUserItem feedUserItemByDic:[[request.responseString safeJsonDicFromJsonString] safeDicObjectForKey:@"data"]];
    if (completionBlock && user.uId.integerValue>0) {
      completionBlock(user);
    }else{
      if (failedBlock) {
        failedBlock();
      }
    }
  } failure:^(YTKBaseRequest *request) {
    if (failedBlock) {
      failedBlock();
    }
  }];
}

- (void)saveUser:(SWFeedUserItem *)user{
  [[NSUserDefaults standardUserDefaults] setObject:[user vcDicValue] forKey:[NSString stringWithFormat:@"user_cache_%@",user.uId]];
  [[NSUserDefaults standardUserDefaults] synchronize];
}

- (SWFeedUserItem *)userByUId:(NSNumber *)uId{
  if (!uId) {
    return nil;
  }
  NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"user_cache_%@",uId]];
  if (!dic) {
    return nil;
  }
  SWFeedUserItem *item = [SWFeedUserItem feedUserItemByDic:dic];
  return item;
}
@end
