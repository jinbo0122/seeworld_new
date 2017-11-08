//
//  RelationshipResponse.m
//
//  Created by fazheng liu on 15/10/11
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "RelationshipResponse.h"
#import "Meta.h"
#import "PersonInfoData.h"


NSString *const kRelationshipResponseMeta = @"meta";
NSString *const kRelationshipResponseData = @"data";


@interface RelationshipResponse ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation RelationshipResponse

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
            self.meta = [CommonMeta modelObjectWithDictionary:[dict objectForKey:kRelationshipResponseMeta]];
    NSObject *receivedRelationshipData = [dict objectForKey:kRelationshipResponseData];
    NSMutableArray *parsedRelationshipData = [NSMutableArray array];
    if ([receivedRelationshipData isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedRelationshipData) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedRelationshipData addObject:[PersonInfoData modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedRelationshipData isKindOfClass:[NSDictionary class]]) {
       [parsedRelationshipData addObject:[PersonInfoData modelObjectWithDictionary:(NSDictionary *)receivedRelationshipData]];
    }

    self.data = [NSArray arrayWithArray:parsedRelationshipData];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[self.meta dictionaryRepresentation] forKey:kRelationshipResponseMeta];
    NSMutableArray *tempArrayForData = [NSMutableArray array];
    for (NSObject *subArrayObject in self.data) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForData addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForData addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForData] forKey:kRelationshipResponseData];

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

    self.meta = [aDecoder decodeObjectForKey:kRelationshipResponseMeta];
    self.data = [aDecoder decodeObjectForKey:kRelationshipResponseData];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_meta forKey:kRelationshipResponseMeta];
    [aCoder encodeObject:_data forKey:kRelationshipResponseData];
}

- (id)copyWithZone:(NSZone *)zone
{
    RelationshipResponse *copy = [[RelationshipResponse alloc] init];
    
    if (copy) {

        copy.meta = [self.meta copyWithZone:zone];
        copy.data = [self.data copyWithZone:zone];
    }
    
    return copy;
}


@end
