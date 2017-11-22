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
      if (feed.feed.photos.count == 1) {
        SWFeedImageItem *photoItem = [feed.feed.photos safeObjectAtIndex:0];
        if (photoItem.width == 0) {
          UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:[photoItem.picUrl stringByAppendingString:FEED_SMALL]];
          if (image) {
            photoItem.width = image.size.width;
            photoItem.height = image.size.height;
            
          }else{
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[photoItem.picUrl stringByAppendingString:FEED_SMALL]]];
            image = [UIImage imageWithData:data];
            if ([image isKindOfClass:[UIImage class]]) {
              [[SDImageCache sharedImageCache] storeImageDataToDisk:data forKey:photoItem.picUrl];
              photoItem.width = image.size.width;
              photoItem.height = image.size.height;
            }else{
              photoItem.width = UIScreenWidth;
              photoItem.height = UIScreenWidth;
            }
          }
        }
      }
    }
  }
  return homeFeedItem;
}
@end
