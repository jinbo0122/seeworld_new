//
//  ALAsset+ALExtension.m
//  SeeWorld
//
//  Created by Albert Lee on 23/11/2017.
//  Copyright © 2017 SeeWorld. All rights reserved.
//

#import "ALAsset+ALExtension.h"
static const NSUInteger BufferSize = 1024*1024;
@implementation ALAsset (ALExtension)
- (BOOL) exportDataToURL: (NSURL*) fileURL error: (NSError**) error
{
  [[NSFileManager defaultManager] createFileAtPath:[fileURL path] contents:nil attributes:nil];
  NSFileHandle *handle = [NSFileHandle fileHandleForWritingToURL:fileURL error:error];
  if (!handle) {
    return NO;
  }
  
  ALAssetRepresentation *rep = [self defaultRepresentation];
  uint8_t *buffer = calloc(BufferSize, sizeof(*buffer));
  NSUInteger offset = 0, bytesRead = 0;
  
  do {
    @try {
      bytesRead = [rep getBytes:buffer fromOffset:offset length:BufferSize error:error];
      [handle writeData:[NSData dataWithBytesNoCopy:buffer length:bytesRead freeWhenDone:NO]];
      offset += bytesRead;
    } @catch (NSException *exception) {
      free(buffer);
      return NO;
    }
  } while (bytesRead > 0);
  
  free(buffer);
  return YES;
}
@end
