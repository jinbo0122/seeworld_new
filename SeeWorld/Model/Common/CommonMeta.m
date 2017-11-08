//
//  Meta.m
//
//  Created by   on 15/8/11
//  Copyright (c) 2015 __MyCompanyName__
//

#import "CommonMeta.h"


static NSString *const kMetaMessage = @"message";
static NSString *const kMetaCode = @"code";


@interface CommonMeta ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation CommonMeta

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
            self.message = [self objectOrNilForKey:kMetaMessage fromDictionary:dict];
            self.code = [[self objectOrNilForKey:kMetaCode fromDictionary:dict] doubleValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.message forKey:kMetaMessage];
    [mutableDict setValue:[NSNumber numberWithDouble:self.code] forKey:kMetaCode];

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

    self.message = [aDecoder decodeObjectForKey:kMetaMessage];
    self.code = [aDecoder decodeDoubleForKey:kMetaCode];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_message forKey:kMetaMessage];
    [aCoder encodeDouble:_code forKey:kMetaCode];
}

- (id)copyWithZone:(NSZone *)zone
{
    CommonMeta *copy = [[CommonMeta alloc] init];
    
    if (copy) {

        copy.message = [self.message copyWithZone:zone];
        copy.code = self.code;
    }
    
    return copy;
}


@end
