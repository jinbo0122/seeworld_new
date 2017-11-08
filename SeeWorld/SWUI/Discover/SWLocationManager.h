//
//  SWLocationManager.h
//  pandora
//
//  Created by Albert Lee on 4/8/14.
//  Copyright (c) 2014 Albert Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^SWLocationManagerCompletionHandler)(CLLocation *location, CLPlacemark *placemark, NSError *error);
typedef void(^SWLocationManagerFailureHandler)(void);
typedef void(^SWLocationManagerAuthorityFailureHandler)(void);
@interface SWLocationManager : NSObject
@property (nonatomic,strong)    CLLocation*             cachedLocation;         // Globally cached location (the most accurate one)
@property (nonatomic,strong)    CLPlacemark*            cachedPlaceMark;
@property (nonatomic,readonly)  NSTimeInterval          cachedLocationAge;      // Age of cached location from now (in seconds)
@property (nonatomic,assign)    NSTimeInterval          maxCacheAge;
@property (nonatomic,strong)    CLLocationManager*      locationManager;
@property (nonatomic,assign)    BOOL                    isLocationDisabled;
+ (SWLocationManager *)shared;
+ (void)checkLocation;
+ (NSDictionary *)locationJsonDic:(CLLocation *)location placemark:(CLPlacemark*)placemark;
- (void) obtainCurrentLocationAndReverse:(BOOL)isNeedReverseGeocoder
                               isNeedPOI:(BOOL) isNeedPOI
                       completitionBlock:(SWLocationManagerCompletionHandler) completitionBlock
                            failureBlock:(SWLocationManagerFailureHandler) failureBlock
                   authorityFailureBlock:(SWLocationManagerAuthorityFailureHandler) authorityFailureBlock;
@end
