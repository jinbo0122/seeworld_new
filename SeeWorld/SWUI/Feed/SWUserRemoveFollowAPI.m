//
//  SWUserRemoveFollowAPI.m
//  SeeWorld
//
//  Created by Albert Lee on 9/2/15.
//  Copyright (c) 2015 SeeWorld. All rights reserved.
//

#import "SWUserRemoveFollowAPI.h"

@implementation SWUserRemoveFollowAPI
- (NSString *)requestUrl{
  return [NSString stringWithFormat:@"/users/%@/relationship",_uId?_uId:@0];
}

- (YTKRequestMethod)requestMethod {
  return YTKRequestMethodPOST;
}

- (id)requestArgument{
  return @{@"jwt":[[NSUserDefaults standardUserDefaults] safeStringObjectForKey:@"jwt"],
           @"action":@"unfollow"};
}

+ (void)showSuccessTip{
  [MBProgressHUD showTip:@"已取消追蹤該用戶"];
}
@end
