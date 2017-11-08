//
//  SWSearchFriendModel.m
//  SeeWorld
//
//  Created by Albert Lee on 9/2/15.
//  Copyright (c) 2015 SeeWorld. All rights reserved.
//

#import "SWSearchFriendModel.h"
#import "SWUserAddFollowAPI.h"
#import "SWUserRemoveFollowAPI.h"
#import "SWSearchFriendAPI.h"
@implementation SWSearchFriendModel{
  NSString *_currectSearchString;
}
- (id)init{
  if (self = [super init]) {
    self.users = [NSMutableArray array];
  }
  return self;
}

- (void)searchUserByName:(NSString *)name{
  if (name.length==0) {
    _currectSearchString = @"";
    [self.users removeAllObjects];
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchFriendDidReturnResults:string:)]) {
      [self.delegate searchFriendDidReturnResults:self string:name];
    }
    return;
  }
  
  if (![name isEqualToString:_currectSearchString]) {
    _currectSearchString = [name copy];
    SWSearchFriendAPI *api = [[SWSearchFriendAPI alloc] init];
    api.query = name?name:@"";
    __weak typeof(self)wSelf = self;
    [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
      NSDictionary *dic = [request.responseString safeJsonDicFromJsonString];
      NSArray *data = [dic safeArrayObjectForKey:@"data"];
      
      [wSelf.users removeAllObjects];
      for (NSInteger i=0; i<data.count; i++) {
        [wSelf.users addObject:[SWFeedUserItem feedUserItemByDic:[data safeDicObjectAtIndex:i]]];
      }
      
      if (wSelf.delegate && [wSelf.delegate respondsToSelector:@selector(searchFriendDidReturnResults:string:)]) {
        [wSelf.delegate searchFriendDidReturnResults:wSelf string:name];
      }
    } failure:^(YTKBaseRequest *request) {
      
    }];
  }
}

- (void)processFollow:(SWFeedLikeItem *)likeItem{
  SWUserRelationType type = [likeItem.user.relation integerValue];
  
  if (type==SWUserRelationTypeFollowing||
      type==SWUserRelationTypeInterFollow) {
    SWUserAddFollowAPI *api = [[SWUserAddFollowAPI alloc] init];
    api.uId = likeItem.user.uId;
    [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
      [SWUserAddFollowAPI showSuccessTip];
    } failure:^(YTKBaseRequest *request) {
      
    }];
  }else{
    SWUserRemoveFollowAPI *api = [[SWUserRemoveFollowAPI alloc] init];
    api.uId = likeItem.user.uId;
    [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
      
    } failure:^(YTKBaseRequest *request) {
      
    }];
  }
}
@end
