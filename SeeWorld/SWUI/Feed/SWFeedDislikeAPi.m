//
//  SWFeedDislikeAPi.m
//  SeeWorld
//
//  Created by Albert Lee on 9/2/15.
//  Copyright (c) 2015 SeeWorld. All rights reserved.
//

#import "SWFeedDislikeAPi.h"

@implementation SWFeedDislikeAPi
- (NSString *)requestUrl{
  return [NSString stringWithFormat:@"/feeds/%@/likes",_fId?_fId:@0];
}

- (YTKRequestMethod)requestMethod {
  return YTKRequestMethodDELETE;
}

- (id)requestArgument{
  return @{@"jwt":[[NSUserDefaults standardUserDefaults] safeStringObjectForKey:@"jwt"]};
}
@end
