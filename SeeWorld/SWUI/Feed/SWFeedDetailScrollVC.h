//
//  SWFeedDetailScrollVC.h
//  SeeWorld
//
//  Created by Albert Lee on 9/3/15.
//  Copyright (c) 2015 SeeWorld. All rights reserved.
//

#import "ALBaseVC.h"
#import "SWTagFeedsModel.h"
@interface SWFeedDetailScrollVC : ALBaseVC
@property(nonatomic, weak)SWTagFeedsModel *model;
@property(nonatomic, assign)NSInteger currentIndex;
@end
