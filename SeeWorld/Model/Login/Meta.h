//
//  Meta.h
//
//  Created by   on 15/8/11
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SWModel.h"


@interface Meta : SWModel <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *message;
@property (nonatomic, assign) double code;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
