//
//  SWSearchModel.h
//  SeeWorld
//
//  Created by Albert Lee on 9/9/15.
//  Copyright (c) 2015 SeeWorld. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol SWSearchModelDelegate;
@interface SWSearchModel : NSObject

@property(nonatomic,   weak)id<SWSearchModelDelegate>delegate;
@property(nonatomic, strong)NSMutableArray *users;
@property(nonatomic, strong)NSMutableArray *tags;
@property(nonatomic, assign)NSInteger currentIndex;

- (void)searchUserByName:(NSString *)name;
- (void)searchTag:(NSString *)tag;

- (void)processFollow:(SWFeedLikeItem *)likeItem;
@end

@protocol SWSearchModelDelegate <NSObject>

- (void)searchFriendDidReturnResults:(SWSearchModel *)model string:(NSString *)string;
- (void)searchTagDidReturnResults:(SWSearchModel *)model tag:(NSString *)tag;

@end