//
//  SWTagFeedItem.m
//  SeeWorld
//
//  Created by Albert Lee on 9/3/15.
//  Copyright (c) 2015 SeeWorld. All rights reserved.
//

#import "SWTagFeedItem.h"

@implementation SWTagFeedItem
+ (SWTagFeedItem *)tagFeedItemByDic:(NSDictionary *)dic{
  SWTagFeedItem *feedItem = [[SWTagFeedItem alloc] init];
  feedItem.tag = [SWTagInfoItem tagInfoItemByDic:[dic safeDicObjectForKey:@"tag"]];
  feedItem.feedList = [SWHomeFeedItem homeFeedItemFromDic:[dic safeDicObjectForKey:@"feedList"]];
  if (feedItem.tag.tagId.integerValue == 0) {
      feedItem.feedList = [SWHomeFeedItem homeFeedItemFromDic:dic];
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