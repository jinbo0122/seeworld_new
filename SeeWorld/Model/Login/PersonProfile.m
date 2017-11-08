//
//  PersonProfile.m
//
//  Created by   on 15/8/11
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "PersonProfile.h"


NSString *const kLoginDataEmail = @"email";
NSString *const kLoginDataCreateTime = @"createTime";
NSString *const kLoginDataGender = @"gender";
NSString *const kLoginDataJwt = @"jwt";
NSString *const kLoginDataName = @"name";
NSString *const kLoginDataHead = @"head";
NSString *const kLoginDataUserId = @"userId";
NSString *const kLoginDataRongToken = @"rongToken";


@interface PersonProfile ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation PersonProfile
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
            self.email = [self objectOrNilForKey:kLoginDataEmail fromDictionary:dict];
            self.createTime = [[self objectOrNilForKey:kLoginDataCreateTime fromDictionary:dict] doubleValue];
            self.gender = [[self objectOrNilForKey:kLoginDataGender fromDictionary:dict] doubleValue];
            self.jwt = [self objectOrNilForKey:kLoginDataJwt fromDictionary:dict];
            self.name = [self objectOrNilForKey:kLoginDataName fromDictionary:dict];
            self.head = [self objectOrNilForKey:kLoginDataHead fromDictionary:dict];
      self.userId = [dict safeStringObjectForKey:kLoginDataUserId];
      self.rongToken = [dict safeStringObjectForKey:kLoginDataRongToken];
    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.email forKey:kLoginDataEmail];
    [mutableDict setValue:[NSNumber numberWithDouble:self.createTime] forKey:kLoginDataCreateTime];
    [mutableDict setValue:[NSNumber numberWithDouble:self.gender] forKey:kLoginDataGender];
    [mutableDict setValue:self.jwt forKey:kLoginDataJwt];
    [mutableDict setValue:self.name forKey:kLoginDataName];
    [mutableDict setValue:self.head forKey:kLoginDataHead];
  [mutableDict setSafeObject:self.userId forKey:kLoginDataUserId];
  [mutableDict setSafeObject:self.rongToken forKey:kLoginDataRongToken];
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

    self.email = [aDecoder decodeObjectForKey:kLoginDataEmail];
    self.createTime = [aDecoder decodeDoubleForKey:kLoginDataCreateTime];
    self.gender = [aDecoder decodeDoubleForKey:kLoginDataGender];
    self.jwt = [aDecoder decodeObjectForKey:kLoginDataJwt];
    self.name = [aDecoder decodeObjectForKey:kLoginDataName];
    self.head = [aDecoder decodeObjectForKey:kLoginDataHead];
  self.userId = [aDecoder decodeObjectForKey:kLoginDataUserId];
  self.rongToken = [aDecoder decodeObjectForKey:kLoginDataRongToken];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_email forKey:kLoginDataEmail];
    [aCoder encodeDouble:_createTime forKey:kLoginDataCreateTime];
    [aCoder encodeDouble:_gender forKey:kLoginDataGender];
    [aCoder encodeObject:_jwt forKey:kLoginDataJwt];
    [aCoder encodeObject:_name forKey:kLoginDataName];
    [aCoder encodeObject:_head forKey:kLoginDataHead];
  [aCoder encodeObject:_userId forKey:kLoginDataUserId];
  [aCoder encodeObject:_rongToken forKey:kLoginDataRongToken];
}

- (id)copyWithZone:(NSZone *)zone
{
    PersonProfile *copy = [[PersonProfile alloc] init];
    
    if (copy) {

        copy.email = [self.email copyWithZone:zone];
        copy.createTime = self.createTime;
        copy.gender = self.gender;
        copy.jwt = [self.jwt copyWithZone:zone];
        copy.name = [self.name copyWithZone:zone];
        copy.head = [self.head copyWithZone:zone];
      copy.userId = [self.userId copyWithZone:zone];
      copy.rongToken = [self.rongToken copyWithZone:zone];
    }
    
    return copy;
}


@end
