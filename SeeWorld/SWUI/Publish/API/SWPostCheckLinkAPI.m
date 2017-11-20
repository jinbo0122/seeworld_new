//
//  SWPostCheckLinkAPI.m
//  SeeWorld
//
//  Created by Albert Lee on 21/11/2017.
//  Copyright © 2017 SeeWorld. All rights reserved.
//

#import "SWPostCheckLinkAPI.h"

@implementation SWPostCheckLinkAPI
- (NSString *)requestUrl{
  return @"/feeds/link";
}

- (YTKRequestMethod)requestMethod {
  return YTKRequestMethodGET;
}

- (id)requestArgument{
  NSDictionary *dic =
  @{@"jwt":[[NSUserDefaults standardUserDefaults] safeStringObjectForKey:@"jwt"],
    @"link":_link?_link:@""};
  return dic;
}
@end
