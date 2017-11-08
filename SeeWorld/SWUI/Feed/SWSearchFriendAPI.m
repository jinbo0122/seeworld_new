//
//  SWSearchFriendAPI.m
//  SeeWorld
//
//  Created by Albert Lee on 9/2/15.
//  Copyright (c) 2015 SeeWorld. All rights reserved.
//

#import "SWSearchFriendAPI.h"

@implementation SWSearchFriendAPI
- (NSString *)requestUrl{
  return @"/users/search";
}

- (YTKRequestMethod)requestMethod {
  return YTKRequestMethodGET;
}

- (id)requestArgument{
  return @{@"jwt":[[NSUserDefaults standardUserDefaults] safeStringObjectForKey:@"jwt"],
           @"query":self.query?self.query:@""};
}
@end
