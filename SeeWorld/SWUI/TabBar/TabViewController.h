//
//  TabViewController.h
//  
//
//  Created by abc on 15/4/17.
//  Copyright (c) 2015年 Abc
//

#import <UIKit/UIKit.h>
#import <RongCallLib/RongCallLib.h>
#import "PDVideoWhisperRecordVC.h"
@interface TabViewController : UITabBarController
+ (void)dotAppearance;
- (void)startChat;
- (void)pushChat:(UIViewController *)vc;
- (void)popChatSetting;
- (void)compose;
- (void)composeWithCamera;
- (void)composeWithAlbum;
@end
