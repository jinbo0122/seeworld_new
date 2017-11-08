//
//  SWSearcgFBFriendAPI.m
//  SeeWorld
//
//  Created by Albert Lee on 9/6/15.
//  Copyright (c) 2015 SeeWorld. All rights reserved.
//

#import "SWSearcgFBFriendAPI.h"

@implementation SWSearcgFBFriendAPI
- (NSString *)requestUrl{
  return @"/recommend/facebook/users";
}

- (YTKRequestMethod)requestMethod {
  return YTKRequestMethodGET;
}

- (id)requestArgument{
  NSString *token = [[FBSDKAccessToken currentAccessToken] tokenString];
  
  return @{@"jwt":[[NSUserDefaults standardUserDefaults] safeStringObjectForKey:@"jwt"],
           @"token":token?token:@""};
}
@end
