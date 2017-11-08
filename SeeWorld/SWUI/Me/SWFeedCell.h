//
//  SWFeedCell.h
//  SeeWorld
//
//  Created by Albert Lee on 5/23/16.
//  Copyright © 2016 SeeWorld. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SWFeedCellDelegate;
@interface SWFeedCell : UITableViewCell
@property(nonatomic, weak)id<SWFeedCellDelegate>delegate;
- (void)refreshThumbCell:(NSArray *)feeds row:(NSInteger)row;
+ (CGFloat)height;
@end

@protocol SWFeedCellDelegate <NSObject>

- (void)feedCellDidPressThumb:(SWFeedItem *)feedItem index:(NSInteger)index;

@end