//
//  SWHomeFeedModel.h
//  SeeWorld
//
//  Created by Albert Lee on 8/31/15.
//  Copyright (c) 2015 SeeWorld. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SWFeedItem.h"
@protocol SWHomeFeedModelDelegate;

@interface SWHomeFeedModel : NSObject
@property(nonatomic,   weak)id<SWHomeFeedModelDelegate>delegate;
@property(nonatomic, strong)NSMutableArray *feeds;
@property(nonatomic, strong)NSNumber       *lastFeedId;
@property(nonatomic, assign)BOOL            hasMore;
@property(nonatomic, assign)BOOL            isLoading;
- (void)getLatestFeeds;
- (void)loadMoreFeeds;

- (void)getRecommandUser;
- (void)addFollowUser:(SWFeedUserItem *)userItem;

- (void)likeClickedByRow:(NSInteger)row;
@end

@protocol SWHomeFeedModelDelegate <NSObject>

- (void)homeFeedModelDidLoadContents:(SWHomeFeedModel *)model;
- (void)homeFeedModelDidPressLike:(SWHomeFeedModel *)model row:(NSInteger)row;
@optional
- (void)homeFeedModelDidRecommandUser:(SWFeedUserItem *)user;

@end
