//
//  SWUtility.m
//  SeeWorld
//
//  Created by Albert Lee on 1/4/16.
//  Copyright © 2016 SeeWorld. All rights reserved.
//

#import "SWUtility.h"
#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>
#define SWTagWindowSubview 100000
@implementation SWUtility
+ (void)removeWindowSubview{
  for (UIView *view in [UIApplication sharedApplication].delegate.window.subviews) {
    if (view.tag==SWTagWindowSubview) {
      [view removeFromSuperview];
    }
  }
}

+ (void)addWindowSubview:(UIView *)view{
  view.tag = SWTagWindowSubview;
  AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
  [appDelegate.window addSubview:view];
}

+ (BOOL)isViewOnMainWindow:(UIView *)view{
  for (UIView *subview in [UIApplication sharedApplication].delegate.window.subviews) {
    if ([subview isEqual:view]) {
      return YES;
    }
  }
  return NO;
}

+ (UIView *)isViewOfClassOnMainView:(__unsafe_unretained Class)className{
  for (UIView *subview in [UIApplication sharedApplication].delegate.window.subviews) {
    if ([subview isKindOfClass:className]) {
      return subview;
    }
  }
  return nil;
}

+ (BOOL)checkCameraWithBlock:(COMPLETION_BLOCK)block{
  BOOL isCameraDeviceAvailable = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
  
  if (!isCameraDeviceAvailable) {
    [PDProgressHUD showTip:@"此設備沒有相機"];
    return NO;
  }
  
  AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
  if (status == AVAuthorizationStatusAuthorized) {
    return YES;
  }else if (status == AVAuthorizationStatusNotDetermined){
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo
                             completionHandler:^(BOOL granted) {
                               dispatch_async(dispatch_get_main_queue(), ^{
                                 if(granted){
                                   if (block) {
                                     block();
                                   }
                                 }else{
                                   [SWUtility checkCameraWithBlock:nil];
                                 }
                               });
                             }];
    return NO;
  }else{
    [[[UIAlertView alloc] initWithTitle:nil
                                message:@"請在手機系統的設置 > 隱私 > 照片中，允許SeeWorld+訪問你的手機相機。"
                       cancelButtonItem:
      [RIButtonItem itemWithLabel:SWStringOkay
                           action:^{
                             [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                           }]
                       otherButtonItems:nil] show];
    return NO;
  }
}

+ (void)checkMicWithBlock:(COMPLETION_BLOCK)block{
  [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
    dispatch_async(dispatch_get_main_queue(), ^{
      if (granted) {
        if (block) {
          block();
        }
      }
      else {
        [[[UIAlertView alloc] initWithTitle:nil
                                    message:@"請在iPhone的\"設置-隱私-麥克風\"選項中，允許抱抱訪問你的手機麥克風"
                           cancelButtonItem:
          [RIButtonItem itemWithLabel:SWStringOkay
                               action:^{
                                 [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                               }]
                           otherButtonItems:nil] show];
      }
    });
  }];
}
@end
