//
//  TuSDKICViewController+Ext.m
//  SeeWorld
//
//  Created by liufz on 15/9/12.
//  Copyright (c) 2015年 SeeWorld. All rights reserved.
//

#import "TuSDKICViewController+Ext.h"
#import <objc/runtime.h>

@implementation TuSDKICViewController(Ext)
+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        {
            Method originMethod = class_getInstanceMethod([self class], @selector(showHubSuccessWithStatus:));
            Method swizzledMethod = class_getInstanceMethod([self class], @selector(swizzling_showHubSuccessWithStatus:));
            method_exchangeImplementations(originMethod, swizzledMethod);
        }
    });
}

- (void)swizzling_showHubSuccessWithStatus:(NSString *)status
{
    [self dismissHub];
    return;
}
@end
