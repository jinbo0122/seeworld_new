//
//  SWNoticeModel.h
//  SeeWorld
//
//  Created by Albert Lee on 9/23/15.
//  Copyright © 2015 SeeWorld. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SWNoticeMsgItem.h"
@protocol SWNoticeModelDelegate;
@interface SWNoticeModel : NSObject
@property(nonatomic,   weak)id<SWNoticeModelDelegate>delegate;
@property(nonatomic, strong)NSMutableArray *notices;
@property(nonatomic, assign)BOOL            isLoadingNotices;
@property(nonatomic, strong)NSNumber       *lastMsgIdNotices;
@property(nonatomic, assign)BOOL            hasMoreNotices;
@property(nonatomic, assign)BOOL            isInNoticeVC;
@property(nonatomic, assign)NSInteger       freshDotIndex;
@property(nonatomic, assign)NSInteger       unreadNoticeCount;

+ (SWNoticeModel *)sharedInstance;

- (void)startRefreshing;
- (void)endRefreshing;
- (void)reloadNotices;

- (void)getLatestNotices;
- (void)getMoreNotices;
- (void)syncContentData;

- (void)syncGetuiCID;
- (void)pushOpen:(BOOL)open;
- (BOOL)pushOpenStatus;
- (void)processFollow:(SWFeedLikeItem *)likeItem;
- (void)markReadMsg:(SWNoticeMsgItem *)msgItem;
@end


@protocol SWNoticeModelDelegate <NSObject>
- (void)noticeModelDidLoadNotices:(SWNoticeModel *)model;
@end