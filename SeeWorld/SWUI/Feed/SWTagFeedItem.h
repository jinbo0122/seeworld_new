//
//  SWTagFeedItem.h
//  SeeWorld
//
//  Created by Albert Lee on 9/3/15.
//  Copyright (c) 2015 SeeWorld. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SWHomeFeedItem.h"
@class SWTagInfoItem;
@interface SWTagFeedItem : NSObject
@property (nonatomic, strong)SWTagInfoItem  *tag;
@property (nonatomic, strong)SWHomeFeedItem *feedList;
+ (SWTagFeedItem *)tagFeedItemByDic:(NSDictionary *)dic prefetch:(BOOL)prefetch;
@end

@interface SWTagInfoItem : NSObject
@property (nonatomic, strong)NSNumber *tagId;
@property (nonatomic, strong)NSString *tagName;
@property (nonatomic, strong)NSNumber *feedCount;
+ (SWTagInfoItem *)tagInfoItemByDic:(NSDictionary *)dic;
@end
