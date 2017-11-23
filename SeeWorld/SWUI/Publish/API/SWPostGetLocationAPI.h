//
//  SWPostGetLocationAPI.h
//  SeeWorld
//
//  Created by Albert Lee on 23/11/2017.
//  Copyright © 2017 SeeWorld. All rights reserved.
//

#import "SWRequestApi.h"

@interface SWPostGetLocationAPI : SWRequestApi
@property(nonatomic, assign)CGFloat longitude;
@property(nonatomic, assign)CGFloat latitude;
@end
