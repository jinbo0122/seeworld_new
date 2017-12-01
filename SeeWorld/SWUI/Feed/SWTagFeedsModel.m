//
//  SWTagFeedsModel.m
//  SeeWorld
//
//  Created by Albert Lee on 9/3/15.
//  Copyright (c) 2015 SeeWorld. All rights reserved.
//

#import "SWTagFeedsModel.h"
#import "SWTagFeedAPI.h"
#import "SWTagFeedItem.h"
#import "SWFeedLikeAPI.h"
#import "SWFeedDislikeAPi.h"
@implementation SWTagFeedsModel
@synthesize feeds,userId;
- (id)init{
  if (self = [super init]) {
    self.feeds = [NSMutableArray array];
  }
  return self;
}

- (void)setIsFromNotice:(BOOL)isFromNotice{
  _isFromNotice = isFromNotice;
  SWFeedSingleAPI *api = [[SWFeedSingleAPI alloc] init];
  api.fId = [(SWFeedItem *)[self.feeds safeObjectAtIndex:0] feed].fId;
  __weak typeof(self)wSelf = self;
  [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
    NSDictionary *dic = [request.responseString safeJsonDicFromJsonString];
    [wSelf.feeds safeReplaceObjectAtIndex:0 withObject:[SWFeedItem feedItemByDic:[dic safeDicObjectForKey:@"data"]]];
    if (wSelf.delegate && [wSelf.delegate respondsToSelector:@selector(tagFeedModelDidNeedRefresh:)]) {
      [wSelf.delegate tagFeedModelDidNeedRefresh:wSelf];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadCollectionLike" object:nil];
  } failure:^(YTKBaseRequest *request) {
    
  }];
}

- (void)loadCache{
  if (!self.userId) {
    return;
  }
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
  NSString *path = paths.count > 0? [paths objectAtIndex:0]:@"";
  NSString *fullPath = [path stringByAppendingPathComponent:[@"user_feed_cache_" stringByAppendingString:self.userId]];
  NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:fullPath];
  SWTagFeedItem *tagFeedItem = [SWTagFeedItem tagFeedItemByDic:[dic safeDicObjectForKey:@"data"] prefetch:NO];
  self.hasMore = [tagFeedItem.feedList.hasMore boolValue];
  self.lastFeedId = tagFeedItem.feedList.lastFeedID;
  if ([tagFeedItem.tag.feedCount integerValue]>0) {
    self.feedCount = tagFeedItem.tag.feedCount;
  }
  
  if ([tagFeedItem.feedList.feeds count]>0) {
    for (SWFeedItem *feed in tagFeedItem.feedList.feeds) {
      SWFeedType type = feed.feed.type;
      if (type == SWFeedTypeImage && feed.feed.photos.count == 1) {
        SWFeedImageItem *photoItem = [feed.feed.photos safeObjectAtIndex:0];
        if ([photoItem isKindOfClass:[SWFeedImageItem class]] && photoItem.width) {
          [self.feeds addObject:feed];
        }
      }else{
        [self.feeds addObject:feed];
      }
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(tagFeedModelDidLoadContents:)]) {
      [self.delegate tagFeedModelDidLoadContents:self];
    }
  }
}

- (void)getLatestTagFeeds{
  [self getFeedsByFeedId:@0];
}

- (void)getMoreTagFeeds{
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
  SWTagFeedAPI *api = [[SWTagFeedAPI alloc] init];
  api.lastFeedId = feedId;
  api.tagId = self.tagItem.tagId;
  api.userId = self.userId;
  [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
      NSDictionary *dic = [request.responseString safeJsonDicFromJsonString];
      
      SWTagFeedItem *tagFeedItem = [SWTagFeedItem tagFeedItemByDic:[dic safeDicObjectForKey:@"data"] prefetch:YES];
      wSelf.hasMore = [tagFeedItem.feedList.hasMore boolValue];
      wSelf.lastFeedId = tagFeedItem.feedList.lastFeedID;
      
      if ([feedId integerValue]==0) {
        [wSelf.feeds removeAllObjects];
      }
      
      if ([tagFeedItem.tag.feedCount integerValue]>0) {
        wSelf.feedCount = tagFeedItem.tag.feedCount;
      }
      
      [wSelf.feeds addObjectsFromArray:tagFeedItem.feedList.feeds];
      
      if ([feedId integerValue] == 0 && wSelf.userId) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *path = paths.count > 0? [paths objectAtIndex:0]:@"";
        NSString *fullPath = [path stringByAppendingPathComponent:[@"user_feed_cache_" stringByAppendingString:wSelf.userId]];
        BOOL Succ = [dic writeToFile:fullPath
                          atomically:YES];
        NSLog(@"save succ %d",Succ?1:0);
      }
      dispatch_async(dispatch_get_main_queue(), ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
          wSelf.isLoading = NO;
        });
        if (wSelf.delegate && [wSelf.delegate respondsToSelector:@selector(tagFeedModelDidLoadContents:)]) {
          [wSelf.delegate tagFeedModelDidLoadContents:wSelf];
        }
      });
    });
  } failure:^(YTKBaseRequest *request) {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
      wSelf.isLoading = NO;
    });
    if (wSelf.delegate && [wSelf.delegate respondsToSelector:@selector(tagFeedModelDidLoadContents:)]) {
      [wSelf.delegate tagFeedModelDidLoadContents:wSelf];
    }
  }];
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
        feed.likeCount = [NSNumber numberWithInteger:feed.likeCount.integerValue-1];
        break;
      }
    }
    
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
  
  if (self.delegate && [self.delegate respondsToSelector:@selector(tagFeedModelDidPressLike:row:)]) {
    [self.delegate tagFeedModelDidPressLike:self row:row];
  }else{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadCollectionLike" object:nil];
  }
}
@end
