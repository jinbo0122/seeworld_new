//
//  SWNoticeVC.h
//  SeeWorld
//
//  Created by Albert Lee on 9/23/15.
//  Copyright © 2015 SeeWorld. All rights reserved.
//

#import "ALBaseVC.h"
#import "SWExploreSegView.h"
@interface SWNoticeVC : ALBaseVC
@property(nonatomic, strong)SWExploreSegView *titleView;
- (void)reloadModelData;
@end
