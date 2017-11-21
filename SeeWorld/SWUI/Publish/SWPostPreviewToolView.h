//
//  SWPostPreviewToolView.h
//  SeeWorld
//
//  Created by Albert Lee on 21/11/2017.
//  Copyright © 2017 SeeWorld. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCFilter.h"
@protocol SWPostPreviewToolViewDelegate;
@interface SWPostPreviewToolView : UIView
@property(nonatomic, strong)UIButton  *btnEdit;
@property(nonatomic, strong)UIButton  *btnFilter;
@property(nonatomic, strong)UIButton  *btnOkay;
@property(nonatomic,   weak)id<SWPostPreviewToolViewDelegate>delegate;

@end


@protocol SWPostPreviewToolViewDelegate<NSObject>
- (void)postPreviewDidUseFilter:(SCFilter *)filter;
@end
