//
//  SWContactModel.m
//  SeeWorld
//
//  Created by Albert Lee on 1/5/16.
//  Copyright © 2016 SeeWorld. All rights reserved.
//

#import "SWContactModel.h"
#import "SWContactAPI.h"
@implementation SWContactModel
- (id)init{
  if (self = [super init]) {
    _selectedContacts  = [NSMutableArray array];
    _contacts = [NSMutableArray array];
    _searchedContacts = [NSMutableArray array];
  }
  return self;
}

- (void)getContacts{
  SWContactAPI *api = [[SWContactAPI alloc] init];
  __weak typeof(self)wSelf = self;
  [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
    NSDictionary *dic = [request.responseString safeJsonDicFromJsonString];
    NSArray *users = [dic safeArrayObjectForKey:@"data"];
    [wSelf.contacts removeAllObjects];
    for (NSDictionary *user in users) {
      [wSelf.contacts safeAddObject:[SWFeedUserItem feedUserItemByDic:user]];
    }
    
    if (wSelf.delegate && [wSelf.delegate respondsToSelector:@selector(contactModelDidLoadContacts:)]) {
      [wSelf.delegate contactModelDidLoadContacts:wSelf];
    }
  } failure:^(YTKBaseRequest *request) {
    if (wSelf.delegate && [wSelf.delegate respondsToSelector:@selector(contactModelDidLoadContacts:)]) {
      [wSelf.delegate contactModelDidLoadContacts:wSelf];
    }
  }];
}

- (void)dealUser:(SWFeedUserItem *)item{
  BOOL isSelected = NO;
  for (NSInteger i=0;i<self.selectedContacts.count;i++) {
    SWFeedUserItem *user = [self.selectedContacts safeObjectAtIndex:i];
    if ([user.uId isEqualToNumber:item.uId]) {
      [self.selectedContacts safeRemoveObjectAtIndex:i];
      isSelected = YES;
      break;
    }
  }
  
  if (!isSelected) {
    [self.selectedContacts safeAddObject:[item copy]];
  }
}

- (void)searchUser:(NSString *)text{
  [_searchedContacts removeAllObjects];
  for (SWFeedUserItem *user in self.contacts) {
    if ([user.name rangeOfString:text options:NSCaseInsensitiveSearch].location!=NSNotFound) {
      [_searchedContacts addObject:[user copy]];
    }
  }
  if (self.delegate && [self.delegate respondsToSelector:@selector(contactModelDidSearchContacts:)]) {
    [self.delegate contactModelDidSearchContacts:self];
  }
}
@end
