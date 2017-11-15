//
//  SWTagFeedItem.m
//  SeeWorld
//
//  Created by Albert Lee on 9/3/15.
//  Copyright (c) 2015 SeeWorld. All rights reserved.
//

#import "SWTagFeedItem.h"

@implementation SWTagFeedItem
+ (SWTagFeedItem *)tagFeedItemByDic:(NSDictionary *)dic prefetch:(BOOL)prefetch{
  SWTagFeedItem *feedItem = [[SWTagFeedItem alloc] init];
  feedItem.tag = [SWTagInfoItem tagInfoItemByDic:[dic safeDicObjectForKey:@"tag"]];
  feedItem.feedList = [SWHomeFeedItem homeFeedItemFromDic:[dic safeDicObjectForKey:@"feedList"]];
  if (feedItem.tag.tagId.integerValue == 0) {
      feedItem.feedList = [SWHomeFeedItem homeFeedItemFromDic:dic prefetch:prefetch];
  }
  return feedItem;
}
@end

@implementation SWTagInfoItem

+ (SWTagInfoItem *)tagInfoItemByDic:(NSDictionary *)dic{
  SWTagInfoItem *tagInfo = [[SWTagInfoItem alloc] init];
  tagInfo.tagId = [dic safeNumberObjectForKey:@"tagId"];
  tagInfo.tagName = [dic safeStringObjectForKey:@"tagName"];
  tagInfo.feedCount = [dic safeNumberObjectForKey:@"feedCount"];
  return tagInfo;
}

@end
