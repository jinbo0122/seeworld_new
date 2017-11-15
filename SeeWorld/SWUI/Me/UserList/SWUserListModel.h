//
//  SWUserListModel.h
//  SeeWorld
//
//  Created by Albert Lee on 15/11/2017.
//  Copyright © 2017 SeeWorld. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, SWUserListAPIType){
  SWUserListAPITypeGetFollowing,
  SWUserListAPITypeGetFollower,
  SWUserListAPITypeGetRecommand,
};

@protocol SWUserListModelDelegate;
@interface SWUserListModel : NSObject
@property(nonatomic,   weak)id<SWUserListModelDelegate>delegate;
@property(nonatomic, strong)NSString *uId;
@property(nonatomic, assign)SWUserListAPIType type;
@property(nonatomic, strong)NSString *title;
@property(nonatomic, strong)NSMutableArray *users;
@property(nonatomic, assign)BOOL isLoading;
- (void)getUsers;
@end


@protocol SWUserListModelDelegate<NSObject>
- (void)userListModelDidLoadUsers:(SWUserListModel *)model;
- (void)userListModelDidFailLoadUsers:(SWUserListModel *)model;
@end
