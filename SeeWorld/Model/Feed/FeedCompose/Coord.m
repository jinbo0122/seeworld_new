//
//  Coord.m
//
//  Created by liufz  on 15/9/15
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "Coord.h"


NSString *const kCoordY = @"y";
NSString *const kCoordW = @"w";
NSString *const kCoordX = @"x";
NSString *const kCoordH = @"h";


@interface Coord ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation Coord

@synthesize y = _y;
@synthesize w = _w;
@synthesize x = _x;
@synthesize h = _h;


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
            self.y = [[self objectOrNilForKey:kCoordY fromDictionary:dict] doubleValue];
            self.w = [[self objectOrNilForKey:kCoordW fromDictionary:dict] doubleValue];
            self.x = [[self objectOrNilForKey:kCoordX fromDictionary:dict] doubleValue];
            self.h = [[self objectOrNilForKey:kCoordH fromDictionary:dict] doubleValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.y] forKey:kCoordY];
    [mutableDict setValue:[NSNumber numberWithDouble:self.w] forKey:kCoordW];
    [mutableDict setValue:[NSNumber numberWithDouble:self.x] forKey:kCoordX];
    [mutableDict setValue:[NSNumber numberWithDouble:self.h] forKey:kCoordH];

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

    self.y = [aDecoder decodeDoubleForKey:kCoordY];
    self.w = [aDecoder decodeDoubleForKey:kCoordW];
    self.x = [aDecoder decodeDoubleForKey:kCoordX];
    self.h = [aDecoder decodeDoubleForKey:kCoordH];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_y forKey:kCoordY];
    [aCoder encodeDouble:_w forKey:kCoordW];
    [aCoder encodeDouble:_x forKey:kCoordX];
    [aCoder encodeDouble:_h forKey:kCoordH];
}

- (id)copyWithZone:(NSZone *)zone
{
    Coord *copy = [[Coord alloc] init];
    
    if (copy) {

        copy.y = self.y;
        copy.w = self.w;
        copy.x = self.x;
        copy.h = self.h;
    }
    
    return copy;
}


@end
