
#import "SWRequestApi.h"

@interface ModifyUserInfoApi : SWRequestApi
@property(nonatomic, strong)NSString *name;
@property(nonatomic, strong)NSString *head;
@property(nonatomic, strong)NSString *intro;
@property(nonatomic, assign)NSInteger gender;
@end
