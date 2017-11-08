
#import "ModifyUserInfoApi.h"
#import "MJExtension.h"
#import "SWDefine.h"

@implementation ModifyUserInfoApi
- (NSString *)requestUrl{
    NSString *url = [NSString stringWithFormat:@"/users/self/info?jwt=%@&name=%@&head=%@&gender=%ld&description=%@",[[NSUserDefaults standardUserDefaults] safeStringObjectForKey:@"jwt"],SStr( self.name),SStr(self.head),(long)self.gender,SStr(self.intro)];
    const CFStringRef legalURLCharactersToBeEscaped = CFSTR("+");
    return (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)url, NULL, legalURLCharactersToBeEscaped, kCFStringEncodingUTF8);
}

- (YTKRequestMethod)requestMethod {
  return YTKRequestMethodPUT;
}

- (id)requestArgument{
  NSDictionary *dic =
         @{@"jwt":[[NSUserDefaults standardUserDefaults] safeStringObjectForKey:@"jwt"],
           @"name":SStr( self.name),
           @"head":SStr(self.head),
           @"gender":@(self.gender),
           @"description":SStr(self.intro)};
    return dic;
}
@end
