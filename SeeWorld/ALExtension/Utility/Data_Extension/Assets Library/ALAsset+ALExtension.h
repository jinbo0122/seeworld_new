//
//  ALAsset+ALExtension.h
//  SeeWorld
//
//  Created by Albert Lee on 23/11/2017.
//  Copyright © 2017 SeeWorld. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>

@interface ALAsset (ALExtension)
- (BOOL) exportDataToURL: (NSURL*) fileURL error: (NSError**) error;
@end
