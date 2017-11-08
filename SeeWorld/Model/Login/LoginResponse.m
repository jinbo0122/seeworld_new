//
//  LoginResponse.m
//
//  Created by   on 15/8/11
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "LoginResponse.h"
#import "Meta.h"
#import "PersonProfile.h"


NSString *const kLoginResponseMeta = @"meta";
NSString *const kLoginResponseData = @"data";


@interface LoginResponse ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation LoginResponse

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
            self.meta = [CommonMeta modelObjectWithDictionary:[dict objectForKey:kLoginResponseMeta]];
            self.data = [PersonProfile modelObjectWithDictionary:[dict objectForKey:kLoginResponseData]];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[self.meta dictionaryRepresentation] forKey:kLoginResponseMeta];
    [mutableDict setValue:[self.data dictionaryRepresentation] forKey:kLoginResponseData];

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

    self.meta = [aDecoder decodeObjectForKey:kLoginResponseMeta];
    self.data = [aDecoder decodeObjectForKey:kLoginResponseData];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_meta forKey:kLoginResponseMeta];
    [aCoder encodeObject:_data forKey:kLoginResponseData];
}

- (id)copyWithZone:(NSZone *)zone
{
    LoginResponse *copy = [[LoginResponse alloc] init];
    
    if (copy) {

        copy.meta = [self.meta copyWithZone:zone];
        copy.data = [self.data copyWithZone:zone];
    }
    
    return copy;
}


@end
