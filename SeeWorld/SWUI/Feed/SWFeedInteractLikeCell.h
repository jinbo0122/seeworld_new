//
//  SWFeedInteractLikeCell.h
//  SeeWorld
//
//  Created by Albert Lee on 9/2/15.
//  Copyright (c) 2015 SeeWorld. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SWFeedInteractLikeCellDelegate;
@interface SWFeedInteractLikeCell : UITableViewCell
@property(nonatomic, weak)id<SWFeedInteractLikeCellDelegate>delegate;
- (void)refreshLike:(SWFeedLikeItem *)likeItem;
- (void)refreshUser:(SWFeedUserItem *)userItem;
+ (CGFloat)heightOfLike:(SWFeedLikeItem *)likeItem;

@end

@protocol SWFeedInteractLikeCellDelegate <NSObject>

- (void)feedInteractLikeCellDidPressFollow:(SWFeedLikeItem *)likeItem;

@end