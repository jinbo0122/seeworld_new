//
//  SWModel.m
//  SeeWorld
//
//  Created by  on 15/8/11.
//  Copyright (c) 2015年 SeeWorld
//

#import "SWModel.h"
#import "CommonMeta.h"
static NSString *const kCommonResponseMeta = @"meta";

@interface SWModel ()
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;
@end

@implementation SWModel

@synthesize meta = _meta;

+ (instancetype) modelObjectWithJSON:(NSString *) jsonString
{
  if (!jsonString) {
    jsonString = @"{}";
  }
    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    if ([self instancesRespondToSelector:@selector(initWithDictionary:)])
    {
        return [[self alloc] initWithDictionary:dataDic];
    }
    return nil;
}

+ (ModelMessage *)messageWithRequst:(YTKBaseRequest *)request
{
    SWModel *object = nil;
    NSLog(@"Requst is %@",request);
    if (request.statusCodeValidator)
    {
        object = [self modelObjectWithJSON:request.responseString];
    }
    else if (request.responseString.length > 0)
    {
        object = [self modelObjectWithJSON:request.responseString];
    }
    ModelMessage *message = [[ModelMessage alloc] init];
    message.code = (nil == object.meta)? request.responseStatusCode:object.meta.code;
    message.message = (nil == object.meta)? @"":object.meta.message;
    message.object = object;
    return message;
}

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
        self.meta = [CommonMeta modelObjectWithDictionary:[dict objectForKey:kCommonResponseMeta]];
        
    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[self.meta dictionaryRepresentation] forKey:kCommonResponseMeta];
    
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
    
    self.meta = [aDecoder decodeObjectForKey:kCommonResponseMeta];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_meta forKey:kCommonResponseMeta];
}

- (id)copyWithZone:(NSZone *)zone
{
    SWModel *copy = [[SWModel alloc] init];
    
    if (copy) {
        
        copy.meta = [self.meta copyWithZone:zone];
    }
    
    return copy;
}

@end
