//
//  SWAddTagViewVC.h
//  SeeWorld
//
//  Created by liufz on 15/9/12.
//  Copyright (c) 2015年 SeeWorld. All rights reserved.
//

#import "SWBaseViewController.h"
@protocol SWAddTagViewVCDelegate;
@interface SWAddTagViewVC : SWBaseViewController
@property (nonatomic,strong)UIImage *photoImage;
@property (nonatomic,  weak)id<SWAddTagViewVCDelegate>delegate;
@property (nonatomic,strong)NSMutableArray *addedTags;
@end


@protocol SWAddTagViewVCDelegate<NSObject>
- (void)addTagViewVCDidReturnTags:(NSArray *)tags;
@end
