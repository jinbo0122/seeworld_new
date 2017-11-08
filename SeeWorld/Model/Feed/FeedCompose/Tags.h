//
//  Tags.h
//
//  Created by liufz  on 15/9/15
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Coord;

@interface Tags : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) double tagId;
@property (nonatomic, strong) Coord *coord;
@property (nonatomic, strong) NSString *tagName;
@property (nonatomic, assign) double direction;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
