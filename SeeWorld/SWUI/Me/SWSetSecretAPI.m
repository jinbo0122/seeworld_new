//
//  SWSetSecretAPI.m
//  SeeWorld
//
//  Created by Albert Lee on 7/13/16.
//  Copyright © 2016 SeeWorld. All rights reserved.
//

#import "SWSetSecretAPI.h"

@implementation SWSetSecretAPI
- (NSString *)requestUrl{
  NSString *url = [NSString stringWithFormat:@"/users/self/setsecret?jwt=%@&isSecret=%@",[[NSUserDefaults standardUserDefaults] safeStringObjectForKey:@"jwt"],self.isSecret?@1:@0];
  const CFStringRef legalURLCharactersToBeEscaped = CFSTR("+");
  return (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)url, NULL, legalURLCharactersToBeEscaped, kCFStringEncodingUTF8);
}

- (YTKRequestMethod)requestMethod {
  return YTKRequestMethodPUT;
}

- (id)requestArgument{
  NSMutableDictionary *params = [@{@"jwt":[[NSUserDefaults standardUserDefaults] safeStringObjectForKey:@"jwt"],
                                   @"isSecret":self.isSecret?@1:@0} mutableCopy];
  return params;
}
@end
