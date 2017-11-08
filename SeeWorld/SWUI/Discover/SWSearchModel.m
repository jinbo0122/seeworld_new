//
//  SWSearchModel.m
//  SeeWorld
//
//  Created by Albert Lee on 9/9/15.
//  Copyright (c) 2015 SeeWorld. All rights reserved.
//

#import "SWSearchModel.h"
#import "SWUserAddFollowAPI.h"
#import "SWUserRemoveFollowAPI.h"
#import "SWSearchFriendAPI.h"
#import "SWSearchTagAPI.h"
#import "SWSearchModel.h"
@implementation SWSearchModel{
  NSString *_currectSearchString;
}
- (id)init{
  if (self = [super init]) {
    self.users = [NSMutableArray array];
    self.tags  = [NSMutableArray array];
    
    self.currentIndex = 0;
  }
  return self;
}

- (void)setCurrentIndex:(NSInteger)currentIndex{
  if (currentIndex!=_currentIndex) {
    _currentIndex = currentIndex;
    if (_currentIndex == 0) {
      [self searchUserByName:_currectSearchString force:YES];
    }else{
      [self searchTag:_currectSearchString force:YES];
    }
  }
}

- (void)searchUserByName:(NSString *)name{
  [self searchUserByName:name force:NO];
}

- (void)searchUserByName:(NSString *)name force:(BOOL)force{
  if (name.length==0) {
    _currectSearchString = @"";
    
    [self.users removeAllObjects];
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchFriendDidReturnResults:string:)]) {
      [self.delegate searchFriendDidReturnResults:self string:name];
    }
    return;
  }
  
  
  if (![name isEqualToString:_currectSearchString] || force) {
    _currectSearchString = [name copy];
    SWSearchFriendAPI *api = [[SWSearchFriendAPI alloc] init];
    api.query = name?name:@"";
    __weak typeof(self)wSelf = self;
    [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
      NSDictionary *dic = [request.responseString safeJsonDicFromJsonString];
      NSArray *data = [dic safeArrayObjectForKey:@"data"];
      
      [wSelf.users removeAllObjects];
      for (NSInteger i=0; i<data.count; i++) {
        [wSelf.users addObject:[SWFeedUserItem feedUserItemByDic:[data safeDicObjectAtIndex:i]]];
      }
      
      if (wSelf.delegate && [wSelf.delegate respondsToSelector:@selector(searchFriendDidReturnResults:string:)]) {
        [wSelf.delegate searchFriendDidReturnResults:wSelf string:name];
      }
    } failure:^(YTKBaseRequest *request) {
      
    }];
  }
}

- (void)searchTag:(NSString *)tag{
  [self searchTag:tag force:NO];
}

- (void)searchTag:(NSString *)tag force:(BOOL)force{
  if (tag.length==0) {
    _currectSearchString = @"";
    
    [self.tags removeAllObjects];
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchTagDidReturnResults:tag:)]) {
      [self.delegate searchTagDidReturnResults:self tag:tag];
    }
    return;
  }
  
  if (![tag isEqualToString:_currectSearchString] || force) {
    _currectSearchString = tag;
    //搜索tag
    
    SWSearchTagAPI *api = [[SWSearchTagAPI alloc] init];
    api.query = tag?tag:@"";
    __weak typeof(self)wSelf = self;
    [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
      NSDictionary *dic = [request.responseString safeJsonDicFromJsonString];
      NSArray *data = [dic safeArrayObjectForKey:@"data"];
      
      [wSelf.tags removeAllObjects];
      for (NSInteger i=0; i<data.count; i++) {
        [wSelf.tags addObject:[SWTagItem tagItemByDic:[data safeDicObjectAtIndex:i]]];
      }
      
      if(isFakeDataOn){
        SWFeedTagItem *tagA = [[SWFeedTagItem alloc] init];
        tagA.tagId = @1;
        tagA.tagName = [tag copy];
        [wSelf.tags addObject:tagA];
      }
      
      if (wSelf.delegate && [wSelf.delegate respondsToSelector:@selector(searchTagDidReturnResults:tag:)]) {
        [wSelf.delegate searchTagDidReturnResults:wSelf tag:tag];
      }
    } failure:^(YTKBaseRequest *request) {
      
    }];
  }
}

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
@end
