//
//  SWNoticeMsgItem.h
//  SeeWorld
//
//  Created by Albert Lee on 9/25/15.
//  Copyright © 2015 SeeWorld. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SWNoticeMsgItem : NSObject
@property (nonatomic, strong)SWFeedInfoItem *feed;
@property (nonatomic, strong)SWFeedUserItem *user;
@property (nonatomic, strong)NSNumber       *time;
@property (nonatomic, strong)NSNumber       *mType;
@property (nonatomic, strong)NSNumber       *status;
@property (nonatomic, strong)NSNumber       *mId;
@property (nonatomic, strong)NSString       *comment;
@property (nonatomic, strong)NSDictionary   *noticeDic;
+ (SWNoticeMsgItem *)msgItemByDic:(NSDictionary *)feedDic;
@end
