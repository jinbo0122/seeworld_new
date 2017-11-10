//
//  SWHomeFeedModel.h
//  SeeWorld
//
//  Created by Albert Lee on 8/31/15.
//  Copyright (c) 2015 SeeWorld. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SWFeedItem.h"
#import "SWFeedModelProtocol.h"
@protocol SWHomeFeedModelDelegate;

@interface SWHomeFeedModel : NSObject<SWFeedModelProtocol>
@property(nonatomic,   weak)id<SWHomeFeedModelDelegate>delegate;
@property(nonatomic, strong)NSNumber       *lastFeedId;
@property(nonatomic, assign)BOOL            hasMore;
@property(nonatomic, assign)BOOL            isLoading;
- (void)getLatestFeeds;
- (void)loadMoreFeeds;

- (void)getRecommandUser;
- (void)addFollowUser:(SWFeedUserItem *)userItem;
@end

@protocol SWHomeFeedModelDelegate <NSObject>

- (void)homeFeedModelDidLoadContents:(SWHomeFeedModel *)model;
- (void)homeFeedModelDidPressLike:(SWHomeFeedModel *)model row:(NSInteger)row;
@optional
- (void)homeFeedModelDidRecommandUser:(NSArray *)users;

@end
