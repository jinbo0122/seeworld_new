
#import "FeedbacksApi.h"
#import "SWDefine.h"

@implementation FeedbacksApi
- (NSString *)requestUrl{
    return [NSString stringWithFormat:@"/feedbacks"];
}

- (YTKRequestMethod)requestMethod {
  return YTKRequestMethodPOST;
}

- (id)requestArgument{
  NSDictionary *dic =
         @{@"jwt":[[NSUserDefaults standardUserDefaults] safeStringObjectForKey:@"jwt"],
           @"content":SStr( self.content),
           @"contact":SStr(self.contact)};
    return dic;
}
@end
