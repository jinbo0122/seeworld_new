
#import "SWRequestApi.h"

typedef NS_ENUM(NSInteger, SWFeedType){
  SWFeedTypeImage = 0,
  SWFeedTypeVideo = 1,
  SWFeedTypeLink  = 2,
};

@interface SWFeedComposeAPI : SWRequestApi
@property(nonatomic, strong)NSString *photoJson;
@property(nonatomic, strong)NSString *feedDescription;
@property(nonatomic, strong)NSArray *tags;
@property(nonatomic, assign)CGFloat longitude;
@property(nonatomic, assign)CGFloat latitude;
@property(nonatomic, assign)SWFeedType feedType;
@property(nonatomic, strong)NSString *link;
@property(nonatomic, strong)NSString *videoUrl;
@property(nonatomic, strong)NSString *location;
@end
