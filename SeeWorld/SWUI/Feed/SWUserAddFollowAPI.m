//
//  SWUserAddFollowAPI.m
//  SeeWorld
//
//  Created by Albert Lee on 9/2/15.
//  Copyright (c) 2015 SeeWorld. All rights reserved.
//

#import "SWUserAddFollowAPI.h"

@implementation SWUserAddFollowAPI
- (NSString *)requestUrl{
  return [NSString stringWithFormat:@"/users/%@/relationship",_uId?_uId:@0];
}

- (YTKRequestMethod)requestMethod {
  return YTKRequestMethodPOST;
}

- (id)requestArgument{
  return @{@"jwt":[[NSUserDefaults standardUserDefaults] safeStringObjectForKey:@"jwt"],
           @"action":@"follow"};
}

+ (void)showSuccessTip{
  [MBProgressHUD showTip:@"已追蹤該用戶"];
}
@end
