//
//  GetFollowsApi.m
//  SeeWorld
//
//  Created by liufz on 15/9/15.
//  Copyright (c) 2015年 SeeWorld. All rights reserved.
//

#import "GetFollowsApi.h"

@implementation GetFollowsApi
- (NSString *)requestUrl{
    return [NSString stringWithFormat:@"/users/%@/follows",self.userId];
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (id)requestArgument{
    return @{@"jwt":[[NSUserDefaults standardUserDefaults] safeStringObjectForKey:@"jwt"]};
}
@end
