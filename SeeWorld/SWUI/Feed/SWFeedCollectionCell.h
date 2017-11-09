//
//  SWFeedCollectionCell.h
//  SeeWorld
//
//  Created by Albert Lee on 9/3/15.
//  Copyright (c) 2015 SeeWorld. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWFeedItem.h"
#import "SWFeedImageView.h"
@protocol SWFeedDetailViewDelegate;
@interface SWFeedCollectionCell : UICollectionViewCell
@property(nonatomic, strong)SWFeedImageView           *feedImageView;
@property(nonatomic, weak)id<SWFeedDetailViewDelegate>delegate;

- (void)refreshFeedView:(SWFeedItem *)feed row:(NSInteger)row;
+ (CGFloat)heightByFeed:(SWFeedItem *)feed;
@end


@protocol SWFeedDetailViewDelegate <NSObject>
- (void)feedDetailViewDidPressUser:(SWFeedUserItem *)userItem;
- (void)feedDetailViewDidPressLike:(SWFeedItem *)feedItem row:(NSInteger)row;
- (void)feedDetailViewDidPressReply:(SWFeedItem *)feedItem row:(NSInteger)row;
- (void)feedDetailViewDidPressUrl:(NSURL *)url row:(NSInteger)row;
- (void)feedDetailViewDidPressShare:(SWFeedItem *)feedItem row:(NSInteger)row;
- (void)feedDetailViewDidPressLikeList:(SWFeedItem *)feedItem row:(NSInteger)row;
- (void)feedDetailViewDidPressTag:(SWFeedTagItem *)tagItem;
- (void)feedDetailViewDidPressImage:(SWFeedItem *)feedItem rect:(CGRect)rect;
- (void)feedDetailViewDidNeedReload:(NSNumber *)imageHeight row:(NSInteger)row;

@end
