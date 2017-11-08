//
//  SWContactAPI.m
//  SeeWorld
//
//  Created by Albert Lee on 1/21/16.
//  Copyright © 2016 SeeWorld. All rights reserved.
//

#import "SWContactAPI.h"

@implementation SWContactAPI
- (NSString *)requestUrl{
  return @"/users/all";
}

- (YTKRequestMethod)requestMethod {
  return YTKRequestMethodGET;
}

- (id)requestArgument{
  return @{@"jwt":[[NSUserDefaults standardUserDefaults] safeStringObjectForKey:@"jwt"]};
}
@end
