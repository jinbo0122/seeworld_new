//
//  SWFeedImageView.h
//  SeeWorld
//
//  Created by Albert Lee on 8/31/15.
//  Copyright (c) 2015 SeeWorld. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWFeedItem.h"
#import "WTTagView.h"
@protocol SWFeedImageViewDelegate;
@interface SWFeedImageView : UIView
@property(nonatomic,   weak)id<SWFeedImageViewDelegate>delegate;
@property(nonatomic, strong)WTTagView *tagView;
- (void)refreshWithFeed:(SWFeedItem *)feedItem;
- (void)refreshWithFeed:(SWFeedItem *)feedItem showTag:(BOOL)showTag;
@end

@protocol SWFeedImageViewDelegate <NSObject>
- (void)feedImageViewDidPressTag:(SWFeedTagItem *)tagItem;
- (void)feedImageViewDidPressImage:(SWFeedItem *)feedItem;
- (void)feedImageViewDidPressImage:(SWFeedItem *)feedItem buttonFrames:(NSArray *)buttonFrames atIndex:(NSInteger)index;
@end
