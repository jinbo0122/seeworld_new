//
//  SWNoticeModel.m
//  SeeWorld
//
//  Created by Albert Lee on 9/23/15.
//  Copyright © 2015 SeeWorld. All rights reserved.
//

#import "SWNoticeModel.h"
#import "TabViewController.h"
@implementation SWNoticeModel{
  NSTimer *_timer;
  NSMutableArray *_timerNotices;
  
  NSNumber *_firstLocalNoticeMId;
}
+ (SWNoticeModel *)sharedInstance{
  static dispatch_once_t once;
  static SWNoticeModel   *noticeModel = nil;
  dispatch_once(&once, ^{
    noticeModel = [[SWNoticeModel alloc] init];
  });
  return noticeModel;
}

- (id)init{
  if (self = [super init]) {
    self.notices = [NSMutableArray array];
    
    _timerNotices = [NSMutableArray array];
    
    _firstLocalNoticeMId = [[NSUserDefaults standardUserDefaults] safeNumberObjectForKey:@"firstLocalNoticeMId"];
    _freshDotIndex = -1;
  }
  return self;
}

- (void)startRefreshing{
  _timer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(reloadNotices) userInfo:nil repeats:YES];
  [_timer fire];
}

- (void)endRefreshing{
  if (_timer && [_timer isValid]) {
    [_timer invalidate];
  }
}

- (void)reloadNotices{
  [self getNoticesByMsgId:@0 isFromTimer:YES];
}

- (void)dealDot{
  if (_timerNotices.count>0) {
    SWNoticeMsgItem *oldMsgItem;
    if (self.notices.count==0&&[_firstLocalNoticeMId integerValue]==0) {
      _freshDotIndex = 0;
      _unreadNoticeCount = _timerNotices.count;
    }else{
      oldMsgItem = [self.notices safeObjectAtIndex:0];
      _unreadNoticeCount = 0;
    }
    
    for (NSInteger i=0;i<_timerNotices.count;i++) {
      SWNoticeMsgItem *msgItem = [_timerNotices safeObjectAtIndex:i];
      if ([msgItem.status integerValue]==0&&
          [msgItem.mId integerValue]>[oldMsgItem.mId integerValue]&&
          [msgItem.mId integerValue]>[_firstLocalNoticeMId integerValue]) {
        _freshDotIndex = 0;
        _unreadNoticeCount++;
      }
    }
  }
  [TabViewController dotAppearance];

}

- (void)syncContentData{
  [self.notices removeAllObjects];
  for (NSInteger i=0;i<_timerNotices.count;i++) {
    [self.notices safeAddObject:[_timerNotices safeObjectAtIndex:i]];
    if(self.delegate && [self.delegate respondsToSelector:@selector(noticeModelDidLoadNotices:)]){
      [self.delegate noticeModelDidLoadNotices:self];
    }
    if (i==0) {
      _firstLocalNoticeMId = [(SWNoticeMsgItem*)[self.notices safeObjectAtIndex:i] mId];
      [[NSUserDefaults standardUserDefaults] setSafeNumberObject:_firstLocalNoticeMId forKey:@"firstLocalNoticeMId"];
      [[NSUserDefaults standardUserDefaults] synchronize];
    }
  }
  
  self.freshDotIndex = -1;
  
  _unreadNoticeCount = 0;
  [TabViewController dotAppearance];
}

- (void)syncGetuiCID{
  NSString *jwt = [[NSUserDefaults standardUserDefaults] safeStringObjectForKey:@"jwt"];
  NSString *cId = [[NSUserDefaults standardUserDefaults] safeStringObjectForKey:@"GetuiCID"];
  
  if (jwt.length>0&&cId.length>0) {
    SWPushSyncAPI *api = [[SWPushSyncAPI alloc] init];
    api.cid = cId;
    [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
      
    } failure:^(YTKBaseRequest *request) {
      
    }];
  }

}

- (void)getLatestNotices{
  _hasMoreNotices = YES;
  [self getNoticesByMsgId:@0 isFromTimer:NO];
}

- (void)getMoreNotices{
  if (!self.isLoadingNotices) {
    self.isLoadingNotices = YES;
    if (_hasMoreNotices) {
      [self getNoticesByMsgId:self.lastMsgIdNotices isFromTimer:NO];
    }
  }
}

- (void)getNoticesByMsgId:(NSNumber *)mId isFromTimer:(BOOL)isFromTimer{
  SWNoticeAPI *api = [[SWNoticeAPI alloc] init];
  api.lastMessageId = mId?mId:@0;
  __weak typeof(self)wSelf = self;
  __block typeof(_timerNotices)wTimerNotices = _timerNotices;
  __block typeof(_firstLocalNoticeMId)localNoticeMId = _firstLocalNoticeMId;

  [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
    NSDictionary *dic = [request.responseString safeJsonDicFromJsonString];
    NSArray *notices = [[dic safeDicObjectForKey:@"data"] safeArrayObjectForKey:@"messageList"];
    if (isFromTimer) {
      [wTimerNotices removeAllObjects];
      for (NSInteger i=0; i<notices.count; i++) {
        [wTimerNotices safeAddObject:[SWNoticeMsgItem msgItemByDic:[notices safeDicObjectAtIndex:i]]];
      }
      [wSelf dealDot];
    }else{
      wSelf.lastMsgIdNotices = [[dic safeDicObjectForKey:@"data"] safeNumberObjectForKey:@"lastMessageId"];
      wSelf.hasMoreNotices = [[[dic safeDicObjectForKey:@"data"] safeNumberObjectForKey:@"hasMore"] boolValue];
      if ([mId integerValue]==0) {
        [wSelf.notices removeAllObjects];
      }
      for (NSInteger i=0; i<notices.count; i++) {
        [wSelf.notices safeAddObject:[SWNoticeMsgItem msgItemByDic:[notices safeDicObjectAtIndex:i]]];
        
        if (i==0&&[mId integerValue]==0) {
          localNoticeMId = [[SWNoticeMsgItem msgItemByDic:[notices safeDicObjectAtIndex:i]] mId];
          [[NSUserDefaults standardUserDefaults] setSafeNumberObject:localNoticeMId forKey:@"firstLocalNoticeMId"];
          [[NSUserDefaults standardUserDefaults] synchronize];
        }
      }
      @synchronized(wTimerNotices) {
        [wTimerNotices removeAllObjects];
        [wTimerNotices addObjectsFromArray:wSelf.notices];
      }

      wSelf.isLoadingNotices = NO;
      if (wSelf.delegate && [wSelf.delegate respondsToSelector:@selector(noticeModelDidLoadNotices:)]) {
        [wSelf.delegate noticeModelDidLoadNotices:wSelf];
      }
    }
  } failure:^(YTKBaseRequest *request) {
    if (!isFromTimer) {
      if (wSelf.delegate && [wSelf.delegate respondsToSelector:@selector(noticeModelDidLoadNotices:)]) {
        [wSelf.delegate noticeModelDidLoadNotices:wSelf];
      }
    }
  }];
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

- (void)markReadMsg:(SWNoticeMsgItem *)msgItem{
  if ([msgItem.status integerValue]==0) {
    SWNoticeMarkAPI *api = [[SWNoticeMarkAPI alloc] init];
    api.messageId = msgItem.mId;
    [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
      
    } failure:^(YTKBaseRequest *request) {
      
    }];
  }
  
  NSMutableDictionary *msgReadDic = [[[NSUserDefaults standardUserDefaults] safeDicObjectForKey:@"msgReadDic"] mutableCopy];
  [msgReadDic setObject:@1 forKey:[msgItem.mId stringValue]];
  [[NSUserDefaults standardUserDefaults] setObject:msgReadDic forKey:@"msgReadDic"];
  [[NSUserDefaults standardUserDefaults] synchronize];

}

- (void)pushOpen:(BOOL)open{
  [[NSUserDefaults standardUserDefaults] setBool:!open forKey:@"isPushClosed"];
  [[NSUserDefaults standardUserDefaults] synchronize];
  
  SWPushOpenAPI *api = [[SWPushOpenAPI alloc] init];
  [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {

  } failure:^(YTKBaseRequest *request) {
    
  }];
}

- (BOOL)pushOpenStatus{
  return ![[NSUserDefaults standardUserDefaults] boolForKey:@"isPushClosed"];
}
@end