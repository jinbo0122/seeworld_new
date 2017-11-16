//
//  SWPostVC.m
//  SeeWorld
//
//  Created by Albert Lee on 17/11/2017.
//  Copyright © 2017 SeeWorld. All rights reserved.
//

#import "SWPostVC.h"
#import "SWSelectLocationVC.h"
@interface SWPostVC ()<SWSelectLocationVCDelegate>

@end

@implementation SWPostVC{
  UIImageView *_avatarView;
  UIView      *_lbsView;
  UIImageView *_iconLBS;
  UILabel     *_lblLBS;
  
  UIView      *_toolView;
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
  
  _toolView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.height-64-iphoneXBottomAreaHeight, self.view.width, 64+iphoneXBottomAreaHeight)];
  _toolView.backgroundColor = [UIColor whiteColor];
  [self.view addSubview:_toolView];
  [_toolView addSubview:[ALLineView lineWithFrame:CGRectMake(0, 0, _toolView.width, 0.5) colorHex:0xe7e6e6]];
  
  _btnCamera = [[UIButton alloc] initWithFrame:CGRectMake(3 , 0, 48, _toolView.height)];
  [_btnCamera setImage:[UIImage imageNamed:@"send_camera_export"] forState:UIControlStateNormal];
  [_toolView addSubview:_btnCamera];
  
  _btnAlbum = [[UIButton alloc] initWithFrame:CGRectMake(_btnCamera.right, 0, 48, _toolView.height)];
  [_btnAlbum setImage:[UIImage imageNamed:@"send_image_export"] forState:UIControlStateNormal];
  [_toolView addSubview:_btnAlbum];
  
  _btnLBS = [[UIButton alloc] initWithFrame:CGRectMake(_btnAlbum.right, 0, 48, _toolView.height)];
  [_btnLBS setImage:[UIImage imageNamed:@"send_location_export"] forState:UIControlStateNormal];
  [_toolView addSubview:_btnLBS];
  
  [_btnLBS addTarget:self action:@selector(onLBSClicked) forControlEvents:UIControlEventTouchUpInside];
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

- (void)refreshLBS{
  
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

@end
