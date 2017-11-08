//
//  SWFeedBigCell.h
//  SeeWorld
//
//  Created by Albert Lee on 5/23/16.
//  Copyright © 2016 SeeWorld. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SWFeedBigCellDelegate;
@interface SWFeedBigCell : UITableViewCell
@property(nonatomic, weak)id<SWFeedBigCellDelegate>delegate;
- (void)refreshThumbCell:(SWFeedItem *)feed row:(NSInteger)row;
+ (CGFloat)height;
@end

@protocol SWFeedBigCellDelegate <NSObject>
- (void)feedCellDidPressThumb:(SWFeedItem *)feedItem index:(NSInteger)index;
@end
