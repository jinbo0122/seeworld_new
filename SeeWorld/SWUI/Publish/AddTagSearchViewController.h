//
//  AddTagSearchViewController.h
//  SeeWorld
//
//  Created by liufz on 15/9/12.
//  Copyright (c) 2015年 SeeWorld. All rights reserved.
//

#import "SWBaseViewController.h"

@interface AddTagSearchViewController : SWBaseViewController
@property (nonatomic, copy) void (^endInputTitleHandler)(NSString *inputTitle);
@end
