//
//  SWChatSettingVC.h
//  SeeWorld
//
//  Created by Albert Lee on 1/7/16.
//  Copyright © 2016 SeeWorld. All rights reserved.
//

#import "ALBaseVC.h"

@interface SWChatSettingVC : ALBaseVC
@property(nonatomic, assign)RCConversationType cType;
@property(nonatomic, strong)NSString           *targetId;
@property(nonatomic, strong)NSMutableArray     *userIds;
@property(nonatomic, weak)NSMutableArray *messages;
@end
