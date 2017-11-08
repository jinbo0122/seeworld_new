//
//  GetQiniuTokenResponse.m
//
//  Created by liufz  on 15/9/15
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "GetQiniuTokenResponse.h"
#import "Meta.h"


NSString *const kGetQiniuTokenResponseMeta = @"meta";
NSString *const kGetQiniuTokenResponseData = @"data";


@interface GetQiniuTokenResponse ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation GetQiniuTokenResponse

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
            self.meta = [CommonMeta modelObjectWithDictionary:[dict objectForKey:kGetQiniuTokenResponseMeta]];
            self.data = [self objectOrNilForKey:kGetQiniuTokenResponseData fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[self.meta dictionaryRepresentation] forKey:kGetQiniuTokenResponseMeta];
    [mutableDict setValue:self.data forKey:kGetQiniuTokenResponseData];

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

    self.meta = [aDecoder decodeObjectForKey:kGetQiniuTokenResponseMeta];
    self.data = [aDecoder decodeObjectForKey:kGetQiniuTokenResponseData];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_meta forKey:kGetQiniuTokenResponseMeta];
    [aCoder encodeObject:_data forKey:kGetQiniuTokenResponseData];
}

- (id)copyWithZone:(NSZone *)zone
{
    GetQiniuTokenResponse *copy = [[GetQiniuTokenResponse alloc] init];
    
    if (copy) {

        copy.meta = [self.meta copyWithZone:zone];
        copy.data = [self.data copyWithZone:zone];
    }
    
    return copy;
}


@end
