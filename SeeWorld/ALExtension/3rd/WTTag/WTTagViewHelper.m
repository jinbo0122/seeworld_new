//
//  WTTagViewHelper.m
//  WTTagView
//
//  Created by wtlucky on 7/25/15.
//  Copyright (c) 2015 wtlucky. All rights reserved.
//

#import "WTTagViewHelper.h"

@implementation WTTagViewHelper

+ (BOOL)osVersionIsiOS8 {
    static int systemMajorVersion = 0;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString* version = [[UIDevice currentDevice] systemVersion];
        systemMajorVersion = [[version componentsSeparatedByString:@"."][0] intValue];
    });
    return systemMajorVersion >= 8;
}

+ (NSString *)tagIconName {
    return @"index_tag";
}

+ (NSString *)tagLeftBgImageName {
    return @"tag_btn_black";
}

+ (NSString *)tagRightBgImageName {
    return @"tag_btn_black0";
}

@end
