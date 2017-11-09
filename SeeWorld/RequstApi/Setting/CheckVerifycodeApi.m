
#import "CheckVerifycodeApi.h"
#import "SWDefine.h"

@implementation CheckVerifycodeApi
- (NSString *)requestUrl{
    return [NSString stringWithFormat:@"/verifycode/check"];
}

- (YTKRequestMethod)requestMethod {
  return YTKRequestMethodPOST;
}

- (id)requestArgument{
  NSDictionary *dic =
         @{@"email":SStr(self.email),
           @"code":SStr(self.code)};
    return dic;
}
@end
