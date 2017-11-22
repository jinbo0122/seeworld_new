//
//  SWHomeFeedCell.h
//  SeeWorld
//
//  Created by Albert Lee on 8/31/15.
//  Copyright (c) 2015 SeeWorld. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWFeedItem.h"
#import "SWFeedImageView.h"
@protocol SWHomeFeedCellDelegate;
@interface SWHomeFeedCell : UITableViewCell
@property(nonatomic, strong)SWFeedImageView           *feedImageView;
@property(nonatomic, weak)id<SWHomeFeedCellDelegate>delegate;

- (void)refreshHomeFeed:(SWFeedItem *)feed row:(NSInteger)row;
+ (CGFloat)heightByFeed:(SWFeedItem *)feed;
@end


@protocol SWHomeFeedCellDelegate <NSObject>
- (void)homeFeedCellDidPressUser:(SWFeedUserItem *)userItem;
- (void)homeFeedCellDidPressLike:(SWFeedItem *)feedItem row:(NSInteger)row;
- (void)homeFeedCellDidPressReply:(SWFeedItem *)feedItem row:(NSInteger)row enableKeyboard:(BOOL)enableKeyboard;
- (void)homeFeedCellDidPressUrl:(NSURL *)url row:(NSInteger)row;
- (void)homeFeedCellDidPressShare:(SWFeedItem *)feedItem row:(NSInteger)row;
- (void)homeFeedCellDidPressLikeList:(SWFeedItem *)feedItem row:(NSInteger)row;
- (void)homeFeedCellDidPressTag:(SWFeedTagItem *)tagItem;
- (void)homeFeedCellDidPressImage:(SWFeedItem *)feedItem rects:(NSArray *)rects atIndex:(NSInteger)index;
@end
