//
//  SWNoticeCell.h
//  SeeWorld
//
//  Created by Albert Lee on 9/25/15.
//  Copyright © 2015 SeeWorld. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSInteger{
  SWNoticeTypeComment = 1,
  SWNoticeTypeLike  = 2,
  SWNoticeTypeFollow = 4,
}SWNoticeType;

@protocol SWNoticeCellDelegate;
@interface SWNoticeCell : UITableViewCell
@property(nonatomic, weak)id<SWNoticeCellDelegate>delegate;
- (void)refreshNotice:(SWNoticeMsgItem *)msgItem;
- (void)hideDot;
+ (CGFloat)heightOfNotice:(SWNoticeMsgItem *)msgItem;
@end

@protocol SWNoticeCellDelegate <NSObject>
@optional
- (void)noticeCellDidPressFollow:(SWNoticeMsgItem *)msgItem;
- (void)noticeCellDidPressFeed:(SWNoticeMsgItem *)msgItem;
- (void)noticeCellDidPressAvatar:(SWNoticeMsgItem *)msgItem;
@end