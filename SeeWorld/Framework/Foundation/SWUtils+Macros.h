//
//  SWUtils+Macros.h
//  
//
//  Created by abc on 15/4/13.
//  Copyright (c) 2015年 Abc
//

#ifndef _SWUtils_Macros_h
#define _SWUtils_Macros_h

//定义弱引用宏
#ifndef WS
#define WS(weakSelf) __weak __typeof(&*self) weakSelf = self;
#endif

//定义强引用宏
#ifndef SS
#define SS(strongSelf, weakSelf) __strong __typeof(&*self) strongSelf = weakSelf;
#endif
//
////声明和定义单类宏
//#undef AS_SINGLETON
//#define AS_SINGLETON(__class)    \
//-(__class *) sharedInstance; \
//+(__class *) sharedInstance;
//
//#undef DEF_SINGLETON
//#define DEF_SINGLETON(__class)                                                   \
//-(__class *) sharedInstance                                                  \
//{                                                                            \
//return [__class sharedInstance];                                         \
//}                                                                            \
//+(__class *) sharedInstance                                                  \
//{                                                                            \
//static dispatch_once_t once;                                             \
//static __class *__singleton__;                                           \
//dispatch_once(&once, ^{ __singleton__ = [[[self class] alloc] init]; }); \
//return __singleton__;                                                    \
//}
//#endif



//声明和定义单类宏
#undef AS_SINGLETON
#define AS_SINGLETON \
-(instancetype) sharedInstance; \
+(instancetype) sharedInstance;

#undef DEF_SINGLETON
#if __has_feature(objc_arc)
#define DEF_SINGLETON \
static id instance; \
+ (instancetype)allocWithZone:(struct _NSZone *)zone { \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
instance = [super allocWithZone:zone]; \
}); \
return instance; \
} \
-(instancetype) sharedInstance  \
{ \
return [[self class] sharedInstance];\
}\
+ (instancetype)sharedInstance { \
    static dispatch_once_t onceToken; \
    dispatch_once(&onceToken, ^{ \
        instance = [[self alloc] init]; \
    }); \
    return instance; \
} \
- (id)copyWithZone:(NSZone *)zone { \
    return instance; \
}
#else

#define DEF_SINGLETON(className) \
static id instance; \
+ (instancetype)allocWithZone:(struct _NSZone *)zone { \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
instance = [super allocWithZone:zone]; \
}); \
return instance; \
} \
-(instancetype) sharedInstance  \
{ \
return [[self class] sharedInstance];\
}\
+ (instancetype)sharedInstance { \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
instance = [[self alloc] init]; \
}); \
return instance; \
} \
- (id)copyWithZone:(NSZone *)zone { \
return instance; \
} \
- (oneway void)release {} \
- (instancetype)retain {return instance;} \
- (instancetype)autorelease {return instance;} \
- (NSUInteger)retainCount {return ULONG_MAX;}

#endif




//Safe String
#define SStr(str) (nil == str? @"":str)
#define D2IStr(ddata) ([NSString stringWithFormat:@"%ld",(long)(ddata)])

#define COLOR_494949                [UIColor colorWithRed:73.0/255.0 green:73.0/255.0 blue:73.0/255.0 alpha:1.0]
#define COLOR_acacac                [UIColor colorWithRed:172.0/255.0 green:172.0/255.0 blue:172.0/255.0 alpha:1.0]
#define COLOR_f4453c                [UIColor colorWithRed:244.0/255.0 green:69.0/255.0 blue:60.0/255.0 alpha:1.0]
#define COLOR_f0f1f3                [UIColor colorWithRed:240.0/255.0 green:241.0/255.0 blue:243.0/255.0 alpha:1.0]
#define COLOR_c7c8c9                [UIColor colorWithRed:199.0/255.0 green:200.0/255.0 blue:201.0/255.0 alpha:1.0]
#define COLOR_1d96d7                [UIColor colorWithRed:29.0/255.0 green:150.0/255.0 blue:215.0/255.0 alpha:1.0]
#define COLOR_eeeeee                [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1.0]
#define COLOR_e7e7e7                [UIColor colorWithRed:231.0/255.0 green:231.0/255.0 blue:231.0/255.0 alpha:1.0]
#define COLOR_ffffff                [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0]
#define COLOR_000000                [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0]

#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width

#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

// 设备版本判断
#define IOS8 [[UIDevice currentDevice].systemVersion doubleValue] >= 8.0
#define IOS7 [[UIDevice currentDevice].systemVersion intValue] == 7

#endif
