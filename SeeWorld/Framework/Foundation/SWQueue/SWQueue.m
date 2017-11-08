//
//  SWQueue.m
//  
//
//  Created by abc on 15/4/13.
//  Copyright (c) 2015年 Abc
//

#import "SWQueue.h"

NSString* const kSyncQueueTypeDefault = @"kSyncQueueTypeDefault";
NSString* const kAsyncQueueTypeDefault = @"kAsyncQueueTypeDefault";

static NSMutableDictionary* SyncQueues;
static NSMutableDictionary* AsyncQueues;

static int const kAsyncQueueTypeDefaultMaxConcurrentOperationCount = 3;

typedef NS_ENUM(NSInteger, SWQueueConcurrentType)
{
    SWQueueConcurrentTypeSync,
    SWQueueConcurrentTypeAsync,
};

@interface SWQueue ()
{
}

@end

@implementation SWQueue

+ (void)initialize
{
    if (self == [SWQueue class])
    {
        [self registerSyncQueueWithType:kSyncQueueTypeDefault];
        [self registerAsyncQueueWithType:kAsyncQueueTypeDefault
             maxConcurrentOperationCount:kAsyncQueueTypeDefaultMaxConcurrentOperationCount];
    }
}

+ (NSMutableDictionary*)SyncQueues
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SyncQueues = [[NSMutableDictionary alloc] init];
    });
    return SyncQueues;
}

+ (NSMutableDictionary*)AsyncQueues
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        AsyncQueues = [[NSMutableDictionary alloc] init];
    });
    return AsyncQueues;
}

+ (BOOL)registerQueueWithConcurrentType:(SWQueueConcurrentType)cType queueType:(NSString*)qtype
{
    if (qtype.length == 0)
    {
        return NO;
    }

    if (SWQueueConcurrentTypeSync == cType)
    {
        @synchronized([self SyncQueues])
        {
            if ([self SyncQueues][qtype])
            {
                //已经存在
                return NO;
            }
            else
            {
                SWOperationQueue* queue = [[SWOperationQueue alloc] init];
                queue.maxConcurrentOperationCount = 1;
                [self SyncQueues][qtype] = queue;
            }
        }
    }
    else if (SWQueueConcurrentTypeAsync == cType)
    {
        @synchronized([self AsyncQueues])
        {
            if ([self AsyncQueues][qtype])
            {
                //已经存在
                return NO;
            }
            else
            {
                SWOperationQueue* queue = [[SWOperationQueue alloc] init];
                [self AsyncQueues][qtype] = queue;
            }
        }
    }
    else
    {
        return NO;
    }

    return YES;
}

+ (BOOL)registerSyncQueueWithType:(NSString*)type
{
    return [self registerQueueWithConcurrentType:SWQueueConcurrentTypeSync queueType:type];
}

+ (BOOL)registerAsyncQueueWithType:(NSString*)type maxConcurrentOperationCount:(NSInteger)count
{
    if ([self registerQueueWithConcurrentType:SWQueueConcurrentTypeAsync queueType:type])
    {
        @synchronized([self AsyncQueues])
        {
            ((SWOperationQueue*) [self AsyncQueues][type]).maxConcurrentOperationCount = count;
        }
        return YES;
    }
    else
    {
        return NO;
    }
}

+ (void)unregisterSyncQueueWithType:(NSString*)type
{
    @synchronized([self SyncQueues])
    {
        [[self SyncQueues][type] cancelAllOperations];
        [[self SyncQueues] removeObjectForKey:type];
    }
}

+ (void)unregisterAsyncQueueWithType:(NSString*)type
{
    @synchronized([self AsyncQueues])
    {
        [[self AsyncQueues][type] cancelAllOperations];
        [[self AsyncQueues] removeObjectForKey:type];
    }
}

+ (SWOperationQueue *)syncQueueWithType:(NSString *)type
{
    @synchronized([self SyncQueues])
    {
        return [self SyncQueues][type];
    }
}

+ (SWOperationQueue *)asyncQueueWithType:(NSString *)type
{
    @synchronized([self AsyncQueues])
    {
        return [self AsyncQueues][type];
    }
}

+ (void)clear
{
    @synchronized([self SyncQueues])
    {
        [[self SyncQueues] enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL* stop) {
            [(SWOperationQueue *)obj cancelAllOperations];
        }];

        [[self SyncQueues] removeAllObjects];
    }

    @synchronized([self AsyncQueues])
    {
        [[self AsyncQueues] enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL* stop) {
            [(SWOperationQueue *)obj cancelAllOperations];
        }];

        [[self AsyncQueues] removeAllObjects];
    }

    [[SWOperationQueue mainQueue] cancelAllOperations];
}

+ (void)cancelOpertionsWithQueueType:(NSString*)type
{
    [self cancelOpertionsWithSyncQueueType:type];
    [self cancelOpertionsWithAsyncQueueType:type];
}

+ (void)cancelOpertionsWithSyncQueueType:(NSString*)type
{
    @synchronized([self SyncQueues])
    {
        [(SWOperationQueue*) [self SyncQueues][type] cancelAllOperations];
    }
}

+ (void)cancelOpertionsWithAsyncQueueType:(NSString*)type
{
    @synchronized([self AsyncQueues])
    {
        [(SWOperationQueue*) [self AsyncQueues][type] cancelAllOperations];
    }
}

+ (void)cancelOpertionsWithName:(NSString*)operationName
{
    @synchronized([self SyncQueues])
    {
        [[self SyncQueues] enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL* stop) {
            [((SWOperationQueue *)obj).operations enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                if(((SWOperation *)obj).operationName.length > 0 &&
                   [((SWOperation *)obj).operationName isEqualToString:operationName]) {
                    [((SWOperation *)obj) cancel];
                }
            }];
        }];
    }

    @synchronized([self AsyncQueues])
    {
        [[self AsyncQueues] enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL* stop) {
            [((SWOperationQueue *)obj).operations enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                if(((SWOperation *)obj).operationName.length > 0 &&
                   [((SWOperation *)obj).name isEqualToString:operationName]) {
                    [((SWOperation *)obj) cancel];
                }
            }];
        }];
    }
}

+ (void)cancelAllOperations
{
    @synchronized([self SyncQueues])
    {
        [[self SyncQueues] enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL* stop) {
            [(SWOperationQueue *)obj cancelAllOperations];
        }];
    }

    @synchronized([self AsyncQueues])
    {
        [[self AsyncQueues] enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL* stop) {
            [(SWOperationQueue *)obj cancelAllOperations];
        }];
    }

    [[SWOperationQueue mainQueue] cancelAllOperations];
}

+ (void)resetAsyncQueueWithType:(NSString*)type maxConcurrentOperationCount:(NSInteger)count
{
    @synchronized([self AsyncQueues])
    {
        [(SWOperationQueue*) [self AsyncQueues][type] setMaxConcurrentOperationCount:count];
    }
}

+ (void)waitUntilAllOperationsAreFinished
{
    @synchronized([self SyncQueues])
    {
        [[self SyncQueues] enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL* stop) {
            [(SWOperationQueue *)obj waitUntilAllOperationsAreFinished];
        }];
    }

    @synchronized([self AsyncQueues])
    {
        [[self AsyncQueues] enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL* stop) {
            [(SWOperationQueue *)obj waitUntilAllOperationsAreFinished];
        }];
    }
}

+ (void)waitUntilAllOperationsAreFinishedWithSyncQueueType:(NSString*)type
{
    @synchronized([self SyncQueues])
    {
        [(SWOperationQueue*) [self SyncQueues][type] waitUntilAllOperationsAreFinished];
    }
}

+ (void)waitUntilAllOperationsAreFinishedWithAsyncQueueType:(NSString*)type
{
    @synchronized([self AsyncQueues])
    {
        [(SWOperationQueue*) [self AsyncQueues][type] waitUntilAllOperationsAreFinished];
    }
}

+ (void)dispatchInSyncQueueWithBlock:(SWQueueBlock)block
{
    [self dispatchInSyncQueueWithQueueType:kSyncQueueTypeDefault block:block];
}

+ (void)dispatchInSyncQueueWithBlock:(SWQueueBlock)block completionBlock:(SWQueueBlock)cblock
{
    [self dispatchInSyncQueueWithQueueType:kSyncQueueTypeDefault block:block completionBlock:cblock];
}

+ (void)dispatchInSyncQueueWithQueueType:(NSString*)type block:(SWQueueBlock)block
{
    [self dispatchInSyncQueueWithQueueType:type block:block completionBlock:nil];
}

+ (void)dispatchInSyncQueueWithQueueType:(NSString*)type block:(SWQueueBlock)block completionBlock:(SWQueueBlock)cblock
{
    [self executWithConcurrentType:SWQueueConcurrentTypeSync
                         queueType:type
                     operationName:nil
                          priority:NSOperationQueuePriorityNormal
                             block:block
                   completionBlock:cblock];
}

+ (void)dispatchInSyncQueueWithQueueType:(NSString*)type
                           operationName:(NSString*)operationName
                                priority:(NSOperationQueuePriority)priorty
                                   block:(void (^)(void))block
                         completionBlock:(void (^)(void))completionBlock
{
    [self executWithConcurrentType:SWQueueConcurrentTypeSync
                         queueType:type
                     operationName:operationName
                          priority:priorty
                             block:block
                   completionBlock:completionBlock];
}

+ (void)dispatchInAsyncQueueWithBlock:(SWQueueBlock)block
{
    [self dispatchInAsyncQueueWithQueueType:kAsyncQueueTypeDefault block:block];
}

+ (void)dispatchInAsyncQueueWithBlock:(SWQueueBlock)block completionBlock:(SWQueueBlock)cblock
{
    [self dispatchInAsyncQueueWithQueueType:kAsyncQueueTypeDefault block:block completionBlock:cblock];
}

+ (void)dispatchInAsyncQueueWithQueueType:(NSString*)type block:(SWQueueBlock)block
{
    [self dispatchInAsyncQueueWithQueueType:type block:block completionBlock:nil];
}

+ (void)dispatchInAsyncQueueWithQueueType:(NSString*)type block:(SWQueueBlock)block completionBlock:(SWQueueBlock)cblock
{
    [self executWithConcurrentType:SWQueueConcurrentTypeAsync
                         queueType:type
                     operationName:nil
                          priority:NSOperationQueuePriorityNormal
                             block:block
                   completionBlock:cblock];
}

+ (void)dispatchInAsyncQueueWithQueueType:(NSString*)type
                            operationName:(NSString*)operationName
                                 priority:(NSOperationQueuePriority)priorty
                                    block:(void (^)(void))block
                          completionBlock:(void (^)(void))completionBlock
{
    [self executWithConcurrentType:SWQueueConcurrentTypeAsync
                         queueType:type
                     operationName:operationName
                          priority:priorty
                             block:block
                   completionBlock:completionBlock];
}

+ (void)executWithConcurrentType:(SWQueueConcurrentType)cType
                       queueType:(NSString*)qtype
                   operationName:(NSString*)operationName
                        priority:(NSOperationQueuePriority)priorty
                           block:(void (^)(void))block
                 completionBlock:(void (^)(void))completionBlock
{
    SWOperation* operation = [SWOperation operationWithName:operationName
                                                 priority:priorty
                                                    block:block
                                          completionBlock:completionBlock];

    if (SWQueueConcurrentTypeSync == cType)
    {
        @synchronized([self SyncQueues])
        {
            [(SWOperationQueue*) [self SyncQueues][qtype] addOperation:operation];
        }
    }
    else
    {
        @synchronized([self AsyncQueues])
        {
            [(SWOperationQueue*) [self AsyncQueues][qtype] addOperation:operation];
        }
    }
}

+ (void)dispatchInMainQueueWithBlock:(SWQueueBlock)block
{
    [self dispatchInMainQueueWithBlock:block completionBlock:nil];
}

+ (void)dispatchInMainQueueWithBlock:(SWQueueBlock)block completionBlock:(SWQueueBlock)cblock
{
    [self dispatchInMainQueueWithOperationName:nil
                                      priority:NSOperationQueuePriorityNormal
                                         block:block
                               completionBlock:cblock];
}

+ (void)dispatchInMainQueueWithOperationName:(NSString*)operationName
                                    priority:(NSOperationQueuePriority)priorty
                                       block:(void (^)(void))block
                             completionBlock:(void (^)(void))completionBlock
{
    SWOperation* operation = [SWOperation operationWithName:operationName
                                                 priority:priorty
                                                    block:block
                                          completionBlock:completionBlock];
    [[SWOperationQueue mainQueue] addOperation:operation];
}

@end
