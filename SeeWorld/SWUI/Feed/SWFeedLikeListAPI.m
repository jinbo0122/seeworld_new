//
//  SWFeedLikeListAPI.m
//  SeeWorld
//
//  Created by Albert Lee on 9/2/15.
//  Copyright (c) 2015 SeeWorld. All rights reserved.
//

#import "SWFeedLikeListAPI.h"

@implementation SWFeedLikeListAPI
- (NSString *)requestUrl{
  return [NSString stringWithFormat:@"/feeds/%@/likes",_fId?_fId:@0];
}

- (YTKRequestMethod)requestMethod {
  return YTKRequestMethodGET;
}

- (id)requestArgument{
  return @{@"jwt":[[NSUserDefaults standardUserDefaults] safeStringObjectForKey:@"jwt"]};
}
@end
