//
//  SWSelectContactVC.h
//  SeeWorld
//
//  Created by Albert Lee on 1/5/16.
//  Copyright © 2016 SeeWorld. All rights reserved.
//

#import "ALBaseVC.h"

@interface SWSelectContactVC : ALBaseVC
@property(nonatomic, strong)NSArray *userIds;
@property(nonatomic, assign)BOOL isFromAdd;
@property(nonatomic, strong)NSString *discussionId;
@property(nonatomic, strong)NSString *singleChatName;
@end
