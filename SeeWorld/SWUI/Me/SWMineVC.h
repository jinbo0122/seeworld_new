//
//  SWMineVC.h
//  SeeWorld
//
//  Created by Albert Lee on 5/16/16.
//  Copyright © 2016 SeeWorld. All rights reserved.
//

#import "ALBaseVC.h"

@interface SWMineVC : ALBaseVC
@property(nonatomic, strong)SWFeedUserItem *user;
@property(nonatomic, assign)BOOL isFromTab;
- (void)refresh;
- (void)refreshUserInfo;
@end
