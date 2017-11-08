//
//  PersonInfoData.m
//
//  Created by liufz  on 15/9/18
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "PersonInfoData.h"


NSString *const kPersonInfoDataGender = @"gender";
NSString *const kPersonInfoDataFeedCount = @"feedCount";
NSString *const kPersonInfoDataFollowerCount = @"followerCount";
NSString *const kPersonInfoDataId = @"id";
NSString *const kPersonInfoDataHead = @"head";
NSString *const kPersonInfoDataRelation = @"relation";
NSString *const kPersonInfoDataDescription = @"description";
NSString *const kPersonInfoDataName = @"name";
NSString *const kPersonInfoDataFollowedCount = @"followedCount";


@interface PersonInfoData ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation PersonInfoData

@synthesize gender = _gender;
@synthesize feedCount = _feedCount;
@synthesize followerCount = _followerCount;
@synthesize dataIdentifier = _dataIdentifier;
@synthesize head = _head;
@synthesize relation = _relation;
@synthesize dataDescription = _dataDescription;
@synthesize name = _name;
@synthesize followedCount = _followedCount;


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
            self.gender = [[self objectOrNilForKey:kPersonInfoDataGender fromDictionary:dict] doubleValue];
            self.feedCount = [[self objectOrNilForKey:kPersonInfoDataFeedCount fromDictionary:dict] doubleValue];
            self.followerCount = [[self objectOrNilForKey:kPersonInfoDataFollowerCount fromDictionary:dict] doubleValue];
            self.dataIdentifier = [[self objectOrNilForKey:kPersonInfoDataId fromDictionary:dict] doubleValue];
            self.head = [self objectOrNilForKey:kPersonInfoDataHead fromDictionary:dict];
            self.relation = [[self objectOrNilForKey:kPersonInfoDataRelation fromDictionary:dict] doubleValue];
            self.dataDescription = [self objectOrNilForKey:kPersonInfoDataDescription fromDictionary:dict];
            self.name = [self objectOrNilForKey:kPersonInfoDataName fromDictionary:dict];
            self.followedCount = [[self objectOrNilForKey:kPersonInfoDataFollowedCount fromDictionary:dict] doubleValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.gender] forKey:kPersonInfoDataGender];
    [mutableDict setValue:[NSNumber numberWithDouble:self.feedCount] forKey:kPersonInfoDataFeedCount];
    [mutableDict setValue:[NSNumber numberWithDouble:self.followerCount] forKey:kPersonInfoDataFollowerCount];
    [mutableDict setValue:[NSNumber numberWithDouble:self.dataIdentifier] forKey:kPersonInfoDataId];
    [mutableDict setValue:self.head forKey:kPersonInfoDataHead];
    [mutableDict setValue:[NSNumber numberWithDouble:self.relation] forKey:kPersonInfoDataRelation];
    [mutableDict setValue:self.dataDescription forKey:kPersonInfoDataDescription];
    [mutableDict setValue:self.name forKey:kPersonInfoDataName];
    [mutableDict setValue:[NSNumber numberWithDouble:self.followedCount] forKey:kPersonInfoDataFollowedCount];

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

    self.gender = [aDecoder decodeDoubleForKey:kPersonInfoDataGender];
    self.feedCount = [aDecoder decodeDoubleForKey:kPersonInfoDataFeedCount];
    self.followerCount = [aDecoder decodeDoubleForKey:kPersonInfoDataFollowerCount];
    self.dataIdentifier = [aDecoder decodeDoubleForKey:kPersonInfoDataId];
    self.head = [aDecoder decodeObjectForKey:kPersonInfoDataHead];
    self.relation = [aDecoder decodeDoubleForKey:kPersonInfoDataRelation];
    self.dataDescription = [aDecoder decodeObjectForKey:kPersonInfoDataDescription];
    self.name = [aDecoder decodeObjectForKey:kPersonInfoDataName];
    self.followedCount = [aDecoder decodeDoubleForKey:kPersonInfoDataFollowedCount];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_gender forKey:kPersonInfoDataGender];
    [aCoder encodeDouble:_feedCount forKey:kPersonInfoDataFeedCount];
    [aCoder encodeDouble:_followerCount forKey:kPersonInfoDataFollowerCount];
    [aCoder encodeDouble:_dataIdentifier forKey:kPersonInfoDataId];
    [aCoder encodeObject:_head forKey:kPersonInfoDataHead];
    [aCoder encodeDouble:_relation forKey:kPersonInfoDataRelation];
    [aCoder encodeObject:_dataDescription forKey:kPersonInfoDataDescription];
    [aCoder encodeObject:_name forKey:kPersonInfoDataName];
    [aCoder encodeDouble:_followedCount forKey:kPersonInfoDataFollowedCount];
}

- (id)copyWithZone:(NSZone *)zone
{
    PersonInfoData *copy = [[PersonInfoData alloc] init];
    
    if (copy) {

        copy.gender = self.gender;
        copy.feedCount = self.feedCount;
        copy.followerCount = self.followerCount;
        copy.dataIdentifier = self.dataIdentifier;
        copy.head = [self.head copyWithZone:zone];
        copy.relation = self.relation;
        copy.dataDescription = [self.dataDescription copyWithZone:zone];
        copy.name = [self.name copyWithZone:zone];
        copy.followedCount = self.followedCount;
    }
    
    return copy;
}


@end
