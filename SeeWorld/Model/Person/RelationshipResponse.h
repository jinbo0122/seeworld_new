//
//  RelationshipResponse.h
//
//  Created by fazheng liu on 15/10/11
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SWModel.h"

@class CommonMeta;

@interface RelationshipResponse :SWModel <NSCoding, NSCopying>

@property (nonatomic, strong) CommonMeta *meta;
@property (nonatomic, strong) NSArray *data;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
