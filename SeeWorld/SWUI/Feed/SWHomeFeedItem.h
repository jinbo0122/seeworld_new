//
//  SWHomeFeedItem.h
//  SeeWorld
//
//  Created by Albert Lee on 8/31/15.
//  Copyright (c) 2015 SeeWorld. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SWFeedItem.h"
@interface SWHomeFeedItem : NSObject
@property (nonatomic, strong)NSNumber *lastFeedID;
@property (nonatomic, strong)NSNumber *hasMore;
@property (nonatomic, strong)NSMutableArray  *feeds;

+ (SWHomeFeedItem *)homeFeedItemFromDic:(NSDictionary *)dic;
+ (SWHomeFeedItem *)homeFeedItemFromDic:(NSDictionary *)dic prefetch:(BOOL)needPrefetch;
@end
