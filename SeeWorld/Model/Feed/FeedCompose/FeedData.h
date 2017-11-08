//
//  FeedData.h
//
//  Created by liufz  on 15/9/15
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface FeedData : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) double dataIdentifier;
@property (nonatomic, strong) NSArray *tags;
@property (nonatomic, strong) NSString *dataDescription;
@property (nonatomic, strong) NSString *photo;
@property (nonatomic, assign) double time;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
