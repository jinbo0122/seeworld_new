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
  return [SWHomeFeedItem homeFeedItemFromDic:dic prefetch:NO];
}

+ (SWHomeFeedItem *)homeFeedItemFromDic:(NSDictionary *)dic prefetch:(BOOL)needPrefetch{
  SWHomeFeedItem *homeFeedItem = [[SWHomeFeedItem alloc] init];
  homeFeedItem.lastFeedID = [dic safeNumberObjectForKey:@"lastFeedID"];
  homeFeedItem.hasMore = [dic safeNumberObjectForKey:@"hasMore"];
  homeFeedItem.feeds = [NSMutableArray array];
  for (NSInteger i=0; i<[[dic safeArrayObjectForKey:@"feeds"] count]; i++) {
    NSDictionary *feedDic = [[dic safeArrayObjectForKey:@"feeds"] safeDicObjectAtIndex:i];
    [homeFeedItem.feeds safeAddObject:[SWFeedItem feedItemByDic:feedDic]];
  }
  
  if (needPrefetch) {
    for (SWFeedItem *feed in homeFeedItem.feeds) {
      if (![feed.feed.imageHeight integerValue]) {
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[feed.feed.picUrl stringByAppendingString:FEED_SMALL]]];
        UIImage *image = [UIImage imageWithData:data];
        if ([image isKindOfClass:[UIImage class]]) {
          [[SDImageCache sharedImageCache] storeImageDataToDisk:data forKey:feed.feed.picUrl];
          feed.feed.imageWidth = @(image.size.width);
          feed.feed.imageHeight = @(image.size.height);
        }
      }
    }
  }
  return homeFeedItem;
}
@end
