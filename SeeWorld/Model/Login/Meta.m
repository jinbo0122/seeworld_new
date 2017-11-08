//
//  Meta.m
//
//  Created by   on 15/8/11
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "Meta.h"


NSString *const kLoginMetaMessage = @"message";
NSString *const kLoginMetaCode = @"code";


@interface Meta ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation Meta

@synthesize message = _message;
@synthesize code = _code;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
            self.message = [self objectOrNilForKey:kLoginMetaMessage fromDictionary:dict];
            self.code = [[self objectOrNilForKey:kLoginMetaCode fromDictionary:dict] doubleValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.message forKey:kLoginMetaMessage];
    [mutableDict setValue:[NSNumber numberWithDouble:self.code] forKey:kLoginMetaCode];

    return [NSDictionary dictionaryWithDictionary:mutableDict];
}

- (NSString *)description 
{
    return [NSString stringWithFormat:@"%@", [self dictionaryRepresentation]];
}

#pragma mark - Helper Method
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict
{
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}


#pragma mark - NSCoding Methods

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];

    self.message = [aDecoder decodeObjectForKey:kLoginMetaMessage];
    self.code = [aDecoder decodeDoubleForKey:kLoginMetaCode];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_message forKey:kLoginMetaMessage];
    [aCoder encodeDouble:_code forKey:kLoginMetaCode];
}

- (id)copyWithZone:(NSZone *)zone
{
    Meta *copy = [[Meta alloc] init];
    
    if (copy) {

        copy.message = [self.message copyWithZone:zone];
        copy.code = self.code;
    }
    
    return copy;
}


@end
