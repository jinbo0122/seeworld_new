//
//  SWPostGetLocationAPI.m
//  SeeWorld
//
//  Created by Albert Lee on 23/11/2017.
//  Copyright © 2017 SeeWorld. All rights reserved.
//

#import "SWPostGetLocationAPI.h"

@implementation SWPostGetLocationAPI
- (NSString *)requestUrl{
  return @"/feeds/location";
}

- (YTKRequestMethod)requestMethod {
  return YTKRequestMethodGET;
}

- (id)requestArgument{
  NSDictionary *dic =
  @{@"jwt":[[NSUserDefaults standardUserDefaults] safeStringObjectForKey:@"jwt"],
    @"longitude":@(self.longitude),
    @"latitude":@(self.latitude)};
  return dic;
}
@end
