
#import "SWRequestApi.h"

@interface CheckVerifycodeApi : SWRequestApi
@property(nonatomic, strong)NSString *email;
@property(nonatomic, strong)NSString *code;
@end
