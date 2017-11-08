//
//  SWManager.h
//  
//
//  Created by abc on 15/4/17.
//  Copyright (c) 2015年 Abc
//

#import "SWObject.h"
@protocol SWManager <NSObject>
@required
/**
 *  @author Abc
 *
 *  资源初始化,注册到ManagerCenter时自动调用.
 */
- (void)initSource;

/**
 *  @author Abc
 *
 *  清理资源,反注册时自动调用.
 */
- (void)clearSource;

/**
 *  @author Abc
 *
 *  用户登录App成功
 *
 *  @param loginInfo 登录信息
 */
- (void)appDidLogin:(NSDictionary *)loginInfo;

/**
 *  @author Abc
 *
 *  用户注销
 */
- (void)appDidLogout;

@optional

/**
 *  @author Abc
 *
 *  网络变化监听(Reachability)
 *
 *  @param notification Reachability监听通知.
 */
- (void)netStateDidChange:(NSNotification *)notification;
@end

/**
 *  @author Abc
 *
 *  业务管理类基类,所有业务组件管理类继承此类
 */
@interface SWManager : SWObject <SWManager>
/**
 *  @author Abc
 *
 *  封装了通过主线程发送通知的方法.
 *
 */
- (void)postNotificationOnMainThreadName:(NSString *)aName
                                  object:(id)anObject
                                userInfo:(NSDictionary *)aUserInfo;

/**
 *  @author Abc
 *
 *  发送普通通知
 */
- (void)postNotificationName:(NSString *)aName
                      object:(id)anObject
                    userInfo:(NSDictionary *)aUserInfo;
@end
