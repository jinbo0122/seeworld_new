//
//  SWOperationQueue.m
//  
//
//  Created by abc on 15/4/14.
//  Copyright (c) 2015年 Abc
//

#import "SWOperationQueue.h"

@implementation SWOperationQueue
- (NSArray *)addDependencyOperation:(NSOperation *)operation
{
    NSAssert([operation isKindOfClass:[NSOperation class]], @"should be NSOperation");
    for (NSOperation *parentOperation in self.operations)
    {
        [operation addDependency:parentOperation];
    }
    [self addOperation:operation];
    return self.operations;
}

- (NSArray *)addDependencyOperations:(NSArray *)operations
{
    for (NSOperation *parentOperation in self.operations)
    {
        [operations enumerateObjectsUsingBlock:^(NSOperation *newOp, NSUInteger idx, BOOL *stop) {
            NSAssert([newOp isKindOfClass:[NSOperation class]], @"should be NSOperation");
            [newOp addDependency:parentOperation];
        }];
    }
    [self addOperations:operations waitUntilFinished:NO];
    return self.operations;
}

- (SWOperationQueue * (^)(id))then
{
    return ^SWOperationQueue *(NSOperation *operation)
    {
        [self addDependencyOperation:operation];
        return self;
    };
}

- (SWOperationQueue * (^)(NSArray *))when
{
    return ^SWOperationQueue *(NSArray *operations)
    {
        [self addDependencyOperations:operations];
        return self;
    };
}

- (void (^)(void))start
{
    return ^{
        [self addOperations:self.operations waitUntilFinished:NO];
    };
}
@end
