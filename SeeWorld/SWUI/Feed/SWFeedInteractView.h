//
//  SWFeedInteractView.h
//  SeeWorld
//
//  Created by Albert Lee on 9/1/15.
//  Copyright (c) 2015 SeeWorld. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWFeedItem.h"
@interface SWFeedInteractButton : UIButton
- (void)setImageName:(NSString *)imageName title:(NSString *)title num:(NSInteger)num;
@end

@interface SWFeedInteractView : UIView
@property(nonatomic, strong)SWFeedInteractButton    *btnReply;
@property(nonatomic, strong)SWFeedInteractButton    *btnLike;
@property(nonatomic, strong)SWFeedInteractButton    *btnShare;
- (void)refreshWithFeed:(SWFeedItem *)feedItem;
@end