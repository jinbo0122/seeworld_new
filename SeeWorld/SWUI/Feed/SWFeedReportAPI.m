//
//  SWFeedReportAPI.m
//  SeeWorld
//
//  Created by Albert Lee on 9/3/15.
//  Copyright (c) 2015 SeeWorld. All rights reserved.
//

#import "SWFeedReportAPI.h"

@implementation SWFeedReportAPI
- (NSString *)requestUrl{
  return [NSString stringWithFormat:@"/feeds/%@/report",_fId?_fId:@0];
}

- (YTKRequestMethod)requestMethod {
  return YTKRequestMethodPOST;
}

- (id)requestArgument{
  return @{@"jwt":[[NSUserDefaults standardUserDefaults] safeStringObjectForKey:@"jwt"]};
}
@end
