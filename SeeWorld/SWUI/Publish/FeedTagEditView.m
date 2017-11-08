//
//  FeedTagEditView.m
//  SeeWorld
//
//  Created by liufz on 15/9/14.
//  Copyright (c) 2015年 SeeWorld. All rights reserved.
//

#import "FeedTagEditView.h"

@implementation FeedTagEditView
- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UIPanGestureRecognizer *dragTip = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        [self addGestureRecognizer:dragTip];
    }
    return self;
}

-(void)handlePan:(UIPanGestureRecognizer *) recognizer {
    CGPoint translation = [recognizer translationInView:self.superview];
    self.center = CGPointMake(self.center.x + translation.x, self.center.y + translation.y);
    [recognizer setTranslation:CGPointZero inView:self.superview];
}
@end
