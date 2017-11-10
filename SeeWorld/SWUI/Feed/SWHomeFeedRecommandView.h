//
//  SWHomeFeedRecommandView.h
//  SeeWorld
//
//  Created by Albert Lee on 8/31/15.
//  Copyright (c) 2015 SeeWorld. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWFeedItem.h"
@protocol SWHomeFeedRecommandViewDelegate;
@interface SWHomeFeedRecommandView : UIView
@property(nonatomic, weak)id<SWHomeFeedRecommandViewDelegate>delegate;
@property(nonatomic, strong)UIButton *btnHide;

- (void)refreshWithUsers:(NSArray *)users;
@end

@protocol SWHomeFeedRecommandViewDelegate <NSObject>
- (void)feedRecommandDidPressUser:(SWFeedUserItem *)user;
- (void)feedRecommandDidPressAdd:(SWFeedUserItem *)user;
- (void)feedRecommandDidPressMore:(SWHomeFeedRecommandView *)view;

@end
