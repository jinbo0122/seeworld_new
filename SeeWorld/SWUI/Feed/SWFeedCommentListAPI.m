//
//  SWFeedCommentListAPI.m
//  SeeWorld
//
//  Created by Albert Lee on 9/2/15.
//  Copyright (c) 2015 SeeWorld. All rights reserved.
//

#import "SWFeedCommentListAPI.h"

@implementation SWFeedCommentListAPI
- (NSString *)requestUrl{
  return [NSString stringWithFormat:@"/feeds/%@/comments",_fId?_fId:@0];
}

- (YTKRequestMethod)requestMethod {
  return YTKRequestMethodGET;
}

- (id)requestArgument{
  return @{@"jwt":[[NSUserDefaults standardUserDefaults] safeStringObjectForKey:@"jwt"]};
}
@end
