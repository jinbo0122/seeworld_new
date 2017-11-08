//
//  SWFBLoginAPI.m
//  SeeWorld
//
//  Created by Albert Lee on 9/6/15.
//  Copyright (c) 2015 SeeWorld. All rights reserved.
//

#import "SWFBLoginAPI.h"

@implementation SWFBLoginAPI
- (NSString *)requestUrl{
  return @"/login/facebook";
}

- (YTKRequestMethod)requestMethod {
  return YTKRequestMethodPOST;
}

- (id)requestArgument{
  return @{@"name":[[NSUserDefaults standardUserDefaults] safeStringObjectForKey:@"userName"],
           @"head":[[NSUserDefaults standardUserDefaults] safeStringObjectForKey:@"userPicUrl"],
           @"gender":[[NSUserDefaults standardUserDefaults] safeNumberObjectForKey:@"userGender"],
           @"openid":[[NSUserDefaults standardUserDefaults] safeStringObjectForKey:@"uId"],
           @"token":self.token?self.token:@""};
}
@end
