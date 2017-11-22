//
//  SWVideoPlayerManager.m
//  SeeWorld
//
//  Created by Albert Lee on 23/11/2017.
//  Copyright © 2017 SeeWorld. All rights reserved.
//

#import "SWVideoPlayerManager.h"

@implementation SWVideoPlayerManager{
  dispatch_queue_t _queue;
}
DEF_SINGLETON(SWVideoPlayerManager)
- (id)init{
  if (self = [super init]) {
    _player = [SCPlayer player];
    _queue = dispatch_queue_create("cn.video.download.queue", nil);
  }
  return self;
}

- (void)getVideoFileWithFeed:(SWFeedItem *)feed
             completionBlock:(COMPLETION_BLOCK_WithVideoFileUrl)completionBlock
                 failedBlock:(COMPLETION_BLOCK)failedBlock{
  NSURL *videoUrl = [NSURL URLWithString:feed.feed.videoUrl];
  NSString *fileName = [NSString stringWithFormat:@"video_%@.mp4",feed.feed.fId];
  NSString *tmpDirectory = NSTemporaryDirectory();
  NSString *filePath = [tmpDirectory stringByAppendingPathComponent:fileName];
  dispatch_async(_queue, ^{
    NSData *localData = [NSData dataWithContentsOfFile:filePath];
    if (localData && localData.length>0) {
      dispatch_async(dispatch_get_main_queue(), ^{
        if (completionBlock) {
          completionBlock ([NSURL fileURLWithPath:filePath]);
        }
      });
    }else{
      NSData *urlData = [NSData dataWithContentsOfURL:videoUrl];
      if (urlData){
        BOOL succ = [urlData writeToFile:filePath atomically:YES];
        if (succ) {
          dispatch_async(dispatch_get_main_queue(), ^{
            if (completionBlock) {
              completionBlock ([NSURL fileURLWithPath:filePath]);
            }
          });
        }else{
          dispatch_async(dispatch_get_main_queue(), ^{
            if (failedBlock) {
              failedBlock ();
            }
          });
        }
      }else{
        dispatch_async(dispatch_get_main_queue(), ^{
          if (failedBlock) {
            failedBlock ();
          }
        });
      }
    }
  });
}
@end
