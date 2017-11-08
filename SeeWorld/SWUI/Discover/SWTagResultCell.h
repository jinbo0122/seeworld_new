//
//  SWTagResultCell.h
//  SeeWorld
//
//  Created by Albert Lee on 9/11/15.
//  Copyright (c) 2015 SeeWorld. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTagFeedItem.h"
@interface SWTagResultCell : UITableViewCell
- (void)refreshTag:(SWFeedTagItem *)tagItem;
@end
