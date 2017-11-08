//
//  SWFeedTagButton.h
//  SeeWorld
//
//  Created by Albert Lee on 9/1/15.
//  Copyright (c) 2015 SeeWorld. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWFeedItem.h"
@interface SWFeedTagButton : UIButton
@property(nonatomic, strong)SWFeedTagItem *tagObject;
@property(nonatomic, strong)UIImageView   *tagNameImageView;
@property(nonatomic, strong)UILabel       *lblBrandName;
@property(nonatomic, strong)NSTimer       *animationTimer;
@property(nonatomic, strong)UIImageView   *whitePoint;
@property(nonatomic, assign)CGFloat       limitPicWidth;
@property(nonatomic, strong)UIImageView   *tagHoverImageView;
@property(nonatomic, strong)UIImageView   *tagHoverImageView2;//为了动画用
- (void)refreshUI;
- (void)reverseTag;
@end
