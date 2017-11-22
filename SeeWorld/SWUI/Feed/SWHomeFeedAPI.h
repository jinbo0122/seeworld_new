//
//  SWHomeFeedAPI.h
//  SeeWorld
//
//  Created by Albert Lee on 9/1/15.
//  Copyright (c) 2015 SeeWorld. All rights reserved.
//

#import "SWRequestApi.h"

@interface SWHomeFeedAPI : SWRequestApi
@property(nonatomic, assign)BOOL isExplore;
@property(nonatomic, strong)NSNumber *lastFeedId;
@end
