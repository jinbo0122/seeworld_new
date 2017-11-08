//
//  SWEditCoverAPI.m
//  SeeWorld
//
//  Created by Albert Lee on 6/13/16.
//  Copyright © 2016 SeeWorld. All rights reserved.
//

#import "SWEditCoverAPI.h"

@implementation SWEditCoverAPI
- (NSString *)requestUrl{
  NSString *url = [NSString stringWithFormat:@"/users/self/setbghead?jwt=%@&bgHead=%@",[[NSUserDefaults standardUserDefaults] safeStringObjectForKey:@"jwt"],SStr(self.bgHead)];
  const CFStringRef legalURLCharactersToBeEscaped = CFSTR("+");
  return (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)url, NULL, legalURLCharactersToBeEscaped, kCFStringEncodingUTF8);
}

- (YTKRequestMethod)requestMethod {
  return YTKRequestMethodPUT;
}

- (id)requestArgument{
  NSDictionary *dic =
  @{@"jwt":[[NSUserDefaults standardUserDefaults] safeStringObjectForKey:@"jwt"],
    @"bgHead":SStr(self.bgHead)};
  return dic;
}
@end
