
#import "SWRequestApi.h"

@interface SWFeedComposeAPI : SWRequestApi
@property(nonatomic, strong)NSString *photoUrl;
@property(nonatomic, strong)NSString *feedDescription;
@property(nonatomic, strong)NSArray *tags;
@property(nonatomic, assign)CGFloat longitude;
@property(nonatomic, assign)CGFloat latitude;
@end
