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
#define SWTabIndexHome 0
#define SWTabIndexExplore 1
#define SWTabIndexMsg 2
#define SWTabIndexNotice 3
#define SWTabIndexMe 4

@interface TabViewController : UITabBarController
+ (void)dotAppearance;
- (void)startChat;
- (void)pushChat:(UIViewController *)vc;
- (void)popChatSetting;
- (void)compose;
- (void)composeWithLBS;
- (void)composeWithCamera;
- (void)composeWithAlbum;
@end
