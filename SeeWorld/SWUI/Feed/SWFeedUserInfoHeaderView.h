//
//  SWFeedUserInfoHeaderView.h
//  SeeWorld
//
//  Created by Albert Lee on 8/31/15.
//  Copyright (c) 2015 SeeWorld. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWFeedItem.h"
@protocol SWFeedUserInfoHeaderViewDelegate;
@interface SWFeedUserInfoHeaderView : UIButton
@property(nonatomic, strong)id<SWFeedUserInfoHeaderViewDelegate>delegate;
- (void)refresshWithFeed:(SWFeedItem *)feedItem;
@end


@protocol SWFeedUserInfoHeaderViewDelegate<NSObject>

- (void)feedUserInfoHeaderViewDidPressAvatar:(SWFeedUserInfoHeaderView *)headerView;
//- (void)feedUserInfoHeaderViewDidNeedEnterDetail:(SWFeedUserInfoHeaderView *)headerView;

@end
