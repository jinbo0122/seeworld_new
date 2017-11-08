//
//  SWUserRemoveFollowAPI.m
//  SeeWorld
//
//  Created by Albert Lee on 9/2/15.
//  Copyright (c) 2015 SeeWorld. All rights reserved.
//

#import "RefreshRelationshipAPI.h"
#import "SWDefine.h"

@implementation RefreshRelationshipAPI
- (NSString *)requestUrl{
  return [NSString stringWithFormat:@"/users/%@/relationship",SStr(self.userId)];
}

- (YTKRequestMethod)requestMethod {
  return YTKRequestMethodPOST;
}

- (id)requestArgument{
  return @{@"jwt":[[NSUserDefaults standardUserDefaults] safeStringObjectForKey:@"jwt"],
           @"action":SStr(self.action)};
}
@end
