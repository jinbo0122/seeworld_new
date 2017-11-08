//
//  SWExploreModel.h
//  SeeWorld
//
//  Created by Albert Lee on 9/9/15.
//  Copyright (c) 2015 SeeWorld. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol SWExploreModelDelegate;
@interface SWExploreModel : NSObject
@property(nonatomic,  weak)id<SWExploreModelDelegate>delegate;
@property(nonatomic, strong)NSMutableArray *feeds;
@property(nonatomic, strong)NSNumber       *lastFeedId;
@property(nonatomic, assign)BOOL            hasMore;
@property(nonatomic, assign)NSInteger       currentIndex;

@property(nonatomic, assign)NSInteger       currentSegIndex;


- (void)getLatestFeeds;
- (void)getNextPageFeeds;
- (void)operateFeed:(SWFeedItem *)feedItem like:(BOOL)like;
@end

@protocol SWExploreModelDelegate <NSObject>
- (void)exploreModelDidGetPhotos:(SWExploreModel*)model feedId:(NSNumber *)feedId;
- (void)exploreModelDidFailGetPhotos:(SWExploreModel*)model;

- (void)exploreModelDidLetRefreshAvailable:(SWExploreModel *)model;
- (void)exploreModelDidOperateFeed:(SWFeedItem *)feedItem;
@end
