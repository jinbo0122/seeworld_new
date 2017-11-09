
#import "ResetPasswordsApi.h"
#import "SWDefine.h"

@implementation ResetPasswordsApi
- (NSString *)requestUrl{
    return [NSString stringWithFormat:@"/password/reset"];
}

- (YTKRequestMethod)requestMethod {
  return YTKRequestMethodPOST;
}

- (id)requestArgument{
  NSDictionary *dic =
         @{@"account":SStr(self.account),
           @"secret":SStr(self.secret),
           @"password":SStr(self.resetPassword),
           @"type":self.type?self.type:@0};
    return dic;
}
@end
