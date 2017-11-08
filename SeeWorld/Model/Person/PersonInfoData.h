//
//  PersonInfoData.h
//
//  Created by liufz  on 15/9/18
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SWModel.h"


@interface PersonInfoData : SWModel <NSCoding, NSCopying>

@property (nonatomic, assign) double gender;
@property (nonatomic, assign) double feedCount;
@property (nonatomic, assign) double followerCount;
@property (nonatomic, assign) double dataIdentifier;
@property (nonatomic, strong) NSString *head;
@property (nonatomic, assign) double relation;
@property (nonatomic, strong) NSString *dataDescription;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) double followedCount;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
