//
//  SWManager.m
//  
//
//  Created by abc on 15/4/17.
//  Copyright (c) 2015年 Abc
//

#import "SWManager.h"
#import "SWManagerCenter.h"
#import "SWQueue.h"

@implementation SWManager

- (instancetype)init
{
    if (self = [super init])
    {
        //初始化时自动注册到Center
        [[SWManageCenter defaultCenter] registerManager:self];
    }
    return self;
}

- (void)postNotificationOnMainThreadName:(NSString *)aName
                                  object:(id)anObject
                                userInfo:(NSDictionary *)aUserInfo
{
    [SWQueue dispatchInMainQueueWithBlock:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:aName
                                                            object:anObject
                                                          userInfo:aUserInfo];
    }];
}

- (void)postNotificationName:(NSString *)aName
                      object:(id)anObject
                    userInfo:(NSDictionary *)aUserInfo
{
    [[NSNotificationCenter defaultCenter] postNotificationName:aName
                                                        object:anObject
                                                      userInfo:aUserInfo];
}
#pragma makr - ManagerProtocol
- (void)initSource
{ //子类业务操作
}
- (void)clearSource
{ //子类业务操作
}
- (void)appDidLogin:(NSDictionary *)loginInfo
{ //子类业务操作
}
- (void)appDidLogout
{ //子类业务操作
}

@end
