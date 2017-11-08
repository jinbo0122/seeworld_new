
#import "SWRequestApi.h"

@interface ResetPasswordsApi : SWRequestApi
@property(nonatomic, strong)NSString *account;
@property(nonatomic, strong)NSString *secret;
@property(nonatomic, strong)NSString *resetPassword;
@property(nonatomic, strong)NSNumber *type;
@end
