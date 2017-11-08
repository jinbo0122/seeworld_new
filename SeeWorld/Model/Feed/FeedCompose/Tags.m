//
//  Tags.m
//
//  Created by liufz  on 15/9/15
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "Tags.h"
#import "Coord.h"


NSString *const kTagsTagId = @"tagId";
NSString *const kTagsCoord = @"coord";
NSString *const kTagsTagName = @"tagName";
NSString *const kTagsDirection = @"direction";


@interface Tags ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation Tags

@synthesize tagId = _tagId;
@synthesize coord = _coord;
@synthesize tagName = _tagName;
@synthesize direction = _direction;


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
            self.tagId = [[self objectOrNilForKey:kTagsTagId fromDictionary:dict] doubleValue];
            self.coord = [Coord modelObjectWithDictionary:[dict objectForKey:kTagsCoord]];
            self.tagName = [self objectOrNilForKey:kTagsTagName fromDictionary:dict];
            self.direction = [[self objectOrNilForKey:kTagsDirection fromDictionary:dict] doubleValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.tagId] forKey:kTagsTagId];
    [mutableDict setValue:[self.coord dictionaryRepresentation] forKey:kTagsCoord];
    [mutableDict setValue:self.tagName forKey:kTagsTagName];
    [mutableDict setValue:[NSNumber numberWithDouble:self.direction] forKey:kTagsDirection];

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

    self.tagId = [aDecoder decodeDoubleForKey:kTagsTagId];
    self.coord = [aDecoder decodeObjectForKey:kTagsCoord];
    self.tagName = [aDecoder decodeObjectForKey:kTagsTagName];
    self.direction = [aDecoder decodeDoubleForKey:kTagsDirection];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_tagId forKey:kTagsTagId];
    [aCoder encodeObject:_coord forKey:kTagsCoord];
    [aCoder encodeObject:_tagName forKey:kTagsTagName];
    [aCoder encodeDouble:_direction forKey:kTagsDirection];
}

- (id)copyWithZone:(NSZone *)zone
{
    Tags *copy = [[Tags alloc] init];
    
    if (copy) {

        copy.tagId = self.tagId;
        copy.coord = [self.coord copyWithZone:zone];
        copy.tagName = [self.tagName copyWithZone:zone];
        copy.direction = self.direction;
    }
    
    return copy;
}


@end
