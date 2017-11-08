//
//  PersonInfoResponse.m
//
//  Created by liufz  on 15/9/18
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "PersonInfoResponse.h"
#import "Meta.h"
#import "PersonInfoData.h"


NSString *const kPersonInfoResponseMeta = @"meta";
NSString *const kPersonInfoResponseData = @"data";


@interface PersonInfoResponse ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation PersonInfoResponse

@synthesize meta = _meta;
@synthesize data = _data;


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
            self.meta = [CommonMeta modelObjectWithDictionary:[dict objectForKey:kPersonInfoResponseMeta]];
            self.data = [PersonInfoData modelObjectWithDictionary:[dict objectForKey:kPersonInfoResponseData]];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[self.meta dictionaryRepresentation] forKey:kPersonInfoResponseMeta];
    [mutableDict setValue:[self.data dictionaryRepresentation] forKey:kPersonInfoResponseData];

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

    self.meta = [aDecoder decodeObjectForKey:kPersonInfoResponseMeta];
    self.data = [aDecoder decodeObjectForKey:kPersonInfoResponseData];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_meta forKey:kPersonInfoResponseMeta];
    [aCoder encodeObject:_data forKey:kPersonInfoResponseData];
}

- (id)copyWithZone:(NSZone *)zone
{
    PersonInfoResponse *copy = [[PersonInfoResponse alloc] init];
    
    if (copy) {

        copy.meta = [self.meta copyWithZone:zone];
        copy.data = [self.data copyWithZone:zone];
    }
    
    return copy;
}


@end
