//
//  SWTagFeedsModel.h
//  SeeWorld
//
//  Created by Albert Lee on 9/3/15.
//  Copyright (c) 2015 SeeWorld. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SWFeedModelProtocol.h"
@protocol SWTagFeedsModelDelegate;
@interface SWTagFeedsModel : NSObject<SWFeedModelProtocol>
@property (nonatomic, strong)SWFeedTagItem *tagItem;
@property (nonatomic, weak  )id<SWTagFeedsModelDelegate>delegate;
@property(nonatomic, strong)NSNumber       *lastFeedId;
@property(nonatomic, strong)NSNumber       *feedCount;
@property(nonatomic, assign)BOOL            hasMore;
@property(nonatomic, assign)BOOL            isLoading;
@property(nonatomic, assign)BOOL            isFromNotice;

- (void)loadCache;
- (void)getLatestTagFeeds;
- (void)getMoreTagFeeds;

@end

@protocol SWTagFeedsModelDelegate <NSObject>

- (void)tagFeedModelDidLoadContents:(SWTagFeedsModel *)model;
@optional
- (void)tagFeedModelDidNeedRefresh:(SWTagFeedsModel *)model;
- (void)tagFeedModelDidPressLike:(SWTagFeedsModel *)model row:(NSInteger)row;
@end
