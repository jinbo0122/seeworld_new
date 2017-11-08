//
//  SWOperation.h
//  
//
//  Created by abc on 15/4/13.
//  Copyright (c) 2015年 Abc
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, YOperationBusinessType)
{
    eYOperationBusinessTypeDefault,
    eYOperationBusinessTypeUI,
};

typedef NS_ENUM(NSInteger, YOperationOperationType)
{
    eYOperationOperationTypeDefault,
};

/**
 *  @author Abc
 *
 *  Operation子类,扩展用.添加了opration名称
 */
@interface SWOperation : NSBlockOperation
@property (nonatomic, copy) NSString *operationName;

@property (nonatomic, assign) YOperationBusinessType businessType;
@property (nonatomic, assign) YOperationOperationType operationType;

+ (instancetype)operationWithBlock:(void (^)(void))block
                   completionBlock:(void (^)(void))completionBlock;

+ (instancetype)operationWithName:(NSString *)name
                         priority:(NSOperationQueuePriority)priorty
                            block:(void (^)(void))block
                  completionBlock:(void (^)(void))completionBlock;

+ (instancetype)operationWithName:(NSString *)name
                     businessType:(YOperationBusinessType)bType
                    operationType:(YOperationOperationType)oType
                         priority:(NSOperationQueuePriority)priorty
                            block:(void (^)(void))block
                  completionBlock:(void (^)(void))completionBlock;
@end
