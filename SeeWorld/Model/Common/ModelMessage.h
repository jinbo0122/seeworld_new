//
//  ModelMessage.h
//  SeeWorld
//
//  Created by  on 15/8/11.
//  Copyright (c) 2015年 SeeWorld
//

#import <Foundation/Foundation.h>
#import "YTKBaseRequest.h"

@interface ModelMessage : NSObject
@property (nonatomic,strong) NSString * message;
@property (nonatomic,assign) NSInteger code;
@property (nonatomic,strong) id object;
- (BOOL) isSuccess;
@end
