//
//  SWExploreFeedItemView.h
//  SeeWorld
//
//  Created by Albert Lee on 4/24/15.
//  Copyright (c) 2015 SeeWorld. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SWExploreFeedItemViewDelegate;
@interface SWExploreFeedItemView : UIView
@property(nonatomic, strong)SWFeedItem  *feedItem;
@property(nonatomic, strong)UIImageView *iconLike;
@property(nonatomic, strong)UIImageView *iconDislike;
@property(nonatomic, weak)id<SWExploreFeedItemViewDelegate>delegate;

- (void)refreshReviewItemUI:(SWFeedItem *)feedItem;

- (void)animateLeftWithCompletionBlock:(COMPLETION_BLOCK)block;
- (void)animateRightWithCompletionBlock:(COMPLETION_BLOCK)block;
- (void)animateBackToRect:(CGRect)rect;

- (void)resetImage;
@end

@protocol SWExploreFeedItemViewDelegate <NSObject>

- (void)feedItemViewDidPressAvatar:(SWFeedUserItem *)userItem;
- (void)feedItemViewDidPressTag:(SWFeedTagItem *)tagItem;
- (void)feedItemViewDidPressImage:(SWFeedItem *)feedItem rect:(CGRect)rect;

@end