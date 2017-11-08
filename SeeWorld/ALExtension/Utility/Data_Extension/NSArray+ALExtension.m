//
//  NSArray+Plist.m
//  KKShopping
//
//  Created by Albert Lee on 6/8/13.
//  Copyright (c) 2013 KiDulty. All rights reserved.
//

#import "NSArray+ALExtension.h"

@implementation NSArray(ALExtension)
-(BOOL)writeToPlistFileSync:(NSString*)filename{
  if (self==nil||(
                  (![self isKindOfClass:[NSArray class]])&&
                  (![self isKindOfClass:[NSMutableArray class]]))||
      [self count]==0) {
    return NO;
  }
  BOOL didWriteSuccessfull = NO;
  NSData * data = [NSKeyedArchiver archivedDataWithRootObject:self];
  NSArray * paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
  NSString * documentsDirectory = [paths objectAtIndex:0];
  NSString * path = [[documentsDirectory stringByAppendingPathComponent:@"Caches"] stringByAppendingPathComponent:filename];
  didWriteSuccessfull = [data writeToFile:path atomically:YES];
  return didWriteSuccessfull;
}

+(NSArray*)readFromPlistFile:(NSString*)filename{
  NSArray * paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
  NSString * documentsDirectory = [paths objectAtIndex:0];
  NSString * path = [[documentsDirectory stringByAppendingPathComponent:@"Caches"] stringByAppendingPathComponent:filename];
  NSData * data = [NSData dataWithContentsOfFile:path];
  if(!data){
    return @[];
  }
  else{
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
  }
}

+(void)removePlistFile:(NSString*)filename
{
  NSArray * paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
  NSString * documentsDirectory = [paths objectAtIndex:0];
  NSString * path = [[documentsDirectory stringByAppendingPathComponent:@"Caches"] stringByAppendingPathComponent:filename];
  [[[NSFileManager alloc] init] removeItemAtPath:path error:nil];
}

- (id)safeObjectAtIndex:(NSUInteger)index{
  if ( index >= self.count || ![self isKindOfClass:[NSArray class]])
    return nil;
  
  return [self objectAtIndex:index];
}

- (id)safeDicObjectAtIndex:(NSUInteger)index{
  if ( index >= self.count ||!self || ![self isKindOfClass:[NSArray class]])
    return [NSDictionary dictionary];
  
  if ([[self objectAtIndex:index] isKindOfClass:[NSDictionary class]]) {
    return [self objectAtIndex:index];
  }
  else{
    return [NSDictionary dictionary];
  }
}

- (id)safeArrayObjectAtIndex:(NSUInteger)index{
  if ( index >= self.count || ![self isKindOfClass:[NSArray class]])
    return [NSArray array];
  
  if ([[self objectAtIndex:index] isKindOfClass:[NSArray class]]) {
    return [self objectAtIndex:index];
  }
  else{
    return [NSArray array];
  }
}

- (id)safeNumberObjectAtIndex:(NSUInteger)index{
  if ( index >= self.count || ![self isKindOfClass:[NSArray class]])
    return @0;
  
  if ([[self objectAtIndex:index] isKindOfClass:[NSNumber class]]) {
    return [self objectAtIndex:index];
  }
  else{
    return @0;
  }
}

- (id)safeStringObjectAtIndex:(NSUInteger)index{
  if ( index >= self.count || ![self isKindOfClass:[NSArray class]])
    return @"";
  
  if ([[self objectAtIndex:index] isKindOfClass:[NSString class]]) {
    return [self objectAtIndex:index];
  }
  else{
    return @"";
  }
}

-(NSData*)data
{
  NSData* data = [NSKeyedArchiver archivedDataWithRootObject:self];
  return data;
}
@end

@implementation NSMutableArray (ALExtension)
- (void)safeAddObject:(id)anObject
{
  if (anObject) {
    @synchronized(self){
      [self addObject:anObject];
    }
  }
}
-(bool)safeInsertObject:(id)anObject atIndex:(NSUInteger)index
{
  if ( index >= self.count && index != 0)
  {
    return NO;
  }
  @synchronized(self){
    [self insertObject:anObject atIndex:index];
  }
  return YES;
}

-(bool)safeRemoveObjectAtIndex:(NSUInteger)index
{
  if ( index >= self.count )
  {
    return NO;
  }
  @synchronized(self){
    [self removeObjectAtIndex:index];
  }
  return YES;
  
}
-(bool)safeReplaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject
{
  if ( index >= self.count )
  {
    return NO;
  }
  @synchronized(self){
    [self replaceObjectAtIndex:index withObject:anObject];
  }
  return YES;
}
@end
