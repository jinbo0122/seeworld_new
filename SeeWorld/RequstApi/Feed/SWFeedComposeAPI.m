
#import "SWFeedComposeAPI.h"
#import "MJExtension.h"

@implementation SWFeedComposeAPI
- (NSString *)requestUrl{
  return [NSString stringWithFormat:@"/feeds"];
}

- (YTKRequestMethod)requestMethod {
  return YTKRequestMethodPOST;
}

- (id)requestArgument{
  return @{@"jwt":[[NSUserDefaults standardUserDefaults] safeStringObjectForKey:@"jwt"],
           @"photo":self.photoUrl,
           @"longitude":@(self.longitude),
           @"latitude":@(self.latitude),
           @"tags":[self.tags JSONString],
           @"description":self.feedDescription};
}
@end
