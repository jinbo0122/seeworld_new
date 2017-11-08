//
//  Meta.h
//
//  Created by   on 15/8/11
//  Copyright (c) 2015 __MyCompanyName__
//

#import <Foundation/Foundation.h>
#import "SWModel.h"



@interface CommonMeta : SWModel <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *message;
@property (nonatomic, assign) double code;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
