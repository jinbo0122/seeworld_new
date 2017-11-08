//
//  SWFeedLikeMemberView.h
//  SeeWorld
//
//  Created by Albert Lee on 8/31/15.
//  Copyright (c) 2015 SeeWorld. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWFeedItem.h"
@protocol SWFeedLikeMemberViewDelegate;
@interface SWFeedLikeMemberView : UIView
@property(nonatomic,   weak)id<SWFeedLikeMemberViewDelegate>delegate;
@property(nonatomic, strong)UITapGestureRecognizer  *tapGesture;
- (void)refreshWithFeedLikes:(NSArray *)feedLikes count:(NSInteger)count;
@end

@protocol SWFeedLikeMemberViewDelegate <NSObject>
- (void)feedLikeMemberViewDidPressUser:(SWFeedUserItem *)userItem;
- (void)feedLikeMemberViewDidPressMore:(SWFeedLikeMemberView *)view;
@end