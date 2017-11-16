//
//  SWPostVC.m
//  SeeWorld
//
//  Created by Albert Lee on 17/11/2017.
//  Copyright © 2017 SeeWorld. All rights reserved.
//

#import "SWPostVC.h"
#import "SWPostPhotoView.h"
#import "SWSelectLocationVC.h"
@interface SWPostVC ()<SWSelectLocationVCDelegate,UITextViewDelegate>
@property (strong, nonatomic) UITextView  *txtContent;
@property (strong, nonatomic) UILabel     *lblLength;
@property (strong, nonatomic) UIView      *toolView;
@property (nonatomic, strong) SWPostPhotoView *photoView;
@end

@implementation SWPostVC{
  UIImageView *_avatarView;
  UIView      *_lbsView;
  UIImageView *_iconLBS;
  UILabel     *_lblLBS;
  
  UILabel     *_lblPlaceHolder;
  
  UIButton    *_btnCamera;
  UIButton    *_btnAlbum;
  UIButton    *_btnLBS;
  
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.navigationItem.leftBarButtonItem = [UIBarButtonItem loadLeftBarButtonItemWithTitle:SWStringCancel
                                                                                    color:[UIColor colorWithRGBHex:0x55acef]
                                                                                     font:[UIFont systemFontOfSize:16]
                                                                                   target:self
                                                                                   action:@selector(onCancel)];
  self.view.backgroundColor = [UIColor whiteColor];
  self.navigationItem.titleView = [[ALTitleLabel alloc] initWithTitle:@"發狀態" color:[UIColor colorWithRGBHex:NAV_BAR_COLOR_HEX]];
  [self rightBar];
  _avatarView = [[UIImageView alloc] initWithFrame:CGRectMake(10, iOSNavHeight+10, 45, 45)];
  _avatarView.layer.masksToBounds = YES;
  _avatarView.layer.cornerRadius = _avatarView.height/2.0;
  [_avatarView sd_setImageWithURL:[NSURL URLWithString:[[SWConfigManager sharedInstance].user.picUrl stringByAppendingString:@"-avatar210"]]];
  [self.view addSubview:_avatarView];
  
  _lbsView = [[UIView alloc] initWithFrame:CGRectMake(_avatarView.right+24, _avatarView.top, self.view.width-10-24-_avatarView.right, _avatarView.height)];
  _iconLBS = [[UIImageView alloc] initWithFrame:CGRectMake(0, (_lbsView.height-14)/2.0, 12, 14)];
  _iconLBS.image = [UIImage imageNamed:@"send_location"];
  [_lbsView addSubview:_iconLBS];
  
  _lblLBS = [UILabel initWithFrame:CGRectZero
                           bgColor:[UIColor clearColor]
                         textColor:[UIColor colorWithRGBHex:0x191d28]
                              text:@"" textAlignment:NSTextAlignmentLeft
                              font:[UIFont systemFontOfSize:17]];
  [_lbsView addSubview:_lblLBS];
  [self.view addSubview:_lbsView];
  
  _lbsView.hidden = YES;
  
  
  _txtContent = [[UITextView alloc] initWithFrame:CGRectMake(15, _avatarView.bottom+15, UIScreenWidth-30, 50)];
  [self.view addSubview:_txtContent];
  _txtContent.textColor = [UIColor colorWithRGBHex:0x191d28];
  _txtContent.font = [UIFont systemFontOfSize:18];
  _txtContent.tintColor = [UIColor colorWithRGBHex:0x191d28];
  _txtContent.delegate = self;
  _txtContent.backgroundColor = [UIColor colorWithRGBHex:0xffffff];
  [_txtContent becomeFirstResponder];
  
  _lblPlaceHolder = [UILabel initWithFrame:CGRectMake(25, _txtContent.top + 7, 0, 0)
                                   bgColor:[UIColor clearColor]
                                 textColor:[UIColor colorWithRGBHex:0x667887 alpha:0.7]
                                      text:@"這一刻的想法..."
                             textAlignment:NSTextAlignmentLeft
                                      font:[UIFont systemFontOfSize:18]];
  [_lblPlaceHolder sizeToFit];
  [self.view addSubview:_lblPlaceHolder];
  
  _lblLength = [UILabel initWithFrame:CGRectMake(0, _txtContent.bottom+5, _txtContent.width, 19)
                              bgColor:[UIColor clearColor]
                            textColor:[UIColor colorWithRGBHex:0x8b9cad]
                                 text:@"0/2000"
                        textAlignment:NSTextAlignmentRight font:[UIFont systemFontOfSize:14]];
  [self.view addSubview:_lblLength];
  
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
  
  UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onNothing)];
  [self.view addGestureRecognizer:tapGesture];
  
  
  _toolView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.height-64-iphoneXBottomAreaHeight, self.view.width, 64+iphoneXBottomAreaHeight)];
  _toolView.backgroundColor = [UIColor whiteColor];
  [self.view addSubview:_toolView];
  [_toolView addSubview:[ALLineView lineWithFrame:CGRectMake(0, 0, _toolView.width, 0.5) colorHex:0xe7e6e6]];
  
  _btnCamera = [[UIButton alloc] initWithFrame:CGRectMake(3 , 0, 48, _toolView.height-iphoneXBottomAreaHeight)];
  [_btnCamera setImage:[UIImage imageNamed:@"send_camera_export"] forState:UIControlStateNormal];
  [_toolView addSubview:_btnCamera];
  
  _btnAlbum = [[UIButton alloc] initWithFrame:CGRectMake(_btnCamera.right, 0, 48, _btnCamera.height)];
  [_toolView addSubview:_btnAlbum];
  
  _btnLBS = [[UIButton alloc] initWithFrame:CGRectMake(_btnAlbum.right, 0, 48, _btnCamera.height)];
  [_btnLBS setImage:[UIImage imageNamed:@"send_location_export"] forState:UIControlStateNormal];
  [_toolView addSubview:_btnLBS];
  
  [_btnLBS addTarget:self action:@selector(onLBSClicked) forControlEvents:UIControlEventTouchUpInside];
  
  if (_images.count) {
    [_btnAlbum setImage:[UIImage imageNamed:@"send_image"] forState:UIControlStateNormal];
    [self initImages];
  }else{
    [_btnAlbum setImage:[UIImage imageNamed:@"send_image_export"] forState:UIControlStateNormal];
  }
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark Custom
- (void)rightBar{
  BOOL enable = NO;
  if (enable) {
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem loadBarButtonItemWithTitle:@"發佈"
                                                                                   color:[UIColor colorWithRGBHex:0x69b4f4]
                                                                                    font:[UIFont systemFontOfSize:16]
                                                                                  target:self
                                                                                  action:@selector(onPost)];
  }else{
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem loadBarButtonItemWithTitle:@"發佈"
                                                                                   color:[UIColor colorWithRGBHex:0xc4c5c7]
                                                                                    font:[UIFont systemFontOfSize:16]
                                                                                  target:self
                                                                                  action:@selector(onNothing)];
  }
}

- (void)onNothing{
  [self.view endEditing:YES];
}

- (void)onPost{
  
}

- (void)onCancel{
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onLBSClicked{
  SWSelectLocationVC *vc = [[SWSelectLocationVC alloc] init];
  vc.delegate = self;
  UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
  [self presentViewController:nav animated:YES completion:nil];
}

- (void)initImages{
  _photoView = [[SWPostPhotoView alloc] initWithFrame:CGRectMake(0, _txtContent.bottom+20, self.view.width, 260)];
  [_photoView refreshWithPhotos:_images];
  [self.view addSubview:_photoView];
}

#pragma mark Location Delegate
- (void)selectLocationVCDidReturnWithLocation:(CLLocation *)location placemark:(CLPlacemark *)placemark{
  if (placemark) {
    _lblLBS.text = placemark.locality?placemark.locality:(placemark.administrativeArea?placemark.administrativeArea:placemark.country);
    [_lblLBS sizeToFit];
    _lblLBS.left = _iconLBS.right+7;
    _lblLBS.top = (_lbsView.height-_lblLBS.height)/2.0;
    _lbsView.hidden = NO;
    [_btnLBS setImage:[UIImage imageNamed:@"send_location"] forState:UIControlStateNormal];
  }else{
    _lblLBS.text = @"";
    _lbsView.hidden = YES;
    [_btnLBS setImage:[UIImage imageNamed:@"send_location_export"] forState:UIControlStateNormal];
  }
  [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark Text
- (void)dealloc{
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}
//键盘升起时动画
- (void)keyboardWillShow:(NSNotification*)notif{
  CGRect keyboardEndFrameWindow;
  [[notif.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardEndFrameWindow];
  CATransition* animation = [CATransition animation];
  animation.type = kCATransitionFade;
  animation.duration = 0.25;
  __weak typeof(self)wSelf = self;
  [UIView animateWithDuration:0.25 animations:^{
    wSelf.toolView.bottom = CGRectGetMinY(keyboardEndFrameWindow)+iphoneXBottomAreaHeight;
  } completion:nil];
}

//键盘关闭时动画
- (void)keyboardWillHide:(NSNotification*)notif{
  CATransition* animation = [CATransition animation];
  animation.type = kCATransitionFade;
  animation.duration = 0.25;
  __weak typeof(self)wSelf = self;
  [UIView animateWithDuration:0.25 animations:^{
    wSelf.toolView.bottom = wSelf.view.height;
  } completion:nil];
}

- (void)textViewDidChange:(UITextView *)textView
{
  _lblPlaceHolder.hidden = textView.text.length;
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
