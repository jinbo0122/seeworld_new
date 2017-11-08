//
//  SWChatSettingCell.h
//  SeeWorld
//
//  Created by Albert Lee on 1/7/16.
//  Copyright © 2016 SeeWorld. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSInteger{
  SWChatSettingSwitchTypeTop = 1,
  SWChatSettingSwitchTypeMute  = 2,
  SWChatSettingSwitchTypeAddblack = 3,
}SWChatSettingSwitchType;

@protocol SWChatSettingCellDelegate;
@interface SWChatSettingCell : UITableViewCell
@property(nonatomic, weak)id<SWChatSettingCellDelegate>delegate;
@property(nonatomic, weak)RCConversation *chat;
@property(nonatomic, weak)RCDiscussion   *discussion;
@property(nonatomic, assign)SWChatSettingSwitchType swtchType;
- (void)refreshWithIndexPath:(NSIndexPath*)indexPath cType:(RCConversationType)cType;
@end

@protocol SWChatSettingCellDelegate <NSObject>
- (void)chatSettingCellDidPressSwitch:(SWChatSettingCell *)cell isON:(BOOL)isON;
@end