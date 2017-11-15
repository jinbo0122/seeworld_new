//
//  SWChatSettingCell.m
//  SeeWorld
//
//  Created by Albert Lee on 1/7/16.
//  Copyright © 2016 SeeWorld. All rights reserved.
//

#import "SWChatSettingCell.h"

@implementation SWChatSettingCell{
  UIImageView *_arrow;
  UILabel     *_title;
  UISwitch    *_switch;
  UILabel     *_discussionName;
  UIView      *_dot;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
  if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    self.contentView.backgroundColor = [UIColor colorWithRGBHex:0xffffff];
    _title = [UILabel initWithFrame:CGRectMake(15, 0, 150, self.contentView.height)
                            bgColor:[UIColor clearColor]
                          textColor:[UIColor colorWithRGBHex:0x191D28]
                               text:@""
                      textAlignment:NSTextAlignmentLeft
                               font:[UIFont systemFontOfSize:16]];
    [self.contentView addSubview:_title];
    _discussionName = [UILabel initWithFrame:CGRectMake(90, 0, UIScreenWidth-44-90, self.contentView.height)
                                     bgColor:[UIColor clearColor]
                                   textColor:[UIColor colorWithRGBHex:0xfbfcfc]
                                        text:@""
                               textAlignment:NSTextAlignmentRight
                                        font:[UIFont systemFontOfSize:17]];
    [self.contentView addSubview:_discussionName];
    
    _arrow = [[UIImageView alloc] initWithFrame:CGRectMake(UIScreenWidth-24, 16, 8, 13)];
    _arrow.image = [UIImage imageNamed:@"chat_stting_btn_next"];
    [self.contentView addSubview:_arrow];
    
    _switch = [[UISwitch alloc] initWithFrame:CGRectMake(UIScreenWidth-66, 7, 51, 31)];
    [self.contentView addSubview:_switch];
    [_switch addTarget:self action:@selector(onSwitchChanged) forControlEvents:UIControlEventValueChanged];
  }
  return self;
}
- (void)awakeFromNib {
  [super awakeFromNib];
}

- (UIEdgeInsets)layoutMargins{
  return UIEdgeInsetsZero;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
}

- (void)refreshWithIndexPath:(NSIndexPath *)indexPath cType:(RCConversationType)cType{
  _arrow.hidden = NO;
  _switch.hidden = NO;
  _discussionName.hidden = YES;
  if (cType == ConversationType_PRIVATE) {
    if (indexPath.section==0) {
      if (indexPath.row==0) {
        _title.text = SWStringTopChat;
        _arrow.hidden = YES;
        _switch.on = self.chat.isTop?1:0;
        self.swtchType = SWChatSettingSwitchTypeTop;
      }else{
        _title.text = SWStringQuietChat;
        _arrow.hidden = YES;
        __weak typeof(_switch)wSwitch = _switch;
        [[RCIMClient sharedRCIMClient]
         getConversationNotificationStatus:cType
         targetId:self.chat.targetId
         success:^(RCConversationNotificationStatus nStatus) {
           dispatch_async(dispatch_get_main_queue(), ^{
             wSwitch.on = nStatus==DO_NOT_DISTURB?1:0;
           });
         } error:^(RCErrorCode status) {
           
         }];
        self.swtchType = SWChatSettingSwitchTypeMute;
      }
    }else if (indexPath.section==1){
      if (indexPath.row==0) {
        _title.text = SWStringAddBlackList;
        _arrow.hidden = YES;
        self.swtchType = SWChatSettingSwitchTypeAddblack;
        __weak typeof(_switch)wSwitch = _switch;
        [[RCIMClient sharedRCIMClient]
         getBlacklistStatus:self.chat.targetId
         success:^(int bizStatus) {
           dispatch_async(dispatch_get_main_queue(), ^{
             wSwitch.on = bizStatus==0?1:0;
           });
         } error:^(RCErrorCode status) {
           
         }];
      }else{
        _title.text = SWStringReport;
        _switch.hidden = YES;
      }
    }else{
      _title.text = SWStringClearMsgs;
      _switch.hidden = YES;
    }
  }else{
    if (indexPath.section==0) {
      if (indexPath.row==0) {
        _title.text = SWStringDiscussionName;
        _discussionName.text = self.discussion.discussionName;
        _discussionName.hidden = NO;
        _switch.hidden = YES;
      }else if (indexPath.row==1) {
        _title.text = SWStringTopChat;
        _arrow.hidden = YES;
        _switch.on = self.chat.isTop?1:0;
        self.swtchType = SWChatSettingSwitchTypeTop;
      }else{
        _title.text = SWStringQuietChat;
        _arrow.hidden = YES;
        self.swtchType = SWChatSettingSwitchTypeMute;
        __weak typeof(_switch)wSwitch = _switch;
        [[RCIMClient sharedRCIMClient]
         getConversationNotificationStatus:cType
         targetId:self.chat.targetId
         success:^(RCConversationNotificationStatus nStatus) {
           dispatch_async(dispatch_get_main_queue(), ^{
             wSwitch.on = nStatus==DO_NOT_DISTURB?1:0;
           });
         } error:^(RCErrorCode status) {
           
         }];
      }
    }else if (indexPath.section==1){
      _title.text = SWStringReport;
      _switch.hidden = YES;
    }else{
      _title.text = SWStringClearMsgs;
      _switch.hidden = YES;
    }
  }
}

- (void)onSwitchChanged{
  if (self.delegate && [self.delegate respondsToSelector:@selector(chatSettingCellDidPressSwitch:isON:)]) {
    [self.delegate chatSettingCellDidPressSwitch:self isON:_switch.on];
  }
}
@end
