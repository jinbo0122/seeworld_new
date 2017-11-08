//
//  ModelMessage.m
//  SeeWorld
//
//  Created by  on 15/8/11.
//  Copyright (c) 2015年 SeeWorld
//

#import "ModelMessage.h"
#import "CommonMeta.h"

@implementation ModelMessage
- (BOOL) isSuccess
{
    return _code >= 200 && _code < 299;
}

@end
