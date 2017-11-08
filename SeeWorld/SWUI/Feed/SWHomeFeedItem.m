//
//  SWHomeFeedItem.m
//  SeeWorld
//
//  Created by Albert Lee on 8/31/15.
//  Copyright (c) 2015 SeeWorld. All rights reserved.
//

#import "SWHomeFeedItem.h"

@implementation SWHomeFeedItem
+ (SWHomeFeedItem *)homeFeedItemFromDic:(NSDictionary *)dic{
  SWHomeFeedItem *homeFeedItem = [[SWHomeFeedItem alloc] init];
  homeFeedItem.lastFeedID = [dic safeNumberObjectForKey:@"lastFeedID"];
  homeFeedItem.hasMore = [dic safeNumberObjectForKey:@"hasMore"];
  homeFeedItem.feeds = [NSMutableArray array];
  for (NSInteger i=0; i<[[dic safeArrayObjectForKey:@"feeds"] count]; i++) {
    NSDictionary *feedDic = [[dic safeArrayObjectForKey:@"feeds"] safeDicObjectAtIndex:i];
    [homeFeedItem.feeds safeAddObject:[SWFeedItem feedItemByDic:feedDic]];
  }
  return homeFeedItem;
}
@end
