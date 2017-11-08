//
//  SWNearbyAPI.m
//  SeeWorld
//
//  Created by Albert Lee on 9/15/15.
//  Copyright © 2015 SeeWorld. All rights reserved.
//

#import "SWNearbyAPI.h"

@implementation SWNearbyAPI
- (NSString *)requestUrl{
  return @"/feeds/nearby";
}

- (YTKRequestMethod)requestMethod {
  return YTKRequestMethodGET;
}

- (id)requestArgument{
  self.longitude = [NSNumber numberWithDouble:[SWLocationManager shared].cachedLocation.coordinate.longitude];
  self.latitude = [NSNumber numberWithDouble:[SWLocationManager shared].cachedLocation.coordinate.latitude];
  
  return @{@"jwt":[[NSUserDefaults standardUserDefaults] safeStringObjectForKey:@"jwt"],
           @"longitude":self.longitude?self.longitude:@0,
           @"latitude":self.latitude?self.latitude:@0,
           @"distance":self.distance?self.distance:@0};
}
@end
