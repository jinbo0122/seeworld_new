//
//  SWConfigManager.h
//  SeeWorld
//
//  Created by Albert Lee on 5/16/16.
//  Copyright © 2016 SeeWorld. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^COMPLETION_BLOCK_WITH_USER)(SWFeedUserItem *user);
@interface SWConfigManager : NSObject
DEC_SINGLETON(SWConfigManager);
@property(nonatomic, strong)SWFeedUserItem *user;
- (void)getUser:(NSString *)uId completionBlock:(COMPLETION_BLOCK_WITH_USER)completionBlock failedBlock:(COMPLETION_BLOCK)failedBlock;
- (void)saveUser:(SWFeedUserItem *)user;
- (SWFeedUserItem *)userByUId:(NSNumber *)uId;
@end
