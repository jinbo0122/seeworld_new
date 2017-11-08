//
//  SWCommentDeleteAPI.m
//  SeeWorld
//
//  Created by Albert Lee on 9/2/15.
//  Copyright (c) 2015 SeeWorld. All rights reserved.
//

#import "SWCommentDeleteAPI.h"

@implementation SWCommentDeleteAPI
- (NSString *)requestUrl{
  return [NSString stringWithFormat:@"/feeds/%@/comments/%@",_fId?_fId:@0,_commentId?_commentId:@0];
}

- (YTKRequestMethod)requestMethod {
  return YTKRequestMethodDELETE;
}

- (id)requestArgument{
  return @{@"jwt":[[NSUserDefaults standardUserDefaults] safeStringObjectForKey:@"jwt"]};
}
@end
