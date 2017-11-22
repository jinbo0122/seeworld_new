//
//  SWUtility.h
//  SeeWorld
//
//  Created by Albert Lee on 1/4/16.
//  Copyright © 2016 SeeWorld. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SWUtility : NSObject
+ (void)removeWindowSubview;
+ (void)addWindowSubview:(UIView *)view;
+ (BOOL)isViewOnMainWindow:(UIView *)view;
+ (UIView *)isViewOfClassOnMainView:(__unsafe_unretained Class)className;
+ (BOOL)checkCameraWithBlock:(COMPLETION_BLOCK)block;
+ (void)checkMicWithBlock:(COMPLETION_BLOCK)block;
@end
