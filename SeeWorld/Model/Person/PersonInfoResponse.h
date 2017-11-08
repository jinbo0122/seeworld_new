//
//  PersonInfoResponse.h
//
//  Created by liufz  on 15/9/18
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SWModel.h"

@class CommonMeta, PersonInfoData;

@interface PersonInfoResponse : SWModel <NSCoding, NSCopying>

@property (nonatomic, strong) CommonMeta *meta;
@property (nonatomic, strong) PersonInfoData *data;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
