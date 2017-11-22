//
//  SWHomeFeedAPI.m
//  SeeWorld
//
//  Created by Albert Lee on 9/1/15.
//  Copyright (c) 2015 SeeWorld. All rights reserved.
//

#import "SWHomeFeedAPI.h"

@implementation SWHomeFeedAPI
- (NSString *)requestUrl{
  return _isExplore?@"/feeds/activity":@"/feeds";
}

- (YTKRequestMethod)requestMethod {
  return YTKRequestMethodGET;
}

- (id)requestArgument{
  NSMutableDictionary *params = [@{@"jwt":[[NSUserDefaults standardUserDefaults] safeStringObjectForKey:@"jwt"],
                                   @"count":@20} mutableCopy];
  
  if (self.lastFeedId && [self.lastFeedId integerValue]>0) {
    [params setObject:self.lastFeedId forKey:@"lastFeedId"];
  }
  return params;
}
@end
