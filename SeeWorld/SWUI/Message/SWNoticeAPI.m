//
//  SWNoticeAPI.m
//  SeeWorld
//
//  Created by Albert Lee on 9/25/15.
//  Copyright © 2015 SeeWorld. All rights reserved.
//

#import "SWNoticeAPI.h"

@implementation SWNoticeAPI
- (NSString *)requestUrl{
  return @"/notify/messages";
}

- (YTKRequestMethod)requestMethod {
  return YTKRequestMethodGET;
}

- (id)requestArgument{
  NSMutableDictionary *params = [@{@"jwt":[[NSUserDefaults standardUserDefaults] safeStringObjectForKey:@"jwt"],
                                   @"count":@20} mutableCopy];
  
  if (self.lastMessageId && [self.lastMessageId integerValue]>0) {
    [params setObject:self.lastMessageId forKey:@"lastMessageId"];
  }
  return params;
}
@end
