//
//  SWFeedSingleAPI.h
//  SeeWorld
//
//  Created by Albert Lee on 9/25/15.
//  Copyright © 2015 SeeWorld. All rights reserved.
//

#import "SWRequestApi.h"

@interface SWFeedSingleAPI : SWRequestApi
@property(nonatomic, strong)NSNumber *fId;
@end


@interface SWFeedDeleteAPI : SWRequestApi
@property(nonatomic, strong)NSNumber *fId;
@end