//
//  SWRequestApi.m
//  SeeWorld
//
//  Created by  on 15/8/11.
//  Copyright (c) 2015年 SeeWorld
//

#import "SWRequestApi.h"

@implementation SWRequestApi
- (void)startWithModelClass:(Class)modelClass completionBlock:(void (^)(ModelMessage *message))block
{
    __block ModelMessage *message = nil;
    void (^completeBlock)(YTKBaseRequest *request) =  ^(YTKBaseRequest *request){
        if (block)
        {
            if ([modelClass isSubclassOfClass:[SWModel class]])
            {
                message = [modelClass messageWithRequst:request];
            }
            block(message);
        }
    };
    [self startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        completeBlock(request);
    } failure:^(YTKBaseRequest *request) {
        completeBlock(request);
    }];
}
@end
