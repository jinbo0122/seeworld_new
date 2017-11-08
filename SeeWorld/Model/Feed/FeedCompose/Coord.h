//
//  Coord.h
//
//  Created by liufz  on 15/9/15
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface Coord : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) double y;
@property (nonatomic, assign) double w;
@property (nonatomic, assign) double x;
@property (nonatomic, assign) double h;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
