//
//  SWObject.h
//  
//
//  Created by abc on 15/4/17.
//  Copyright (c) 2015年 Abc
//

#import <Foundation/Foundation.h>

/**
 *  @author Abc
 *
 *  NSObject 框架基类,添加扩展或者公用方法
 */
@interface SWObject : NSObject

@end

@interface NSObject (SWObject)

/**
 *  @author Abc
 *
 *  performSelector 附带多参数
 *
 *  @param aSelector Selector
 *  @param object    参数
 *
 *  @return         执行结果
 */
- (id)performSelector:(SEL)aSelector withMultiObjects:(id)object, ...;

/**
 *  @author Abc
 *
 *  performSelector 附带多参数
 *
 *  @param aSelector Selector
 *  @param delay     延迟执行时间
 *  @param object    参数
 */
- (void)performSelector:(SEL)aSelector afterDelay:(NSTimeInterval)delay withMultiObjects:(id)object, ...;

+ (NSString *)createUUID;
@end
