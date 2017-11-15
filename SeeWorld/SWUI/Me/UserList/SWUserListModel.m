//
//  SWUserListModel.m
//  SeeWorld
//
//  Created by Albert Lee on 15/11/2017.
//  Copyright © 2017 SeeWorld. All rights reserved.
//

#import "SWUserListModel.h"
#import "GetFollowsApi.h"
#import "GetFollowersApi.h"
#import "SWHomeRecommandUserAPI.h"
@implementation SWUserListModel
- (id)init{
  if (self = [super init]) {
    _users = [NSMutableArray array];
  }
  return self;
}

- (void)getUsers{
  if (_type == SWUserListAPITypeGetFollower) {
    GetFollowersApi *api = [[GetFollowersApi alloc] init];
    api.userId = _uId;
    __weak typeof(self)wSelf = self;
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
      [wSelf loadSucceedWithRequest:request];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
      [wSelf loadFailedWithRequest:request];
    }];
  }else if (_type == SWUserListAPITypeGetFollowing){
    GetFollowsApi *api = [[GetFollowsApi alloc] init];
    api.userId = _uId;
    __weak typeof(self)wSelf = self;
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
      [wSelf loadSucceedWithRequest:request];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
      [wSelf loadFailedWithRequest:request];
    }];
  }else if (_type == SWUserListAPITypeGetRecommand){
    __weak typeof(self)wSelf = self;
    SWHomeRecommandUserAPI *api = [[SWHomeRecommandUserAPI alloc] init];
    api.num = 50;
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
      [wSelf loadSucceedWithRequest:request];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
      [wSelf loadFailedWithRequest:request];
    }];
  }
}

- (void)loadSucceedWithRequest:(YTKBaseRequest *)request{
  NSDictionary *dic = [request.responseString safeJsonDicFromJsonString];
  NSArray *data = [dic safeArrayObjectForKey:@"data"];
  [self.users removeAllObjects];
  for (NSInteger i=0; i<data.count; i++) {
    SWFeedUserItem *user = [SWFeedUserItem feedUserItemByDic:[data safeObjectAtIndex:i]];
    [self.users safeAddObject:user];
  }
  if (self.delegate && [self.delegate respondsToSelector:@selector(userListModelDidLoadUsers:)]) {
    [self.delegate userListModelDidLoadUsers:self];
  }
}

- (void)loadFailedWithRequest:(YTKBaseRequest *)request{
  if (self.delegate && [self.delegate respondsToSelector:@selector(userListModelDidFailLoadUsers:)]) {
    [self.delegate userListModelDidFailLoadUsers:self];
  }
}
@end
