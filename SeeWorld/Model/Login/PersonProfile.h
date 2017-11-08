//
//  PersonProfile.h
//
//  Created by   on 15/8/11
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SWModel.h"


@interface PersonProfile : SWModel <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *email;
@property (nonatomic, assign) double createTime;
@property (nonatomic, assign) double gender;
@property (nonatomic, strong) NSString *jwt;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *head;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *rongToken;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
