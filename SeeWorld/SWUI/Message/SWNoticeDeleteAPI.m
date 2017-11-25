//
//  SWNoticeDeleteAPI.m
//  SeeWorld
//
//  Created by Albert Lee on 25/11/2017.
//  Copyright © 2017 SeeWorld. All rights reserved.
//

#import "SWNoticeDeleteAPI.h"

@implementation SWNoticeDeleteAPI
- (NSString *)requestUrl{
  return [NSString stringWithFormat:@"/notify/messages/%@",_messageId?_messageId:@0];
}

- (YTKRequestMethod)requestMethod {
  return YTKRequestMethodDELETE;
}

- (id)requestArgument{
  return @{@"jwt":[[NSUserDefaults standardUserDefaults] safeStringObjectForKey:@"jwt"],
           @"messageId":_messageId?_messageId:@0};
}
@end
