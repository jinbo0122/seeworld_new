//
//  SWRongTokenAPI.m
//  SeeWorld
//
//  Created by Albert Lee on 1/21/16.
//  Copyright © 2016 SeeWorld. All rights reserved.
//

#import "SWRongTokenAPI.h"

@implementation SWRongTokenAPI
- (NSString *)requestUrl{
  return @"/rongtoken";
}

- (YTKRequestMethod)requestMethod {
  return YTKRequestMethodPOST;
}

- (id)requestArgument{
  return @{@"jwt":[[NSUserDefaults standardUserDefaults] safeStringObjectForKey:@"jwt"],
           @"name":_name?_name:@"",
           @"portraituri":_picUrl?_picUrl:@""};
}
@end
