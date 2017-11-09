//
//  SWHomeFeedModel.m
//  SeeWorld
//
//  Created by Albert Lee on 8/31/15.
//  Copyright (c) 2015 SeeWorld. All rights reserved.
//

#import "SWHomeFeedModel.h"
#import "SWFeedItem.h"
#import "SWHomeFeedAPI.h"
#import "SWUserAddFollowAPI.h"
#import "SWHomeRecommandUserAPI.h"
#import "SWHomeFeedItem.h"
#import "SWFeedDislikeAPi.h"
#import "SWFeedLikeAPI.h"
@implementation SWHomeFeedModel
- (id)init{
  if (self = [super init]) {
    self.feeds = [NSMutableArray array];
    NSDictionary *feeds = [NSDictionary readFromPlistFile:@"HomeFeedData"];
    if (feeds) {
      SWHomeFeedItem *homeFeedItem = [SWHomeFeedItem homeFeedItemFromDic:feeds];
      [self.feeds addObjectsFromArray:homeFeedItem.feeds];
    }
  }
  return self;
}

- (void)getLatestFeeds{
  [self getFeedsByFeedId:@0];
}

- (void)loadMoreFeeds{
  if (![self hasMore]) {
    return;
  }
  
  if ([self isLoading]) {
    return;
  }
  
  self.isLoading = YES;
  [self getFeedsByFeedId:self.lastFeedId];
}

- (void)getFeedsByFeedId:(NSNumber *)feedId{
  __weak typeof(self)wSelf = self;
  SWHomeFeedAPI *homeFeedAPI = [[SWHomeFeedAPI alloc] init];
  homeFeedAPI.lastFeedId = feedId;
  [homeFeedAPI startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
    NSDictionary *dic = [request.responseString safeJsonDicFromJsonString];
    
    SWHomeFeedItem *homeFeedItem = [SWHomeFeedItem homeFeedItemFromDic:[dic safeDicObjectForKey:@"data"]];
    wSelf.hasMore = [homeFeedItem.hasMore boolValue];
    wSelf.lastFeedId = homeFeedItem.lastFeedID;
    
    if ([feedId integerValue]==0) {
      [wSelf.feeds removeAllObjects];
      
      [[dic safeDicObjectForKey:@"data"] writeToPlistFile:@"HomeFeedData"];
    }
    
    [wSelf.feeds addObjectsFromArray:homeFeedItem.feeds];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
      wSelf.isLoading = NO;
    });
    if (wSelf.delegate && [wSelf.delegate respondsToSelector:@selector(homeFeedModelDidLoadContents:)]) {
      [wSelf.delegate homeFeedModelDidLoadContents:wSelf];
    }
  } failure:^(YTKBaseRequest *request) {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
      wSelf.isLoading = NO;
    });
    if (wSelf.delegate && [wSelf.delegate respondsToSelector:@selector(homeFeedModelDidLoadContents:)]) {
      [wSelf.delegate homeFeedModelDidLoadContents:wSelf];
    }
  }];
}

- (void)getRecommandUser{
  __weak typeof(self)wSelf = self;
  SWHomeRecommandUserAPI *recommandAPI = [[SWHomeRecommandUserAPI alloc] init];
  [recommandAPI startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
    NSDictionary *dic = [request.responseString safeJsonDicFromJsonString];
    NSArray *data = [dic safeArrayObjectForKey:@"data"];
    if (data.count>0) {
      SWFeedUserItem *user = [SWFeedUserItem feedUserItemByDic:[[dic safeArrayObjectForKey:@"data"] safeDicObjectAtIndex:0]];
      if (wSelf.delegate && [wSelf.delegate respondsToSelector:@selector(homeFeedModelDidRecommandUser:)]) {
        [wSelf.delegate homeFeedModelDidRecommandUser:user];
      }
    }
    
    if(isFakeDataOn){
      if (wSelf.delegate && [wSelf.delegate respondsToSelector:@selector(homeFeedModelDidRecommandUser:)]) {
        [wSelf.delegate homeFeedModelDidRecommandUser:[SWFeedUserItem myself]];
      }
    }
    
  } failure:^(YTKBaseRequest *request) {
    
  }];
}

- (void)addFollowUser:(SWFeedUserItem *)userItem{
  //加关注接口
  SWUserAddFollowAPI *addFollow = [[SWUserAddFollowAPI alloc] init];
  addFollow.uId = userItem.uId;
  [addFollow startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
    [SWUserAddFollowAPI showSuccessTip];
  } failure:^(YTKBaseRequest *request) {
    
  }];
  
  //刷新推荐
  __weak typeof(self)wSelf = self;
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    [wSelf getRecommandUser];
  });
}


- (void)likeClickedByRow:(NSInteger)row{
  SWFeedItem *feed = [self.feeds safeObjectAtIndex:row];
  
  if ([feed.isLiked boolValue]) {
    feed.isLiked = @0;
    for (NSInteger i=0; i<feed.likes.count; i++) {
      SWFeedLikeItem *likeItem = [feed.likes safeObjectAtIndex:i];
      if ([likeItem.user.uId isEqualToNumber:[SWFeedUserItem myself].uId]||
          [likeItem.user.relation integerValue]==SWUserRelationTypeSelf) {
        [feed.likes removeObjectAtIndex:i];
        break;
      }
    }
    feed.likeCount = [NSNumber numberWithInteger:feed.likeCount.integerValue-1];
    SWFeedDislikeAPi *api = [[SWFeedDislikeAPi alloc] init];
    api.fId = feed.feed.fId;
    [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
      
    } failure:^(YTKBaseRequest *request) {
      
    }];
    
  }else{
    feed.isLiked = @1;
    feed.likeCount = [NSNumber numberWithInteger:feed.likeCount.integerValue+1];
    SWFeedLikeAPI *api = [[SWFeedLikeAPI alloc] init];
    api.fId = feed.feed.fId;
    [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
      
    } failure:^(YTKBaseRequest *request) {
      
    }];
    
    SWFeedLikeItem *likeItem = [[SWFeedLikeItem alloc] init];
    likeItem.user = [SWFeedUserItem myself];
    likeItem.time = [NSNumber numberWithDouble:[NSDate currentTime]];
    [feed.likes safeInsertObject:likeItem atIndex:0];
  }
  
  if (self.delegate && [self.delegate respondsToSelector:@selector(homeFeedModelDidPressLike:row:)]) {
    [self.delegate homeFeedModelDidPressLike:self row:row];
  }
}
@end