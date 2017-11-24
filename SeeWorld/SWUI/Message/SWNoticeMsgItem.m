//
//  SWNoticeMsgItem.m
//  SeeWorld
//
//  Created by Albert Lee on 9/25/15.
//  Copyright © 2015 SeeWorld. All rights reserved.
//

#import "SWNoticeMsgItem.h"

@implementation SWNoticeMsgItem
+ (SWNoticeMsgItem *)msgItemByDic:(NSDictionary *)feedDic{
  SWNoticeMsgItem *msg = [[SWNoticeMsgItem alloc] init];
  msg.mId = [feedDic safeNumberObjectForKey:@"id"];
  msg.status = [feedDic safeNumberObjectForKey:@"status"];
  msg.mType = [feedDic safeNumberObjectForKey:@"type"];
  msg.time = [feedDic safeNumberObjectForKey:@"time"];
  msg.comment = [[[feedDic safeStringObjectForKey:@"comment"] safeJsonDicFromJsonString] safeStringObjectForKey:@"text"];

  NSDictionary *feedInfoDic = [feedDic safeDicObjectForKey:@"feed"];
  msg.feed = [SWFeedInfoItem feedInfoItemByDic:feedInfoDic];
  
  
  NSDictionary *feedUserDic = [feedDic safeDicObjectForKey:@"user"];
  msg.user = [SWFeedUserItem feedUserItemByDic:feedUserDic];
  
  msg.noticeDic = feedDic;
  
  return msg;
}
@end
