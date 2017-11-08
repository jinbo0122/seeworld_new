//
//  SWOperationQueue.h
//  
//
//  Created by abc on 15/4/14.
//  Copyright (c) 2015年 Abc
//

#import <Foundation/Foundation.h>

@interface SWOperationQueue : NSOperationQueue
/**
 *  @author Abc
 *
 *  操作的依赖关系
 *  请参考:https://github.com/azu/OperationPromise
 */
@property (readonly) SWOperationQueue * (^then)(id operation);
@property (readonly) SWOperationQueue * (^when)(NSArray *operations);
@property (readonly) void (^start)(void);
@end
