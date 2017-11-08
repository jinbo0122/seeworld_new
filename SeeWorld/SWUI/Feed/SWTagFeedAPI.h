//
//  SWTagFeedAPI.h
//  SeeWorld
//
//  Created by Albert Lee on 9/3/15.
//  Copyright (c) 2015 SeeWorld. All rights reserved.
//

#import "SWRequestApi.h"

@interface SWTagFeedAPI : SWRequestApi
@property(nonatomic, strong)NSNumber *tagId;
@property(nonatomic, strong)NSString *userId;
@property(nonatomic, strong)NSNumber *lastFeedId;
@end
