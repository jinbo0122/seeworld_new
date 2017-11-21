//
//  ComposeViewController.m
//  SeeWorld
//
//  Created by liufz on 15/9/14.
//  Copyright (c) 2015年 SeeWorld. All rights reserved.
//

#import "ComposeViewController.h"
#import "GetQiniuTokenApi.h"
#import "GetQiniuTokenResponse.h"
#import "QNUploadManager.h"
#import "QNResponseInfo.h"
#import "SWFoundation.h"
#import "SWFeedComposeAPI.h"
#import "FeedComposeResponse.h"

@interface ComposeViewController ()<UITextViewDelegate>
@property (strong, nonatomic) UIImageView *photoView;
@property (strong, nonatomic) UITextView *txtContent;
@property (strong, nonatomic) UILabel *lblLength;

@end

@implementation ComposeViewController

- (void)viewWillAppear:(BOOL)animated{
  [super viewWillAppear:animated];
  [self.navigationController setNavigationBarHidden:NO];
  [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
  [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
}

- (void)viewDidAppear:(BOOL)animated{
  [super viewDidAppear:animated];
  [self.navigationController setNavigationBarHidden:NO];
  [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
  [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
}

- (void)viewDidLoad{
  [super viewDidLoad];
  [self.navigationController setNavigationBarHidden:NO];
  [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
  [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];


  CGFloat photoWidth = UIScreenHeight<=568?80:180;
  
  _photoView = [[UIImageView alloc] initWithFrame:CGRectMake(23, 17, photoWidth, photoWidth)];
  [self.view addSubview:_photoView];
  _photoView.image = self.resultImage;
  _photoView.width = photoWidth*self.photoImage.size.width/self.photoImage.size.height;
  if (_photoView.width>photoWidth) {
    _photoView.width=photoWidth;
    _photoView.height = photoWidth*self.photoImage.size.height/self.photoImage.size.width;
  }
  
  _txtContent = [[UITextView alloc] initWithFrame:CGRectMake(15, _photoView.bottom+10, UIScreenWidth-30, self.view.height-_photoView.bottom-10)];
  [self.view addSubview:_txtContent];
  _txtContent.textColor = [UIColor colorWithRGBHex:NAV_BAR_COLOR_HEX];
  _txtContent.font = [UIFont systemFontOfSize:16];
  _txtContent.tintColor = [UIColor colorWithRGBHex:NAV_BAR_COLOR_HEX];
  _txtContent.delegate = self;
  _txtContent.backgroundColor = [UIColor colorWithRGBHex:0xffffff];
  [_txtContent becomeFirstResponder];
  
  _lblLength = [UILabel initWithFrame:CGRectMake(0, _txtContent.bottom+5, _txtContent.width, 19)
                                      bgColor:[UIColor clearColor]
                                    textColor:[UIColor colorWithRGBHex:0x8b9cad]
                                         text:@"0/2000"
                                textAlignment:NSTextAlignmentRight font:[UIFont systemFontOfSize:14]];
  [self.view addSubview:_lblLength];
  
  UIBarButtonItem *item = [[UIBarButtonItem alloc]
                           initWithTitle:@"發佈"
                           style:UIBarButtonItemStylePlain
                           target:self
                           action:@selector(compose)];
  [item setTintColor:[UIColor colorWithRGBHex:0x28e4f2]];
  self.navigationItem.rightBarButtonItem = item;
  
  [[NSNotificationCenter defaultCenter]
   addObserver:self
   selector:@selector(keyboardWillShow:)
   name:UIKeyboardWillShowNotification
   object:self.view.window];
  
  [[NSNotificationCenter defaultCenter]
   addObserver:self
   selector:@selector(keyboardWillHide:)
   name:UIKeyboardWillHideNotification
   object:self.view.window];
}

- (void)compose{
  if (self.txtContent.text.length > 2000){
    [[[SWAlertView alloc] initWithTitle:@"發佈內容最大字數為2000字"
                             cancelText:SWStringOkay
                            cancelBlock:^{
                              
                            } okText:nil
                                okBlock:^{
                                  
                                }] show];
    return;
  }
  __weak typeof(self)wSelf = self;
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    [wSelf.resultImage saveToAlbum:@"SeeWorldPlus"];
  });
  [SWHUD showWaiting];
  wSelf.view.userInteractionEnabled = NO;
  GetQiniuTokenApi *api = [[GetQiniuTokenApi alloc] init];
  [api startWithModelClass:[GetQiniuTokenResponse class] completionBlock:^(ModelMessage *message) {
    if (message.isSuccess){
      GetQiniuTokenResponse *resp = message.object;
      NSString *token = resp.data;
      QNUploadManager *manager = [[QNUploadManager alloc] init];
      NSData *imageData = UIImageJPEGRepresentation(wSelf.photoImage, 0.3);
      [manager putData:imageData key:[SWObject createUUID] token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
        if (info.ok && resp[@"key"]){
          NSString *imageURL = [NSString stringWithFormat:@"http:/7xlsvh.com1.z0.glb.clouddn.com/%@",[resp valueForKey:@"key"]];
          SWFeedComposeAPI *api = [[SWFeedComposeAPI alloc] init];
//          api.photoUrl = imageURL;
          api.tags = self.tags;
          api.feedDescription = self.txtContent.text;
          api.latitude = ((NSNumber *)[[NSUserDefaults standardUserDefaults] valueForKey:@"latitude"]).floatValue;
          api.longitude = ((NSNumber *)[[NSUserDefaults standardUserDefaults] valueForKey:@"longitude"]).floatValue;
          
          [api startWithModelClass:[FeedComposeResponse class] completionBlock:^(ModelMessage *message) {
            [SWHUD hideWaiting];
            if (message.isSuccess){
              [self.view endEditing:YES];
              [SWHUD showCommonToast:@"發佈成功"];
              [[NSNotificationCenter defaultCenter] postNotificationName:@"hidePickerController" object:nil];
            }else{
              wSelf.view.userInteractionEnabled = YES;
              [SWHUD showCommonToast:(message.message.length == 0? @"發佈失败":message.message)];
            }
          }];
        }else{
          wSelf.view.userInteractionEnabled = YES;
          [SWHUD hideWaiting];
          [SWHUD showCommonToast:(message.message.length == 0? @"發佈失败":message.message)];
        }
      } option:nil];
    }else{
      wSelf.view.userInteractionEnabled = YES;
      [SWHUD hideWaiting];
      [SWHUD showCommonToast:(message.message.length == 0? @"發佈失败":message.message)];
    }
  }];
  
}

//键盘升起时动画
- (void)keyboardWillShow:(NSNotification*)notif
{
  CGRect keyboardEndFrameWindow;
  [[notif.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardEndFrameWindow];
  CATransition* animation = [CATransition animation];
  animation.type = kCATransitionFade;
  animation.duration = 0.25;
  __weak typeof(self)wSelf = self;
  [UIView animateWithDuration:0.25 animations:^{
    wSelf.txtContent.height = wSelf.view.height - wSelf.photoView.bottom-10-CGRectGetHeight(keyboardEndFrameWindow)-30;
    wSelf.lblLength.top = wSelf.txtContent.bottom+5;
  } completion:nil];
}

//键盘关闭时动画
- (void)keyboardWillHide:(NSNotification*)notif
{
  CATransition* animation = [CATransition animation];
  animation.type = kCATransitionFade;
  animation.duration = 0.25;
  __weak typeof(self)wSelf = self;
  [UIView animateWithDuration:0.25 animations:^{
    wSelf.txtContent.height = wSelf.view.height - wSelf.photoView.bottom-10;
    wSelf.lblLength.top = wSelf.txtContent.bottom+5;
  } completion:nil];
}

- (void)textViewDidChange:(UITextView *)textView
{
  _lblLength.text = [NSString stringWithFormat:@"%lu/2000", (unsigned long)textView.text.length];
  //根据大小改变颜色
  NSInteger num = 2000 - textView.text.length;
  if (num < 0){
    _lblLength.textColor = [UIColor hexChangeFloat:@"F4453C"];
  }else {
    _lblLength.textColor = [UIColor hexChangeFloat:@"8b9cad"];
  }
}

@end
