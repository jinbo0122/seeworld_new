//
//  GetQiniuTokenApi.m
//  SeeWorld
//
//  Created by liufz on 15/9/15.
//  Copyright (c) 2015年 SeeWorld. All rights reserved.
//

#import "GetQiniuTokenApi.h"

@implementation GetQiniuTokenApi
- (NSString *)requestUrl{
    return [NSString stringWithFormat:@"/qiniu/uploadToken"];
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (id)requestArgument{
    return @{@"jwt":[[NSUserDefaults standardUserDefaults] safeStringObjectForKey:@"jwt"],
             @"bucket":@"seeworldqiniu"};
}
@end
