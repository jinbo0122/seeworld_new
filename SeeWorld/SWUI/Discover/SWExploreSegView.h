//
//  SWExploreSegView.h
//  SeeWorld
//
//  Created by Albert Lee on 6/5/16.
//  Copyright © 2016 SeeWorld. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SWExploreSegViewDelegate;
@interface SWExploreSegView : UIView
@property(nonatomic,   weak)id<SWExploreSegViewDelegate>delegate;
@property(nonatomic, assign)NSInteger selectedIndex;
@property(nonatomic, strong)UIButton  *btnLeft;
@property(nonatomic, strong)UIButton  *btnRight;
@property(nonatomic, strong)UIView    *slider;
- (id)initWithFrame:(CGRect)frame items:(NSArray *)items images:(NSArray *)images;
@end

@protocol SWExploreSegViewDelegate <NSObject>

- (void)feedInteractNavViewDidSelectIndex:(NSInteger)index;

@end