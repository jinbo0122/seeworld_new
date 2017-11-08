//
//  SWSearchFriendModel.h
//  SeeWorld
//
//  Created by Albert Lee on 9/2/15.
//  Copyright (c) 2015 SeeWorld. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol SWSearchFriendModelDelegate;
@interface SWSearchFriendModel : NSObject

@property(nonatomic,   weak)id<SWSearchFriendModelDelegate>delegate;
@property(nonatomic, strong)NSMutableArray *users;

- (void)searchUserByName:(NSString *)name;
- (void)processFollow:(SWFeedLikeItem *)likeItem;
@end

@protocol SWSearchFriendModelDelegate <NSObject>

- (void)searchFriendDidReturnResults:(SWSearchFriendModel *)model string:(NSString *)string;

@end