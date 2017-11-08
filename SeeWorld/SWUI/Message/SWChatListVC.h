//
//  SWChatListVC.h
//  SeeWorld
//
//  Created by Albert Lee on 12/22/15.
//  Copyright © 2015 SeeWorld. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>
@protocol SWChatListVCDelegate;
@interface SWChatListVC : RCConversationListViewController
@property(nonatomic, weak)id<SWChatListVCDelegate>delegate;
- (void)reloadChats;
@end

@protocol SWChatListVCDelegate <NSObject>

- (void)chatListDidPressWithVC:(UIViewController *)vc;

@end