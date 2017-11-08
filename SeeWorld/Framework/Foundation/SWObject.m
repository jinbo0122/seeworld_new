//
//  SWObject.m
//  
//
//  Created by abc on 15/4/17.
//  Copyright (c) 2015年 Abc
//

#import "SWObject.h"

@implementation SWObject

@end

@implementation NSObject (SWObject)
- (void)performSelector:(SEL)aSelector afterDelay:(NSTimeInterval)delay withMultiObjects:(id)object, ...
{
    @autoreleasepool
    {
        NSMethodSignature* signature = [self methodSignatureForSelector:aSelector];
        if (signature)
        {
            NSInvocation* invocation = [NSInvocation invocationWithMethodSignature:signature];
            [invocation setTarget:self];
            [invocation setSelector:aSelector];

            NSUInteger len = signature.numberOfArguments;
            if (len > 2)
            {
                id value = object;

                va_list arguments;
                va_start(arguments, object);
                for (int i = 2; i < len; i++)
                {
                    [invocation setArgument:&value atIndex:i];
                    if (value != nil)
                    {
                        value = va_arg(arguments, id);
                    }
                }
                va_end(arguments);
            }

            [invocation performSelector:@selector(invoke) withObject:nil afterDelay:delay];
        }
    }
}

- (id)performSelector:(SEL)aSelector withMultiObjects:(id)object, ...
{
    id anObject = nil;

    @autoreleasepool
    {
        NSMethodSignature* signature = [self methodSignatureForSelector:aSelector];

        if (signature)
        {

            NSInvocation* invocation = [NSInvocation invocationWithMethodSignature:signature];

            [invocation setTarget:self];
            [invocation setSelector:aSelector];

            NSUInteger len = signature.numberOfArguments;

            if (len > 2)
            {
                id value = object;
                va_list arguments;
                va_start(arguments, object);
                for (int i = 2; i < len; i++)
                {
                    [invocation setArgument:&value atIndex:i];
                    if (value != nil)
                    {
                        value = va_arg(arguments, id);
                    }
                }

                va_end(arguments);
            }

            [invocation invoke];
            if (signature.methodReturnLength == 1)
            {
                [invocation getReturnValue:&anObject];
            }
        }
    }
    return anObject;
}

+ (NSString *)createUUID
{
    CFUUIDRef uuidRef = CFUUIDCreate(NULL);
    CFStringRef uuidStringRef = CFUUIDCreateString(NULL, uuidRef);
    CFRelease(uuidRef);
    
    NSString *uuidValue = (__bridge_transfer NSString *) uuidStringRef;
    uuidValue = [uuidValue lowercaseString];
    uuidValue = [uuidValue stringByReplacingOccurrencesOfString:@"-" withString:@""];
    return uuidValue;
}

@end
