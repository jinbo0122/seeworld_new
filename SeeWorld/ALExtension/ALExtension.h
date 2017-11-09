//
//  ALExtension.h
//  ALExtension
//
//  Created by Albert Lee on 7/11/14.
//  Copyright (c) 2014 Albert Lee. All rights reserved.
//

#ifndef pandora_ALExtension_h
#define pandora_ALExtension_h

#define UIScreenWidth  [UIScreen mainScreen].bounds.size.width
#define UIScreenHeight [UIScreen mainScreen].bounds.size.height
#define UIScreenScale  (NSInteger)[UIScreen mainScreen].scale

#define is35InchDevice [UIDevice currentDevice].screenType==UIDEVICE_35INCH
#define is4InchDevice  [UIDevice currentDevice].screenType==UIDEVICE_4INCH
#define is55InchDevice [UIDevice currentDevice].screenType==UIDEVICE_5_5_INCH
#define is47InchDevice [UIDevice currentDevice].screenType==UIDEVICE_4_7_INCH
#define is58InchDevice ([UIDevice currentDevice].screenType==UIDEVICE_5_8_INCH)
#define is320WidthDevice          (UIScreenWidth==320)
#define isRunningOnIOS8           [[UIDevice currentDevice] isIOS8]
#define isRunningOnIOS9           [[UIDevice currentDevice] isIOS9]
#define isRunningOnIOS10          [[UIDevice currentDevice] isIOS10]
#define isRunningOnIOS11          [[UIDevice currentDevice] isIOS11]
#define iOS7NavHeight             (64)
#define iOS11NavHeight            (44)
#define iOSNavHeight              (is58InchDevice?88:64)
#define iOSStatusBarHeight        (is58InchDevice?44:20)
#define iphoneXBottomAreaHeight   (is58InchDevice?34:0)
#define iOSTopHeight              (is58InchDevice?24:0)

#define SWWeixinAPI @"wxcddd6d0e13441065"
#define SWWeiboAPI @"3615135038"
#define SWWeiboRedirectURL @"http://open.weibo.com/apps/3615135038/privilege/oauth"

#define isFakeDataOn NO
typedef void(^COMPLETION_BLOCK)(void);

#endif
