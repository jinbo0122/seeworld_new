//
//  
//
//  Created by abc on 15/4/18.
//  Copyright (c) 2015年 Abc
//

#import "SWObject.h"
#import "SWManager.h"

/**
 *  @author Abc
 *
 *  组件的管理中心,统一管理组件通用消息的触发
 */
@interface SWManageCenter : SWObject
+ (SWManageCenter *)defaultCenter;

/**
 *  @author Abc
 *
 *  注册一个组件到管理中心
 *
 *  @param manager 组件
 */
- (void)registerManager:(SWManager<SWManager> *)manager;

/**
 *  @author Abc
 *
 *  反注册
 */
- (void)unregisterAllManager;

/**
 *  @author Abc
 *
 *  App登录成功后调用,用来触发所有组件的:appDidLogin:方法
 *
 *  @param loginInfo 登录成功信息
 */
- (void)notifyAppLogined:(NSDictionary *)loginInfo;

/**
 *  @author Abc
 *
 *  App注销后调用,用来触发所有组件的appDidLogout方法
 */
- (void)notifyAppLogouted;
@end
