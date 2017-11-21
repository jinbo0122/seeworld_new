//
//  SWPostVC.h
//  SeeWorld
//
//  Created by Albert Lee on 17/11/2017.
//  Copyright © 2017 SeeWorld. All rights reserved.
//

#import "ALBaseVC.h"

@interface SWPostVC : ALBaseVC
@property(nonatomic, strong)NSMutableArray *images;
@property(nonatomic, strong)NSMutableArray *tags;

@property(nonatomic, strong)UIImage        *videoThumbImage;
@property(nonatomic, strong)ALAsset        *videoAsset;
@end
