//
//  SWPostEnterView.h
//  SeeWorld
//
//  Created by Albert Lee on 5/19/15.
//  Copyright (c) 2015 SeeWorld. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SWPostEnterViewDelegate;
@interface SWPostEnterView : UIView
@property(nonatomic, weak)id<SWPostEnterViewDelegate>delegate;
@property(nonatomic, assign)BOOL isNeedPhoto;
@property(nonatomic, assign)BOOL isNeedChat;
+ (void)showWithDelegate:(id<SWPostEnterViewDelegate>)delegate;
@end


@protocol SWPostEnterViewDelegate <NSObject>
- (void)postEnterViewDidReturnAction:(SWPostEnterView *)view;
@end