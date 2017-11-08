//
//  SWFeedSingleAPI.m
//  SeeWorld
//
//  Created by Albert Lee on 9/25/15.
//  Copyright © 2015 SeeWorld. All rights reserved.
//

#import "SWFeedSingleAPI.h"

@implementation SWFeedSingleAPI
- (NSString *)requestUrl{
  return [NSString stringWithFormat:@"/feeds/%@",self.fId?self.fId:@0];
}

- (YTKRequestMethod)requestMethod {
  return YTKRequestMethodGET;
}

- (id)requestArgument{
  return @{@"jwt":[[NSUserDefaults standardUserDefaults] safeStringObjectForKey:@"jwt"]};
}
@end


@implementation SWFeedDeleteAPI

- (NSString *)requestUrl{
  return [NSString stringWithFormat:@"/feeds/%@",self.fId?self.fId:@0];
}

- (YTKRequestMethod)requestMethod {
  return YTKRequestMethodDELETE;
}

- (id)requestArgument{
  return @{@"jwt":[[NSUserDefaults standardUserDefaults] safeStringObjectForKey:@"jwt"]};
}

@end
