//
//  SWModel.h
//  SeeWorld
//
//  Created by  on 15/8/11.
//  Copyright (c) 2015年 SeeWorld
//

#import <Foundation/Foundation.h>
#import "ModelMessage.h"
#import "YTKBaseRequest.h"

@class CommonMeta;
@interface SWModel : NSObject
@property (nonatomic, strong) CommonMeta *meta;
+ (instancetype) modelObjectWithJSON:(NSString *) jsonString;
+ (ModelMessage *)messageWithRequst:(YTKBaseRequest *)request;
@end
