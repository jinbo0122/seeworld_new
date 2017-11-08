//
//  LoginResponse.h
//
//  Created by   on 15/8/11
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SWModel.h"
@class CommonMeta, PersonProfile;

@interface LoginResponse : SWModel <NSCoding, NSCopying>

@property (nonatomic, strong) CommonMeta *meta;
@property (nonatomic, strong) PersonProfile *data;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
