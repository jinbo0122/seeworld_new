//
//  SWUtility.m
//  SeeWorld
//
//  Created by Albert Lee on 1/4/16.
//  Copyright © 2016 SeeWorld. All rights reserved.
//

#import "SWUtility.h"
#import "AppDelegate.h"
#define SWTagWindowSubview 100000
@implementation SWUtility
+ (void)removeWindowSubview{
  for (UIView *view in [UIApplication sharedApplication].delegate.window.subviews) {
    if (view.tag==SWTagWindowSubview) {
      [view removeFromSuperview];
    }
  }
}

+ (void)addWindowSubview:(UIView *)view{
  view.tag = SWTagWindowSubview;
  AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
  [appDelegate.window addSubview:view];
}

+ (BOOL)isViewOnMainWindow:(UIView *)view{
  for (UIView *subview in [UIApplication sharedApplication].delegate.window.subviews) {
    if ([subview isEqual:view]) {
      return YES;
    }
  }
  return NO;
}

+ (UIView *)isViewOfClassOnMainView:(__unsafe_unretained Class)className{
  for (UIView *subview in [UIApplication sharedApplication].delegate.window.subviews) {
    if ([subview isKindOfClass:className]) {
      return subview;
    }
  }
  return nil;
}
@end
