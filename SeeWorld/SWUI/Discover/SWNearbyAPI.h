//
//  SWNearbyAPI.h
//  SeeWorld
//
//  Created by Albert Lee on 9/15/15.
//  Copyright © 2015 SeeWorld. All rights reserved.
//

#import "SWRequestApi.h"

@interface SWNearbyAPI : SWRequestApi
@property(nonatomic, strong)NSNumber *longitude;
@property(nonatomic, strong)NSNumber *latitude;
@property(nonatomic, strong)NSNumber *distance;
@end
