//
//  SWUserListCell.h
//  SeeWorld
//
//  Created by Albert Lee on 15/11/2017.
//  Copyright © 2017 SeeWorld. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SWUserListCell : UITableViewCell
- (void)refreshWithUser:(SWFeedUserItem *)user;
@end
