//
//  SWLocationManager.m
//  pandora
//
//  Created by Albert Lee on 4/8/14.
//  Copyright (c) 2014 Albert Lee. All rights reserved.
//

#import "SWLocationManager.h"
#define SWLocationManagerMaxCacheLife (2*60)
#define PDLocationCache @"PD_LOCATION_CACHE"
#define SWLocationManagerCache @"SWLocationManagerCache"
#define PDUserDefaultsLocationServiceDisabled @"PDUserDefaultsLocationServiceDisabled"
@interface SWLocationManager ()<CLLocationManagerDelegate>{
  BOOL _isNeedReverseGeocoder;
  BOOL _isNeedGetPOI;
  NSMutableArray *_completionBlockArray;
  NSMutableArray *_authorityFailureBlockArray;
  SWLocationManagerFailureHandler _failureHandler;
}

@end
@implementation SWLocationManager
+ (SWLocationManager *) shared {
  static dispatch_once_t pred;
  static SWLocationManager *shared = nil;
  
  dispatch_once(&pred, ^{
    shared = [[SWLocationManager alloc] init];
  });
  return shared;
}

- (id)init{
  self = [super init];
  if (self) {
    self.maxCacheAge = SWLocationManagerMaxCacheLife;
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    self.locationManager.delegate = self;
    
    self.isLocationDisabled = [[[NSUserDefaults standardUserDefaults] safeNumberObjectForKey:PDUserDefaultsLocationServiceDisabled] boolValue];
    _completionBlockArray = [NSMutableArray array];
    _authorityFailureBlockArray = [NSMutableArray array];
  }
  return self;
}

- (NSTimeInterval) cachedLocationAge {
  if (self.cachedLocation == nil)
    return NSUIntegerMax;
  return [[NSDate dateWithTimeIntervalSince1970:[NSDate currentTime]] timeIntervalSinceDate:self.cachedLocation.timestamp];
}

+ (void)checkLocation{
  [[SWLocationManager shared] obtainCurrentLocationAndReverse:YES
                                                    isNeedPOI:NO
                                            completitionBlock:^(CLLocation *location, CLPlacemark *placemark, NSError *error) {
                                              
                                              [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO]
                                                                                        forKey:PDUserDefaultsLocationServiceDisabled];
                                              [[NSUserDefaults standardUserDefaults] synchronize];
                                            }
                                                 failureBlock:^{
                                                   
                                                 }
                                        authorityFailureBlock:^{
                                          [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES]
                                                                                    forKey:PDUserDefaultsLocationServiceDisabled];
                                          [[NSUserDefaults standardUserDefaults] synchronize];
                                        }];
}

+ (NSDictionary *)locationJsonDic:(CLLocation *)location placemark:(CLPlacemark*)placemark{
  NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:placemark.addressDictionary];
  [dic addEntriesFromDictionary:@{@"horizontalAccuracy":[NSNumber numberWithDouble:location.horizontalAccuracy],
                                  @"verticalAccuracy":[NSNumber numberWithDouble:location.verticalAccuracy],
                                  @"speed":[NSNumber numberWithDouble:location.speed],
                                  @"course":[NSNumber numberWithDouble:location.course]}];
  
  return [NSDictionary dictionaryWithDictionary:dic];
}


- (void) obtainCurrentLocationAndReverse:(BOOL) isNeedReverseGeocoder
                               isNeedPOI:(BOOL) isNeedPOI
                       completitionBlock:(SWLocationManagerCompletionHandler) completitionBlock
                            failureBlock:(SWLocationManagerFailureHandler) failureBlock
                   authorityFailureBlock:(SWLocationManagerAuthorityFailureHandler) authorityFailureBlock{
  
  _isNeedGetPOI = isNeedPOI;
  
  if (self.cachedLocationAge<self.maxCacheAge && self.isLocationDisabled ==NO) {
    if (self.cachedLocation && self.cachedPlaceMark) {
      if (completitionBlock) {
        completitionBlock(self.cachedLocation,self.cachedPlaceMark,nil);
        return;
      }
    }
  }
  if (isRunningOnIOS8) {
    [self.locationManager requestWhenInUseAuthorization];
  }
  [self.locationManager startUpdatingLocation];
  _isNeedReverseGeocoder  = isNeedReverseGeocoder;
  if (completitionBlock) {
    [_completionBlockArray addObject:completitionBlock];
  }
  _failureHandler = failureBlock;
  [_authorityFailureBlockArray addObject:authorityFailureBlock];
}

#pragma mark CLLocationManger Delegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
  self.cachedLocation = [locations safeObjectAtIndex:0];

  self.isLocationDisabled = NO;
  [self.locationManager stopUpdatingLocation];
  if (!_isNeedReverseGeocoder) {
    for (SWLocationManagerCompletionHandler block in _completionBlockArray) {
      if (block) {
        block(self.cachedLocation,nil,nil);
      }
    }
    [_completionBlockArray removeAllObjects];
  }
  else{
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:self.cachedLocation
                   completionHandler:^(NSArray *placemarks, NSError *error){
                     if (!error) {
                       self.cachedPlaceMark = [placemarks safeObjectAtIndex:0];
                       for (SWLocationManagerCompletionHandler block in _completionBlockArray) {
                         if (block) {
                           block(self.cachedLocation,self.cachedPlaceMark,nil);
                         }
                       }
                       [_completionBlockArray removeAllObjects];
                     }
                   }];
  }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
  [self.locationManager stopUpdatingLocation];
  CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
  if (status==kCLAuthorizationStatusDenied){
    self.isLocationDisabled = YES;
    for (SWLocationManagerAuthorityFailureHandler block in _authorityFailureBlockArray) {
      if (block) {
        block();
      }
    }
    [_authorityFailureBlockArray removeAllObjects];
  }
  else{
    self.isLocationDisabled = NO;
  }
}
@end
