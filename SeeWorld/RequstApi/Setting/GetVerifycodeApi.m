
#import "GetVerifycodeApi.h"
#import "SWDefine.h"

@implementation GetVerifycodeApi
- (NSString *)requestUrl{
    return [NSString stringWithFormat:@"/verifycode"];
}

- (YTKRequestMethod)requestMethod {
  return YTKRequestMethodGET;
}

- (id)requestArgument{
  NSDictionary *dic =
         @{@"email":SStr(self.email)};
    return dic;
}
@end
