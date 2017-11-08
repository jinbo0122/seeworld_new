//
//  SWFeedInteractCommentCell.h
//  SeeWorld
//
//  Created by Albert Lee on 9/2/15.
//  Copyright (c) 2015 SeeWorld. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SWFeedInteractCommentCellDelegate;
@interface SWFeedInteractCommentCell : UITableViewCell
@property(nonatomic, weak)id<SWFeedInteractCommentCellDelegate>delegate;
- (void)refreshComment:(SWFeedCommentItem *)commentItem;
+ (CGFloat)heightOfComment:(SWFeedCommentItem *)commentItem;
@end

@protocol SWFeedInteractCommentCellDelegate <NSObject>

- (void)feedInteractCommentCellDidNeedEnterUser:(SWFeedUserItem *)userItem;
- (void)feedInteractCommentCellDidPressed:(SWFeedCommentItem *)commentItem;
- (void)feedInteractCommentCellDidSwiped:(SWFeedCommentItem *)commentItem;
- (void)feedInteractCommentCellDidPressImage:(NSString *)url rect:(CGRect)rect;
- (void)feedInteractCommentCellDidPressUrl:(NSURL *)url;
@end
