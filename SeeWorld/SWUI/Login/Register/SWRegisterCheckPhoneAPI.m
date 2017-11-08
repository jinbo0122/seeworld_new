//
//  SWRegisterCheckPhoneAPI.m
//  SeeWorld
//
//  Created by Albert Lee on 13/10/2016.
//  Copyright © 2016 SeeWorld. All rights reserved.
//

#import "SWRegisterCheckPhoneAPI.h"

@implementation SWRegisterCheckPhoneAPI
- (NSString *)requestUrl{
  return @"/register/tel/check";
}

- (YTKRequestMethod)requestMethod {
  return YTKRequestMethodPOST;
}

- (id)requestArgument{
  return @{@"tel":self.tel?self.tel:@""};
}
@end
