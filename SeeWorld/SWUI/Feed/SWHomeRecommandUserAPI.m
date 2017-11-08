//
//  SWHomeRecommandUserAPI.m
//  SeeWorld
//
//  Created by Albert Lee on 9/2/15.
//  Copyright (c) 2015 SeeWorld. All rights reserved.
//

#import "SWHomeRecommandUserAPI.h"

@implementation SWHomeRecommandUserAPI
- (NSString *)requestUrl{
  return @"/recommend/users";
}

- (YTKRequestMethod)requestMethod {
  return YTKRequestMethodGET;
}

- (id)requestArgument{
  return @{@"jwt":[[NSUserDefaults standardUserDefaults] safeStringObjectForKey:@"jwt"],
           @"count":@1};
}
@end
