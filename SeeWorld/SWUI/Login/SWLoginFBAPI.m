//
//  SWLoginFBAPI.m
//  SeeWorld
//
//  Created by Albert Lee on 6/9/16.
//  Copyright © 2016 SeeWorld. All rights reserved.
//

#import "SWLoginFBAPI.h"

@implementation SWLoginFBAPI
- (NSString *)requestUrl{
  return @"/login/facebook";
}

- (YTKRequestMethod)requestMethod {
  return YTKRequestMethodPOST;
}

- (id)requestArgument{
  return @{@"name":self.name?self.name:@"",
           @"head":self.head?self.head:@"",
           @"gender":self.gender?self.gender:@0,
           @"openid":self.openid?self.openid:@"",
           @"token":self.token?self.token:@""};
}
@end
