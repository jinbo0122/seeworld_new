//
//  NSDate+ALExtension.m
//  ALExtension
//
//  Created by Albert Lee on 4/7/15.
//  Copyright (c) 2015 Albert Lee. All rights reserved.
//

#import "NSDate+ALExtension.h"
#import "NSUserDefaults+ALExtension.h"
@implementation NSDate (ALExtension)
+ (NSTimeInterval)currentTime{
  NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970]+
  [[[NSUserDefaults standardUserDefaults] safeNumberObjectForKey:ALUserDefaultsServerTimeDiffWithLocalTime] doubleValue];
  return currentTime;
}
@end
