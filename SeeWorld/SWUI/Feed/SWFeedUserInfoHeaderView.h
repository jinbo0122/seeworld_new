//
//  SWFeedUserInfoHeaderView.h
//  SeeWorld
//
//  Created by Albert Lee on 8/31/15.
//  Copyright (c) 2015 SeeWorld. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWFeedItem.h"
@interface SWFeedUserInfoHeaderView : UIButton
- (void)refresshWithFeed:(SWFeedItem *)feedItem;
@end
