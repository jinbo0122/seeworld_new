//
//  SWRequestApi.h
//  SeeWorld
//
//  Created by  on 15/8/11.
//  Copyright (c) 2015年 SeeWorld
//

#import "YTKRequest.h"
#import "CommonMeta.h"
#import "SWModel.h"
#import "ModelMessage.h"

@interface SWRequestApi : YTKRequest
- (void)startWithModelClass:(Class)modelClass completionBlock:(void (^)(ModelMessage *message))block ;
@end
