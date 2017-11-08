//
//  FeedData.m
//
//  Created by liufz  on 15/9/15
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "FeedData.h"
#import "Tags.h"


NSString *const kDataId = @"id";
NSString *const kDataTags = @"tags";
NSString *const kDataDescription = @"description";
NSString *const kDataPhoto = @"photo";
NSString *const kDataTime = @"time";


@interface FeedData ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation FeedData

@synthesize dataIdentifier = _dataIdentifier;
@synthesize tags = _tags;
@synthesize dataDescription = _dataDescription;
@synthesize photo = _photo;
@synthesize time = _time;


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
            self.dataIdentifier = [[self objectOrNilForKey:kDataId fromDictionary:dict] doubleValue];
    NSObject *receivedTags = [dict objectForKey:kDataTags];
    NSMutableArray *parsedTags = [NSMutableArray array];
    if ([receivedTags isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedTags) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedTags addObject:[Tags modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedTags isKindOfClass:[NSDictionary class]]) {
       [parsedTags addObject:[Tags modelObjectWithDictionary:(NSDictionary *)receivedTags]];
    }

    self.tags = [NSArray arrayWithArray:parsedTags];
            self.dataDescription = [self objectOrNilForKey:kDataDescription fromDictionary:dict];
            self.photo = [self objectOrNilForKey:kDataPhoto fromDictionary:dict];
            self.time = [[self objectOrNilForKey:kDataTime fromDictionary:dict] doubleValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.dataIdentifier] forKey:kDataId];
    NSMutableArray *tempArrayForTags = [NSMutableArray array];
    for (NSObject *subArrayObject in self.tags) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForTags addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForTags addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForTags] forKey:kDataTags];
    [mutableDict setValue:self.dataDescription forKey:kDataDescription];
    [mutableDict setValue:self.photo forKey:kDataPhoto];
    [mutableDict setValue:[NSNumber numberWithDouble:self.time] forKey:kDataTime];

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

    self.dataIdentifier = [aDecoder decodeDoubleForKey:kDataId];
    self.tags = [aDecoder decodeObjectForKey:kDataTags];
    self.dataDescription = [aDecoder decodeObjectForKey:kDataDescription];
    self.photo = [aDecoder decodeObjectForKey:kDataPhoto];
    self.time = [aDecoder decodeDoubleForKey:kDataTime];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_dataIdentifier forKey:kDataId];
    [aCoder encodeObject:_tags forKey:kDataTags];
    [aCoder encodeObject:_dataDescription forKey:kDataDescription];
    [aCoder encodeObject:_photo forKey:kDataPhoto];
    [aCoder encodeDouble:_time forKey:kDataTime];
}

- (id)copyWithZone:(NSZone *)zone
{
    FeedData *copy = [[FeedData alloc] init];
    
    if (copy) {

        copy.dataIdentifier = self.dataIdentifier;
        copy.tags = [self.tags copyWithZone:zone];
        copy.dataDescription = [self.dataDescription copyWithZone:zone];
        copy.photo = [self.photo copyWithZone:zone];
        copy.time = self.time;
    }
    
    return copy;
}


@end
