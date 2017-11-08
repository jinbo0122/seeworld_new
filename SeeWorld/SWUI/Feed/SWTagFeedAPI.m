//
//  SWTagFeedAPI.m
//  SeeWorld
//
//  Created by Albert Lee on 9/3/15.
//  Copyright (c) 2015 SeeWorld. All rights reserved.
//

#import "SWTagFeedAPI.h"

@implementation SWTagFeedAPI
- (NSString *)requestUrl{
    if (_userId.length > 0)
    {
      return [NSString stringWithFormat:@"/users/%@/feeds",_userId?_userId:@""];
    }
    else
    {
      return [NSString stringWithFormat:@"/tags/%@/feeds",_tagId?_tagId:@0];
    }
}

- (YTKRequestMethod)requestMethod {
  return YTKRequestMethodGET;
}

- (id)requestArgument{
  NSMutableDictionary *params = [@{@"jwt":[[NSUserDefaults standardUserDefaults] safeStringObjectForKey:@"jwt"],
                                   @"tagId":_tagId?_tagId:@0,
                                   @"count":@21} mutableCopy];
  
  if (self.lastFeedId && [self.lastFeedId integerValue]>0) {
    [params setObject:self.lastFeedId forKey:@"lastFeedId"];
  }
  return params;
}
@end
