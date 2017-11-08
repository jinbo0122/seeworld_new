//
//  SWSearchTagAPI.m
//  SeeWorld
//
//  Created by Albert Lee on 9/13/15.
//  Copyright (c) 2015 SeeWorld. All rights reserved.
//

#import "SWSearchTagAPI.h"

@implementation SWSearchTagAPI
- (NSString *)requestUrl{
  return @"/tags/search";
}

- (YTKRequestMethod)requestMethod {
  return YTKRequestMethodGET;
}

- (id)requestArgument{
  return @{@"jwt":[[NSUserDefaults standardUserDefaults] safeStringObjectForKey:@"jwt"],
           @"query":self.query?self.query:@""};
}
@end
