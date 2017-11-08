//
//  SWNoticeMarkAPI.m
//  SeeWorld
//
//  Created by Albert Lee on 9/25/15.
//  Copyright © 2015 SeeWorld. All rights reserved.
//

#import "SWNoticeMarkAPI.h"
#import "SWDefine.h"

@implementation SWNoticeMarkAPI
- (NSString *)requestUrl{
  NSString *url = [NSString stringWithFormat:@"/notify/messages/%@/read?jwt=%@&messageId=%@",self.messageId?self.messageId:@0,[[NSUserDefaults standardUserDefaults] safeStringObjectForKey:@"jwt"],self.messageId?self.messageId:@0];
  const CFStringRef legalURLCharactersToBeEscaped = CFSTR("+");
  return (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)url, NULL, legalURLCharactersToBeEscaped, kCFStringEncodingUTF8);
}

- (YTKRequestMethod)requestMethod {
  return YTKRequestMethodPUT;
}

- (id)requestArgument{
  return @{@"jwt":[[NSUserDefaults standardUserDefaults] safeStringObjectForKey:@"jwt"],
           @"messageId":self.messageId?self.messageId:@0};
}
@end
