//
//  SWPushSyncAPI.m
//  SeeWorld
//
//  Created by Albert Lee on 9/29/15.
//  Copyright © 2015 SeeWorld. All rights reserved.
//

#import "SWPushSyncAPI.h"

@implementation SWPushSyncAPI
- (NSString *)requestUrl{
  NSString *url = [NSString stringWithFormat:@"/notify/token?jwt=%@&cid=%@",[[NSUserDefaults standardUserDefaults] safeStringObjectForKey:@"jwt"],self.cid?self.cid:@""];
  const CFStringRef legalURLCharactersToBeEscaped = CFSTR("+");
  return (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)url, NULL, legalURLCharactersToBeEscaped, kCFStringEncodingUTF8);
}

- (YTKRequestMethod)requestMethod {
  return YTKRequestMethodPUT;
}

- (id)requestArgument{
  return @{@"jwt":[[NSUserDefaults standardUserDefaults] safeStringObjectForKey:@"jwt"],
           @"cid":self.cid?self.cid:@""};
}
@end


@implementation SWPushOpenAPI

- (NSString *)requestUrl{
  BOOL pushOpen = ![[NSUserDefaults standardUserDefaults] boolForKey:@"isPushClosed"];
  NSNumber *open = pushOpen?@1:@3;
  NSString *url = [NSString stringWithFormat:@"/notify/config?jwt=%@&comment_range=%@&like_range=%@&follow_range=%@",[[NSUserDefaults standardUserDefaults] safeStringObjectForKey:@"jwt"],open,open,open];
  const CFStringRef legalURLCharactersToBeEscaped = CFSTR("+");
  return (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)url, NULL, legalURLCharactersToBeEscaped, kCFStringEncodingUTF8);
}

- (YTKRequestMethod)requestMethod {
  return YTKRequestMethodPUT;
}

- (id)requestArgument{
  BOOL pushOpen = ![[NSUserDefaults standardUserDefaults] boolForKey:@"isPushClosed"];
  NSNumber *open = pushOpen?@1:@3;
  return @{@"jwt":[[NSUserDefaults standardUserDefaults] safeStringObjectForKey:@"jwt"],
           @"comment_range":open,
           @"like_range":open,
           @"follow_range":open};
}

@end

@implementation SWPushOpenGetAPI

- (NSString *)requestUrl{
  return @"/notify/config";
}

- (YTKRequestMethod)requestMethod {
  return YTKRequestMethodGET;
}

- (id)requestArgument{
  return @{@"jwt":[[NSUserDefaults standardUserDefaults] safeStringObjectForKey:@"jwt"]};
}

@end
