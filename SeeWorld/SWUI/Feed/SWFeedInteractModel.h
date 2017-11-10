//
//  SWFeedInteractModel.h
//  SeeWorld
//
//  Created by Albert Lee on 9/2/15.
//  Copyright (c) 2015 SeeWorld. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol SWFeedInteractModelDelegate;

@interface SWFeedInteractModel : NSObject
@property(nonatomic,   weak)id<SWFeedInteractModelDelegate>delegate;
@property(nonatomic, strong)SWFeedItem *feedItem;

- (void)processFollow:(SWFeedLikeItem *)likeItem;

- (void)deleteComment:(SWFeedCommentItem *)commentItem;
- (void)sendComment:(NSString *)comment;
- (void)sendImage:(UIImage *)image replyUser:(SWFeedUserItem *)replyUser;
- (void)sendComment:(NSString *)comment replyUser:(SWFeedUserItem *)replyUser;
- (void)getComments;
- (void)getLikes;

@end

@protocol SWFeedInteractModelDelegate <NSObject>

- (void)feedInteractModelDidLoadComments:(SWFeedInteractModel *)model;
- (void)feedInteractModelDidDeleteComments:(SWFeedInteractModel *)model;
- (void)feedInteractModelDidSendComments:(SWFeedInteractModel *)model;
- (void)feedInteractModelDidSendImages:(SWFeedInteractModel *)model;

@optional
- (void)feedInteractModelDidLoadLikes:(SWFeedInteractModel *)model;
@end
