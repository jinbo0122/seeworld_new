//
//  SWFeedInteractModel.m
//  SeeWorld
//
//  Created by Albert Lee on 9/2/15.
//  Copyright (c) 2015 SeeWorld. All rights reserved.
//

#import "SWFeedInteractModel.h"
#import "SWUserAddFollowAPI.h"
#import "SWUserRemoveFollowAPI.h"
#import "SWFeedLikeListAPI.h"
#import "GetQiniuTokenApi.h"
#import "GetQiniuTokenResponse.h"
#import "QiniuSDK.h"
#import "SWFeedCommentListAPI.h"
#import "SWCommentAddAPI.h"
#import "SWCommentDeleteAPI.h"
#import "SWObject.h"
#import "SWHUD.h"
@implementation SWFeedInteractModel
- (void)processFollow:(SWFeedLikeItem *)likeItem{
  SWUserRelationType type = [likeItem.user.relation integerValue];
  
  if (type==SWUserRelationTypeFollowing||
      type==SWUserRelationTypeInterFollow) {
    SWUserAddFollowAPI *api = [[SWUserAddFollowAPI alloc] init];
    api.uId = likeItem.user.uId;
    [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
      [SWUserAddFollowAPI showSuccessTip];
    } failure:^(YTKBaseRequest *request) {
      
    }];
  }else{
    SWUserRemoveFollowAPI *api = [[SWUserRemoveFollowAPI alloc] init];
    api.uId = likeItem.user.uId;
    [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
      
    } failure:^(YTKBaseRequest *request) {
      
    }];
  }
}

- (void)deleteComment:(SWFeedCommentItem *)commentItem{
  SWCommentDeleteAPI *api = [[SWCommentDeleteAPI alloc] init];
  api.fId = self.feedItem.feed.fId;
  api.commentId = commentItem.commentId;
  
  [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
    
  } failure:^(YTKBaseRequest *request) {
    
  }];
  
  [self.feedItem.comments removeObject:commentItem];
  
  if (self.delegate && [self.delegate respondsToSelector:@selector(feedInteractModelDidDeleteComments:)]) {
    [self.delegate feedInteractModelDidDeleteComments:self];
  }
}

- (void)sendComment:(NSString *)comment{
  [self sendComment:comment replyUser:nil];
}

- (void)sendImage:(UIImage *)image{
  [self sendImage:image replyUser:nil];
}

- (void)sendImage:(UIImage *)image replyUser:(SWFeedUserItem *)replyUser{
  __weak typeof(self)wSelf = self;
  CGSize imageSize = image.size;
  [SWHUD showWaiting];
  GetQiniuTokenApi *api = [[GetQiniuTokenApi alloc] init];
  [api startWithModelClass:[GetQiniuTokenResponse class] completionBlock:^(ModelMessage *message) {
    if (message.isSuccess){
      GetQiniuTokenResponse *resp = message.object;
      NSString *token = resp.data;
      QNUploadManager *manager = [[QNUploadManager alloc] init];
      NSData *imageData = UIImageJPEGRepresentation(image, 0.3);
      [manager putData:imageData key:[SWObject createUUID] token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
        if (info.ok && resp[@"key"]){
          NSString *imageURL = [NSString stringWithFormat:@"http://7xlsvh.com1.z0.glb.clouddn.com/%@",[resp valueForKey:@"key"]];
          [wSelf sendComment:imageURL replyUser:replyUser imageSize:imageSize];
          [SWHUD hideWaiting];
          SWFeedCommentItem *item = [[SWFeedCommentItem alloc] init];
          item.user = [SWFeedUserItem myself];
          item.text = [@{@"text":imageURL,@"isImage":@1,@"width":@(imageSize.width),@"height":@(imageSize.height)} JSONString];
          item.commentId = @1000;
          [wSelf.feedItem.comments safeAddObject:item];
          if (wSelf.delegate && [wSelf.delegate respondsToSelector:@selector(feedInteractModelDidSendImages:)]) {
            [wSelf.delegate feedInteractModelDidSendImages:wSelf];
          }
        }else{
          [SWHUD hideWaiting];
          [SWHUD showCommonToast:(message.message.length == 0? @"發佈失败":message.message)];
        }
      } option:nil];
    }else{
      [SWHUD hideWaiting];
      [SWHUD showCommonToast:(message.message.length == 0? @"發佈失败":message.message)];
    }
  }];
}

- (void)sendComment:(NSString *)comment replyUser:(SWFeedUserItem *)replyUser{
  [self sendComment:comment replyUser:replyUser imageSize:CGSizeZero];
}

- (void)sendComment:(NSString *)comment replyUser:(SWFeedUserItem *)replyUser imageSize:(CGSize)imageSize{
  SWCommentAddAPI *api = [[SWCommentAddAPI alloc] init];
  api.fId = self.feedItem.feed.fId;
  
  NSMutableDictionary *commentInfo = [NSMutableDictionary dictionary];
  if (replyUser) {
    [commentInfo setSafeObject:[replyUser dicValue] forKey:@"replyUser"];
    [commentInfo setSafeObject:@1 forKey:@"isReply"];
  }
  
  [commentInfo setSafeObject:comment forKey:@"text"];
  if (imageSize.width>0) {
    [commentInfo setSafeObject:@1 forKey:@"isImage"];
    [commentInfo setSafeObject:@(imageSize.width) forKey:@"width"];
    [commentInfo setSafeObject:@(imageSize.height) forKey:@"height"];
  }
  
  api.text = [commentInfo JSONString];
  __weak typeof(self)wSelf = self;
  [SWHUD showWaiting];
  [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
   if (wSelf.delegate && [wSelf.delegate respondsToSelector:@selector(feedInteractModelDidSendComments:)]) {
     [wSelf.delegate feedInteractModelDidSendComments:wSelf];
   }
    [SWHUD hideWaiting];
  } failure:^(YTKBaseRequest *request) {
    [SWHUD hideWaiting];
  }];
//  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//    [SWHUD hideWaiting];
//    if (wSelf.delegate && [wSelf.delegate respondsToSelector:@selector(feedInteractModelDidSendComments:)]) {
//      [wSelf.delegate feedInteractModelDidSendComments:wSelf];
//    }
//  });
}

- (void)getLikes{
  SWFeedLikeListAPI *api = [[SWFeedLikeListAPI alloc] init];
  api.fId = self.feedItem.feed.fId;
  
  __weak typeof(self)wSelf = self;
  [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
    NSDictionary *dic = [request.responseString safeJsonDicFromJsonString];
    NSArray *likes = [dic safeArrayObjectForKey:@"data"];
    
    [wSelf.feedItem.likes removeAllObjects];
    for (NSInteger i=0; i<likes.count; i++) {
      [wSelf.feedItem.likes safeAddObject:[SWFeedLikeItem feedLikeItem:[likes safeDicObjectAtIndex:i]]];
    }
    if (wSelf.delegate && [wSelf.delegate respondsToSelector:@selector(feedInteractModelDidLoadLikes:)]) {
      [wSelf.delegate feedInteractModelDidLoadLikes:wSelf];
    }
  } failure:^(YTKBaseRequest *request) {
    if (wSelf.delegate && [wSelf.delegate respondsToSelector:@selector(feedInteractModelDidLoadLikes:)]) {
      [wSelf.delegate feedInteractModelDidLoadLikes:wSelf];
    }
  }];
}

- (void)getComments{
  SWFeedCommentListAPI *api = [[SWFeedCommentListAPI alloc] init];
  api.fId = self.feedItem.feed.fId;
  
  __weak typeof(self)wSelf = self;
  
  [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
    NSDictionary *dic = [request.responseString safeJsonDicFromJsonString];
    NSArray *comments = [dic safeArrayObjectForKey:@"data"];
    
    [wSelf.feedItem.comments removeAllObjects];
    for (NSInteger i=0; i<comments.count; i++) {
      [wSelf.feedItem.comments safeAddObject:[SWFeedCommentItem feedCommentItem:[comments safeDicObjectAtIndex:i]]];
    }
    if (wSelf.delegate && [wSelf.delegate respondsToSelector:@selector(feedInteractModelDidLoadComments:)]) {
      [wSelf.delegate feedInteractModelDidLoadComments:wSelf];
    }
  } failure:^(YTKBaseRequest *request) {
    if (wSelf.delegate && [wSelf.delegate respondsToSelector:@selector(feedInteractModelDidLoadComments:)]) {
      [wSelf.delegate feedInteractModelDidLoadComments:wSelf];
    }
  }];
}
@end
