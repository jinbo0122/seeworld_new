//
//  SWPostVC.h
//  SeeWorld
//
//  Created by Albert Lee on 17/11/2017.
//  Copyright © 2017 SeeWorld. All rights reserved.
//

#import "ALBaseVC.h"
#import <AVKit/AVKit.h>
@interface SWPostVC : ALBaseVC
@property(nonatomic, strong)NSMutableArray *images;
@property(nonatomic, strong)NSMutableArray *tags;

@property(nonatomic, strong)UIImage        *videoThumbImage;
@property(nonatomic, strong)ALAsset        *videoAsset;
@property(nonatomic, strong)AVURLAsset     *videoURLAsset;

@end
