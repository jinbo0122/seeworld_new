//
//  SWFeedItem.h
//  SeeWorld
//
//  Created by Albert Lee on 8/31/15.
//  Copyright (c) 2015 SeeWorld. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SWFeedComposeAPI.h"
@class SWFeedInfoItem;
@class SWFeedUserItem;
@class SWFeedLikeItem;
@class SWFeedTagCoordItem;
@class SWFeedTagItem;
@class SWFeedImageItem;
@class SWFeedLinkItem;
@interface SWFeedItem : NSObject
@property (nonatomic, strong)SWFeedInfoItem *feed;
@property (nonatomic, strong)SWFeedUserItem *user;
@property (nonatomic, strong)NSMutableArray *likes;
@property (nonatomic, strong)NSMutableArray *comments;
@property (nonatomic, strong)NSNumber       *likeCount;
@property (nonatomic, strong)NSNumber       *commentCount;
@property (nonatomic, strong)NSNumber       *isLiked;
+ (SWFeedItem *)feedItemByDic:(NSDictionary *)feedDic;
@end


@interface SWFeedInfoItem : NSObject
@property (nonatomic, strong)NSNumber       *fId;
@property (nonatomic, assign)SWFeedType     type;
@property (nonatomic, strong)NSMutableArray *photos;
@property (nonatomic, strong)NSString       *content;
@property (nonatomic, strong)NSString       *videoUrl;
@property (nonatomic, strong)SWFeedLinkItem *link;
@property (nonatomic, strong)NSNumber       *time;
+ (SWFeedInfoItem *)feedInfoItemByDic:(NSDictionary *)feedInfoDic;
- (SWFeedInfoItem *)copy;
- (NSString *)firstPicUrl;
- (NSArray *)photoUrls;
- (NSArray *)photoUrlsWithSuffix:(NSString *)suffix;
@end

@interface SWFeedImageItem : NSObject
@property (nonatomic, assign)NSInteger      index;
@property (nonatomic, strong)NSString       *picUrl;
@property (nonatomic, assign)CGFloat        width;
@property (nonatomic, assign)CGFloat        height;
@property (nonatomic, strong)NSMutableArray *tags;

+ (NSMutableArray *)feedImagesByPhotos:(NSString *)photoJson tags:(NSArray *)tags;
- (SWFeedImageItem *)copy;
@end

@interface SWFeedLinkItem : NSObject
@property (nonatomic, strong)NSString       *linkUrl;
@property (nonatomic, strong)NSString       *title;
@property (nonatomic, strong)NSString       *imageUrl;
+ (SWFeedLinkItem *)feedLinkItem:(NSString *)linkJson;
- (SWFeedLinkItem *)copy;
@end

typedef enum : NSUInteger {
  SWUserRelationTypeSelf = 0,
  SWUserRelationTypeFollowing = 1,
  SWUserRelationTypeFollowed  = 2,
  SWUserRelationTypeInterFollow = 3,
  SWUserRelationTypeUnrelated = 4,
} SWUserRelationType;

@interface SWFeedUserItem : NSObject
@property (nonatomic, strong)NSNumber       *uId;
@property (nonatomic, strong)NSString       *name;
@property (nonatomic, strong)NSString       *picUrl;
@property (nonatomic, strong)NSString       *intro;
@property (nonatomic, strong)NSNumber       *gender;
@property (nonatomic, strong)NSNumber       *relation;
@property (nonatomic, strong)NSNumber       *feedCount;
@property (nonatomic, strong)NSNumber       *followerCount;
@property (nonatomic, strong)NSNumber       *followedCount;
@property (nonatomic, strong)NSString       *bghead;
@property (nonatomic, strong)NSNumber       *issecret;
@property (nonatomic, strong)NSNumber       *admin;
+ (SWFeedUserItem *)feedUserItemByDic:(NSDictionary *)feedUserDic;
+ (SWFeedUserItem *)feedUserItemBySelfDic:(NSDictionary *)feedUserDic;
+ (SWFeedUserItem *)myself;
- (SWFeedUserItem *)copy;
+ (void)pushUserVC:(SWFeedUserItem *)user nav:(UINavigationController *)nav;

- (NSDictionary *)vcDicValue;
- (NSDictionary *)dicValue;
@end

@interface SWFeedLikeItem : NSObject
@property (nonatomic, strong)SWFeedUserItem *user;
@property (nonatomic, strong)NSNumber       *time;
+ (SWFeedLikeItem *)feedLikeItem:(NSDictionary *)feedLikeDic;
@end

@interface SWFeedCommentItem : NSObject
@property (nonatomic, strong)SWFeedUserItem *user;
@property (nonatomic, strong)NSNumber       *time;
@property (nonatomic, strong)NSNumber       *commentId;
@property (nonatomic, strong)NSString       *text;
+ (SWFeedCommentItem *)feedCommentItem:(NSDictionary *)feedCommentDic;
@end

@interface SWFeedTagItem : NSObject
@property (nonatomic, strong)NSNumber       *tagId;
@property (nonatomic, strong)NSString       *tagName;
@property (nonatomic, strong)NSNumber       *direction;
@property (nonatomic, strong)SWFeedTagCoordItem *coord;
+ (SWFeedTagItem *)feedTagItemByDic:(NSDictionary *)tagDic;
- (SWFeedTagItem *)copy;
@end

@interface SWTagItem : NSObject
@property (nonatomic, strong)NSNumber       *tagId;
@property (nonatomic, strong)NSString       *tagName;
@property (nonatomic, strong)NSNumber       *tagCount;
+ (SWTagItem *)tagItemByDic:(NSDictionary *)tagDic;
@end

@interface SWFeedTagCoordItem : NSObject
@property (nonatomic, strong)NSNumber       *x;
@property (nonatomic, strong)NSNumber       *y;
@property (nonatomic, strong)NSNumber       *w;
@property (nonatomic, strong)NSNumber       *h;
+ (SWFeedTagCoordItem *)feedTagCoordItemByDic:(NSDictionary *)coordDic;
- (SWFeedTagCoordItem *)copy;
@end
