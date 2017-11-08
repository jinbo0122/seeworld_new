//
//  SWFeedCommentView.h
//  SeeWorld
//
//  Created by Albert Lee on 6/6/16.
//  Copyright © 2016 SeeWorld. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWFeedItem.h"
@protocol SWFeedCommentViewDelegate;
@interface SWFeedCommentView : UIView
@property(nonatomic,   weak)id<SWFeedCommentViewDelegate>delegate;
@property(nonatomic, strong)UITapGestureRecognizer  *tapGesture;
- (void)refreshWithFeedComments:(NSArray *)comments;
+ (CGFloat)heightByFeedComments:(NSArray *)comments;
@end

@protocol SWFeedCommentViewDelegate <NSObject>
- (void)feedCommentViewDidPressUser:(SWFeedUserItem *)userItem;
- (void)feedCommentViewDidPressUrl:(NSURL *)url;
@end
