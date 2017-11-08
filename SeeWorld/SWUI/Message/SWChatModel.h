//
//  SWChatModel.h
//  SeeWorld
//
//  Created by Albert Lee on 12/22/15.
//  Copyright © 2015 SeeWorld. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SWChatModelDelegate;
@interface SWChatModel : NSObject
@property(nonatomic, weak  )id<SWChatModelDelegate>delegate;
@property(nonatomic, strong)NSMutableArray *chats;
+ (SWChatModel *)sharedInstance;
- (void)connect;
- (void)getChats;
- (void)saveUser:(NSString*)uId name:(NSString*)name picUrl:(NSString *)picUrl;
- (void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *))completion;
@end

@protocol SWChatModelDelegate <NSObject>
- (void)chatModelDidLoadChats:(SWChatModel *)model;
@end