//
//  SWReportUserAPI.m
//  SeeWorld
//
//  Created by Albert Lee on 1/21/16.
//  Copyright © 2016 SeeWorld. All rights reserved.
//

#import "SWReportUserAPI.h"

@implementation SWReportUserAPI
- (NSString *)requestUrl{
  return [NSString stringWithFormat:@"/users/%@/report",_userId?_userId:@0];
}

- (YTKRequestMethod)requestMethod {
  return YTKRequestMethodPOST;
}

- (id)requestArgument{
  return @{@"jwt":[[NSUserDefaults standardUserDefaults] safeStringObjectForKey:@"jwt"]};
}
@end
