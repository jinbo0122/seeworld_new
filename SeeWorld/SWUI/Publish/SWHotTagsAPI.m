//
//  SWHotTagsAPI.m
//  SeeWorld
//
//  Created by Albert Lee on 6/26/16.
//  Copyright © 2016 SeeWorld. All rights reserved.
//

#import "SWHotTagsAPI.h"

@implementation SWHotTagsAPI
- (NSString *)requestUrl{
  return @"/tags/hot";
}

- (YTKRequestMethod)requestMethod {
  return YTKRequestMethodGET;
}

- (id)requestArgument{
  NSDictionary *dic =
  @{@"jwt":[[NSUserDefaults standardUserDefaults] safeStringObjectForKey:@"jwt"],
    @"count":@(20)};
  return dic;
}
@end
