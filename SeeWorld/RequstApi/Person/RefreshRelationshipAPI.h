//
//  SWUserRemoveFollowAPI.h
//  SeeWorld
//
//  Created by Albert Lee on 9/2/15.
//  Copyright (c) 2015 SeeWorld. All rights reserved.
//

#import "SWRequestApi.h"

@interface RefreshRelationshipAPI : SWRequestApi
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *action;
@end
