//
//  CommonResponse.h
//
//  Created by   on 15/8/11
//  Copyright (c) 2015 __MyCompanyName__
//

#import <Foundation/Foundation.h>
#import "SWModel.h"

@class CommonMeta;

@interface CommonResponse : SWModel <NSCoding, NSCopying>

@property (nonatomic, strong) CommonMeta *meta;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
