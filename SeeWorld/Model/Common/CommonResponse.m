//
//  CommonResponse.m
//
//  Created by   on 15/8/11
//  Copyright (c) 2015 __MyCompanyName__
//

#import "CommonResponse.h"
#import "CommonMeta.h"

NSString *const kCommonResponseMeta = @"meta";


@interface CommonResponse ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation CommonResponse

@synthesize meta = _meta;


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
            self.meta = [CommonMeta modelObjectWithDictionary:[dict objectForKey:kCommonResponseMeta]];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[self.meta dictionaryRepresentation] forKey:kCommonResponseMeta];

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

    self.meta = [aDecoder decodeObjectForKey:kCommonResponseMeta];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_meta forKey:kCommonResponseMeta];
}

- (id)copyWithZone:(NSZone *)zone
{
    CommonResponse *copy = [[CommonResponse alloc] init];
    
    if (copy) {

        copy.meta = [self.meta copyWithZone:zone];
    }
    
    return copy;
}


@end
