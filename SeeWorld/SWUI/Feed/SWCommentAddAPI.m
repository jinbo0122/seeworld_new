//
//  SWCommentAddAPI.m
//  SeeWorld
//
//  Created by Albert Lee on 9/2/15.
//  Copyright (c) 2015 SeeWorld. All rights reserved.
//

#import "SWCommentAddAPI.h"

@implementation SWCommentAddAPI
- (NSString *)requestUrl{
  return [NSString stringWithFormat:@"/feeds/%@/comments",_fId?_fId:@0];
}

- (YTKRequestMethod)requestMethod {
  return YTKRequestMethodPOST;
}

- (id)requestArgument{
  return @{@"jwt":[[NSUserDefaults standardUserDefaults] safeStringObjectForKey:@"jwt"],
           @"text":self.text?self.text:@""};
}
@end
