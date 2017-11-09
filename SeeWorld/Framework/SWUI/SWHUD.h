//
//  SWHUD.h
//  Component
//
//  Created by  on 15/5/13.
//  
//

#import <UIKit/UIKit.h>

typedef void (^HiddenToast)(void);

@interface SWHUD :NSObject

/*********************************************************************
 函数名称 : showLogingToast
 函数描述 : 显示登录小提示
 参数 : 提示信息  inview: 在上面view上面
 返回值 : N/A
 作者 : XiongChen
 *********************************************************************/
+ (void)showLogingToast:(NSString *)toastStr inView:(UIView *)inView;

/*********************************************************************
 函数名称 : showCommonToast
 函数描述 : 公用小提示
 参数 : 提示信息  inview: 在上面view上面
 返回值 : N/A
 作者 : XiongChen
 *********************************************************************/
+ (void)showCommonToast:(NSString *)toastStr inView:(UIView *)inView showTime:(NSTimeInterval)minShowTime completionBlock:(HiddenToast)block;
+ (void)showCommonToast:(NSString *)toastStr inView:(UIView *)inView;
+ (void)showCommonToast:(NSString *)toastStr;
+ (void)showCommonToast:(NSString *)toastStr completionBlock:(HiddenToast)block;


/*********************************************************************
 函数名称 : showWaiting
 函数描述 : 显示等待框
 参数 : 在上面view上面
 返回值 : N/A
 作者 : XiongChen
 *********************************************************************/
+ (void)showWaiting:(UIView *)inView;
+ (void)showWaiting;
+ (void)showWaitingWithText:(NSString *)text;
+ (void)showWaiting:(UIView *)inView text:(NSString *)text;

/*********************************************************************
 函数名称 : hiddenProgressHUD
 函数描述 : 隐藏view上所有弹框
 参数 : 在上面view上面
 返回值 : N/A
 作者 : XiongChen
 *********************************************************************/
+ (void)hideWaiting:(UIView *)inView;
+ (void)hideWaiting;

@end
