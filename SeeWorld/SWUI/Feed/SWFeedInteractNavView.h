//
//  SWFeedInteractNavView.h
//  SeeWorld
//
//  Created by Albert Lee on 9/2/15.
//  Copyright (c) 2015 SeeWorld. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SWFeedInteractNavViewDelegate;
@interface SWFeedInteractNavView : UIView
@property(nonatomic,   weak)id<SWFeedInteractNavViewDelegate>delegate;
@property(nonatomic, assign)NSInteger selectedIndex;
@property(nonatomic, strong)UIButton  *btnLeft;
@property(nonatomic, strong)UIButton  *btnRight;
@property(nonatomic, strong)UIImageView   *slider;

- (id)initWithFrame:(CGRect)frame items:(NSArray *)items;
- (void)setSliderImage:(NSString *)imageName;
@end

@protocol SWFeedInteractNavViewDelegate <NSObject>

- (void)feedInteractNavViewDidSelectIndex:(NSInteger)index;

@end