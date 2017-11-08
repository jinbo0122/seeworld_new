//
//  SWQueue.h
//  
//
//  Created by abc on 15/4/13.
//  Copyright (c) 2015年 Abc
//

#import <Foundation/Foundation.h>
#import "SWOperation.h"
#import "SWOperationQueue.h"
#import "SWObject.h"

//默认同步执行任务Queue类型
extern NSString* const kSyncQueueTypeDefault;
//默认异步执行任务Queue类型
extern NSString* const kAsyncQueueTypeDefault;

typedef NS_ENUM(NSInteger, SWQueuePriority) {
    SWQueuePriorityVeryLow = NSOperationQueuePriorityVeryLow,
    SWQueuePriorityLow = NSOperationQueuePriorityLow,
    SWQueuePriorityNormal = NSOperationQueuePriorityNormal,
    SWQueuePriorityHigh = NSOperationQueuePriorityHigh,
    SWQueuePriorityVeryHigh = NSOperationQueuePriorityVeryHigh
};

typedef void (^SWQueueBlock)(void);

/**
 *  @author Abc
 *
 *  提供了同步异步执行任务操作.
 *  同步执行:此队列中所有操作任务同步执行,线程中每次仅仅仅仅执行一个任务,形成依赖
 *  异步执行:此队列中所有操作任务异步并发执行.
 */
@interface SWQueue : SWObject

#pragma mark - 队列注册
/**
 *  @author Abc
 *
 *  注册一个同步操作队列
 *
 *  @param type Queue类型
 *
 *  @return 注册是否成功,如果注册失败,一般表示已经存在此类行的队列
 */
+ (BOOL)registerSyncQueueWithType:(NSString*)type;

/**
 *  @author Abc
 *
 *  注册异步队列
 *
 *  @param type  Queue类型
 *  @param count 最大线程并发数目
 *
 *  @return 注册是否成功,如果注册失败,一般表示已经存在此类行的队列
 */
+ (BOOL)registerAsyncQueueWithType:(NSString*)type maxConcurrentOperationCount:(NSInteger)count;

/**
 *  @author Abc
 *
 *  注销一个同步操作队列
 *
 *  @param type Queue类型
 *
 *  @return 注销是否成功
 */
+ (void)unregisterSyncQueueWithType:(NSString*)type;

/**
 *  @author Abc
 *
 *  注销一个异步操作队列
 *
 *  @param type Queue类型
 *
 *  @return 注销是否成功
 */
+ (void)unregisterAsyncQueueWithType:(NSString*)type;

/**
 *  @author Abc
 *
 *  根据type获取当前已经注册的同步Queue
 *
 *  @param type Queue类型
 *
 *  @return Queue
 */
+ (SWOperationQueue *)syncQueueWithType:(NSString *)type;

/**
 *  @author Abc
 *
 *  根据type获取当前已经注册的异步并发Queue
 *
 *  @param type Queue类型
 *
 *  @return Queue
 */
+ (SWOperationQueue *)asyncQueueWithType:(NSString *)type;

#pragma mark - 队列清理
/**
 *  @author Abc
 *
 *  清空所有操作队列
 *
 *  @param type Queue类型
 *
 */
+ (void)clear;

/**
 *  @author Abc
 *
 *  取消该同步类型队列中所有操作
 *
 *  @param type Queue类型
 */
+ (void)cancelOpertionsWithSyncQueueType:(NSString*)type;

/**
 *  @author Abc
 *
 *  取消该异步类型队列中所有操作
 *
 *  @param type Queue类型
 */
+ (void)cancelOpertionsWithAsyncQueueType:(NSString*)type;

/**
 *  @author Abc
 *
 *  取消该类型队列中所有操作,如果同步异步Queue的Type相同,则两个Queue都会被取消.
 *
 *  @param type Queue类型
 */
+ (void)cancelOpertionsWithQueueType:(NSString*)type;

/**
 *  @author Abc
 *
 *  根据Opration名称取消操作
 *
 *  @param operationName Operation名称
 */
+ (void)cancelOpertionsWithName:(NSString*)operationName;

/**
 *  @author Abc
 *
 *  取消所有Queue中的操作任务
 */
+ (void)cancelAllOperations;

#pragma mark - 重置队列
/**
 *  @author Abc
 *
 *  重新设置异步队列的并发线程数目
 *
 *  @param type  Queue类型
 *  @param count 最大线程并发数目
 */
+ (void)resetAsyncQueueWithType:(NSString*)type maxConcurrentOperationCount:(NSInteger)count;

#pragma mark - 任务等待执行
/**
 *  @author Abc
 *
 *  等待队列中任务执行完成
 */
+ (void)waitUntilAllOperationsAreFinished;
+ (void)waitUntilAllOperationsAreFinishedWithSyncQueueType:(NSString*)type;
+ (void)waitUntilAllOperationsAreFinishedWithAsyncQueueType:(NSString*)type;

#pragma mark - 同步队列任务分发
/**
 *  @author Abc
 *
 *  分发到同步队列中一个任务
 *
 *  @param block block
 */
+ (void)dispatchInSyncQueueWithBlock:(SWQueueBlock)block;
+ (void)dispatchInSyncQueueWithBlock:(SWQueueBlock)block completionBlock:(SWQueueBlock)cblock;
+ (void)dispatchInSyncQueueWithQueueType:(NSString*)type block:(SWQueueBlock)block;
+ (void)dispatchInSyncQueueWithQueueType:(NSString*)type block:(SWQueueBlock)block completionBlock:(SWQueueBlock)cblock;
+ (void)dispatchInSyncQueueWithQueueType:(NSString*)type
                           operationName:(NSString*)operationName
                                priority:(NSOperationQueuePriority)priorty
                                   block:(void (^)(void))block
                         completionBlock:(void (^)(void))completionBlock;

#pragma mark - 异步队列任务分发
/**
 *  @author Abc
 *
 *  分发到异步队列中一个任务
 *
 *  @param block block
 */
+ (void)dispatchInAsyncQueueWithBlock:(SWQueueBlock)block;
+ (void)dispatchInAsyncQueueWithBlock:(SWQueueBlock)block completionBlock:(SWQueueBlock)cblock;
+ (void)dispatchInAsyncQueueWithQueueType:(NSString*)type block:(SWQueueBlock)block;
+ (void)dispatchInAsyncQueueWithQueueType:(NSString*)type block:(SWQueueBlock)block completionBlock:(SWQueueBlock)cblock;
+ (void)dispatchInAsyncQueueWithQueueType:(NSString*)type
                            operationName:(NSString*)operationName
                                 priority:(NSOperationQueuePriority)priorty
                                    block:(void (^)(void))block
                          completionBlock:(void (^)(void))completionBlock;

#pragma mark - 主线程队列任务分发
/**
 *  @author Abc
 *
 *  分发到主线程队列中一个任务
 *
 *  @param block block
 */
+ (void)dispatchInMainQueueWithBlock:(SWQueueBlock)block;
+ (void)dispatchInMainQueueWithBlock:(SWQueueBlock)block completionBlock:(SWQueueBlock)cblock;
+ (void)dispatchInMainQueueWithOperationName:(NSString*)operationName
                                    priority:(NSOperationQueuePriority)priorty
                                       block:(void (^)(void))block
                             completionBlock:(void (^)(void))completionBlock;

@end
