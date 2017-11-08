//
//  SWPushSyncAPI.h
//  SeeWorld
//
//  Created by Albert Lee on 9/29/15.
//  Copyright © 2015 SeeWorld. All rights reserved.
//

#import "SWRequestApi.h"

@interface SWPushSyncAPI : SWRequestApi
@property(nonatomic, strong)NSString *cid;

@end


@interface SWPushOpenAPI : SWRequestApi

@end

@interface SWPushOpenGetAPI : SWRequestApi

@end