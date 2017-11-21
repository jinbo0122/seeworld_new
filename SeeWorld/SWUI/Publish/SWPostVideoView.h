//
//  SWPostVideoView.h
//  SeeWorld
//
//  Created by Albert Lee on 21/11/2017.
//  Copyright © 2017 SeeWorld. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol SWPostVideoViewDelegate;
@interface SWPostVideoView : UIButton
@property(nonatomic, weak)id<SWPostVideoViewDelegate>delegate;
- (void)refreshWithThumb:(UIImage *)thumbImage;
@end

@protocol SWPostVideoViewDelegate<NSObject>
- (void)postVideoViewDidPressPlay:(SWPostVideoView *)videoView;
@end
