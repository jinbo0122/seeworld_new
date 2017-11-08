//
//  SWExploreModel.m
//  SeeWorld
//
//  Created by Albert Lee on 9/9/15.
//  Copyright (c) 2015 SeeWorld. All rights reserved.
//

#import "SWExploreModel.h"
#import "SWHomeFeedAPI.h"
#import "SWHomeFeedItem.h"

#import "SWFeedLikeAPI.h"
#import "SWUserAddFollowAPI.h"
#import "SWFeedDislikeAPi.h"
#import "SWExploreAPI.h"
#import "SWNearbyAPI.h"
@interface SWExploreModel()
@property(nonatomic, assign)NSInteger currentPage;
@end

@implementation SWExploreModel
- (id)init{
  self = [super init];
  if (self) {
    self.feeds = [NSMutableArray array];
    self.lastFeedId = @0;
  }
  return self;
}

- (void)onRefreshed:(NSTimer *)timer{
  if (self.delegate && [self.delegate respondsToSelector:@selector(exploreModelDidLetRefreshAvailable:)]) {
    [self.delegate exploreModelDidLetRefreshAvailable:self];
  }
}

- (void)getLatestFeeds{
  [self getPhotosByFId:@0];
}

- (void)getNextPageFeeds{
  if (self.hasMore) {
    [self getPhotosByFId:self.lastFeedId];
  }
}

- (void)getPhotosByFId:(NSNumber *)feedId{
  __weak typeof(self)wSelf = self;
  
  if (self.currentSegIndex==0) {
    SWExploreAPI *api = [[SWExploreAPI alloc] init];
    api.lastFeedId = feedId;
    [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
      NSDictionary *dic = [request.responseString safeJsonDicFromJsonString];
      
      SWHomeFeedItem *homeFeedItem = [SWHomeFeedItem homeFeedItemFromDic:[dic safeDicObjectForKey:@"data"]];
      wSelf.hasMore = [homeFeedItem.hasMore boolValue];
      wSelf.lastFeedId = homeFeedItem.lastFeedID;
      
      if ([feedId integerValue]==0) {
        [wSelf.feeds removeAllObjects];
      }
      
      [wSelf.feeds addObjectsFromArray:homeFeedItem.feeds];
      
      if (wSelf.delegate && [wSelf.delegate respondsToSelector:@selector(exploreModelDidGetPhotos:feedId:)]) {
        [wSelf.delegate exploreModelDidGetPhotos:wSelf feedId:feedId];
      }
    } failure:^(YTKBaseRequest *request) {
      if (wSelf.delegate && [wSelf.delegate respondsToSelector:@selector(exploreModelDidFailGetPhotos:)]) {
        [wSelf.delegate exploreModelDidFailGetPhotos:wSelf];
      }
    }];
  }else{
    SWNearbyAPI *api = [[SWNearbyAPI alloc] init];
    api.distance = @10000;
    [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
      NSDictionary *dic = [request.responseString safeJsonDicFromJsonString];
      NSArray *feeds = [dic safeArrayObjectForKey:@"data"];
      
      if ([feedId integerValue]==0) {
        [wSelf.feeds removeAllObjects];
      }
      
      for (NSDictionary *feedDic in feeds) {
        [wSelf.feeds safeAddObject:[SWFeedItem feedItemByDic:feedDic]];
      }
    
      if (wSelf.delegate && [wSelf.delegate respondsToSelector:@selector(exploreModelDidGetPhotos:feedId:)]) {
        [wSelf.delegate exploreModelDidGetPhotos:wSelf feedId:feedId];
      }
    } failure:^(YTKBaseRequest *request) {
      if (wSelf.delegate && [wSelf.delegate respondsToSelector:@selector(exploreModelDidFailGetPhotos:)]) {
        [wSelf.delegate exploreModelDidFailGetPhotos:wSelf];
      }
    }];
  }
}

- (void)operateFeed:(SWFeedItem *)feedItem like:(BOOL)like{
  if (like) {
    feedItem.isLiked = @1;
    feedItem.likeCount = [NSNumber numberWithInteger:feedItem.likeCount.integerValue+1];

    SWFeedLikeAPI *api = [[SWFeedLikeAPI alloc] init];
    api.fId = feedItem.feed.fId;
    [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
      
    } failure:^(YTKBaseRequest *request) {
      
    }];
    
    SWUserAddFollowAPI *api2 = [[SWUserAddFollowAPI alloc] init];
    api2.uId = feedItem.user.uId;
    [api2 startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
//      [SWUserAddFollowAPI showSuccessTip];
    } failure:^(YTKBaseRequest *request) {
      
    }];
  }else{
    feedItem.isLiked = @0;
    feedItem.likeCount = [NSNumber numberWithInteger:feedItem.likeCount.integerValue-1];
    
    SWFeedDislikeAPi *api = [[SWFeedDislikeAPi alloc] init];
    api.fId = feedItem.feed.fId;
    [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
      
    } failure:^(YTKBaseRequest *request) {
      
    }];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(exploreModelDidOperateFeed:)]) {
      [self.delegate exploreModelDidOperateFeed:feedItem];
    }
  }
}

- (void)setCurrentSegIndex:(NSInteger)currentSegIndex{
  _currentSegIndex = currentSegIndex;
  
  _lastFeedId = @0;
  _hasMore = YES;
  [_feeds removeAllObjects];
  _currentIndex = 0;
  
  [self getLatestFeeds];
}
@end
