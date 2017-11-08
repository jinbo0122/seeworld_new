//
//  GetQiniuTokenResponse.h
//
//  Created by liufz  on 15/9/15
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SWModel.h"

@class CommonMeta;

@interface GetQiniuTokenResponse : SWModel <NSCoding, NSCopying>

@property (nonatomic, strong) CommonMeta *meta;
@property (nonatomic, strong) NSString *data;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
