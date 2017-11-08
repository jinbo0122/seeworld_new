//
//  SWHUD.m
//  Component
//
//  Created by  on 15/5/13.
//  
//

#import "SWHUD.h"
#import "SWDefine.h"
#import "MBProgressHUD.h"

#define kDefaultWaitingText @"加载中..."

@implementation SWHUD

+ (void)showLogingToast:(NSString *)toastStr inView:(UIView *)inView
{
    if ([MBProgressHUD HUDForView:inView])
    {
        return;
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 40, inView.frame.size.width, 50)];
    [inView addSubview:view];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.labelText = toastStr;
    hud.cornerRadius = 0;
    hud.minSize = CGSizeMake(inView.frame.size.width, 50);
//    hud.yOffset = 50+40-([UIScreen mainScreen].bounds.size.height/2);
    hud.color = [UIColor redColor];
    hud.labelFont = SWFONT(12);
    hud.opacity = 0.8;
    hud.minShowTime = 2;//修改时间
    
    [hud showAnimated:YES whileExecutingBlock:^{
        
    } completionBlock:^{
        [view removeFromSuperview];
    }];
}

+ (void)showCommonToast:(NSString *)toastStr completionBlock:(HiddenToast)block
{
    [self showCommonToast:toastStr inView:[UIApplication sharedApplication].keyWindow showTime:1 completionBlock:block];
}

+ (void)showCommonToast:(NSString *)toastStr
{
    [self showCommonToast:toastStr inView:[UIApplication sharedApplication].keyWindow];
}

+ (void)showCommonToast:(NSString *)toastStr inView:(UIView *)inView
{
    [self showCommonToast:toastStr inView:inView showTime:1 completionBlock:nil];
}

+ (void)showCommonToast:(NSString *)toastStr inView:(UIView *)inView showTime:(NSTimeInterval)minShowTime completionBlock:(HiddenToast)block
{
    if (nil == toastStr || 0 == toastStr.length)
    {
        return;
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:inView animated:YES];
    
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.labelText = toastStr;
    hud.minSize = CGSizeMake(inView.frame.size.width/2, 55);
    hud.labelFont = SWFONT(16);
    hud.opacity = 0.8;
    hud.margin = 10;
    hud.minShowTime = minShowTime;//修改时间
    hud.userInteractionEnabled = NO;
    
    [hud showAnimated:YES whileExecutingBlock:^{
        
    } completionBlock:^{
        [hud removeFromSuperview];
        if (block) {
            block();
        }
    }];
}

+ (void)showWaiting
{
    [self showWaiting:[UIApplication sharedApplication].keyWindow];
}

+ (void)showWaiting:(UIView *)inView
{
    [self showWaiting:inView text:kDefaultWaitingText];
}

+ (void)showWaitingWithText:(NSString *)text
{
   [self showWaiting:[UIApplication sharedApplication].keyWindow text:text];
}

+ (void)showWaiting:(UIView *)inView text:(NSString *)text
{
    if ([MBProgressHUD HUDForView:inView])
    {
        return;
    }
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:inView];
    [inView addSubview:HUD];
    
    [HUD show:YES];
}

+ (void)hideWaiting
{
   [self hideWaiting:[UIApplication sharedApplication].keyWindow];
}

+ (void)hideWaiting:(UIView *)inView
{
    [MBProgressHUD hideAllHUDsForView:inView animated:NO];
}

@end
