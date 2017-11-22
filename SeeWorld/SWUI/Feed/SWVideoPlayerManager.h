//
//  SWVideoPlayerManager.h
//  SeeWorld
//
//  Created by Albert Lee on 23/11/2017.
//  Copyright © 2017 SeeWorld. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCRecorderHeader.h"
typedef void(^COMPLETION_BLOCK_WithVideoFileUrl)(NSURL *fileUrl);
@interface SWVideoPlayerManager : NSObject
DEC_SINGLETON(SWVideoPlayerManager)
@property(nonatomic, strong)SCPlayer *player;
- (void)getVideoFileWithFeed:(SWFeedItem *)feed
             completionBlock:(COMPLETION_BLOCK_WithVideoFileUrl)completionBlock
                 failedBlock:(COMPLETION_BLOCK)failedBlock;
@end
