//
//  FeedComposeResponse.m
//
//  Created by liufz  on 15/9/15
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "FeedComposeResponse.h"
#import "Meta.h"
#import "FeedData.h"


NSString *const kFeedComposeResponseMeta = @"meta";
NSString *const kFeedComposeResponseData = @"data";


@interface FeedComposeResponse ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation FeedComposeResponse

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
            self.meta = [CommonMeta modelObjectWithDictionary:[dict objectForKey:kFeedComposeResponseMeta]];
            self.data = [FeedData modelObjectWithDictionary:[dict objectForKey:kFeedComposeResponseData]];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[self.meta dictionaryRepresentation] forKey:kFeedComposeResponseMeta];
    [mutableDict setValue:[self.data dictionaryRepresentation] forKey:kFeedComposeResponseData];

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

    self.meta = [aDecoder decodeObjectForKey:kFeedComposeResponseMeta];
    self.data = [aDecoder decodeObjectForKey:kFeedComposeResponseData];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_meta forKey:kFeedComposeResponseMeta];
    [aCoder encodeObject:_data forKey:kFeedComposeResponseData];
}

- (id)copyWithZone:(NSZone *)zone
{
    FeedComposeResponse *copy = [[FeedComposeResponse alloc] init];
    
    if (copy) {

        copy.meta = [self.meta copyWithZone:zone];
        copy.data = [self.data copyWithZone:zone];
    }
    
    return copy;
}


@end
