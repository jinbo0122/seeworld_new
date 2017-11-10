//
//  SWHomeHeaderView.h
//  SeeWorld
//
//  Created by Albert Lee on 10/11/2017.
//  Copyright © 2017 SeeWorld. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SWHomeHeaderViewDelegate;
@interface SWHomeHeaderView : UIView
@property(nonatomic,  weak)id<SWHomeHeaderViewDelegate>delegate;
@end


@protocol SWHomeHeaderViewDelegate<NSObject>
- (void)homeHeaderViewDidPressPost:(SWHomeHeaderView *)headerView;
- (void)homeHeaderViewDidPressCamera:(SWHomeHeaderView *)headerView;
- (void)homeHeaderViewDidPressAlbum:(SWHomeHeaderView *)headerView;
- (void)homeHeaderViewDidPressLBS:(SWHomeHeaderView *)headerView;
@end
