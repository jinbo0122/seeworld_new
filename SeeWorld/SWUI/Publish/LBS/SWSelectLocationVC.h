//
//  SWSelectLocationVC.h
//  SeeWorld
//
//  Created by Albert Lee on 17/11/2017.
//  Copyright © 2017 SeeWorld. All rights reserved.
//

#import "ALBaseVC.h"
@protocol SWSelectLocationVCDelegate;
@interface SWSelectLocationVC : ALBaseVC
@property(nonatomic,weak)id<SWSelectLocationVCDelegate>delegate;
@end


@protocol SWSelectLocationVCDelegate<NSObject>
- (void)selectLocationVCDidReturnWithLocation:(CLLocation *)location placemark:(NSString *)placemark;
@end
