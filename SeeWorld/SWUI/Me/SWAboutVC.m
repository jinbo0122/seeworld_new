//
//  SWAboutVC.m
//  SeeWorld
//
//  Created by Albert Lee on 5/16/16.
//  Copyright © 2016 SeeWorld. All rights reserved.
//

#import "SWAboutVC.h"
#import "SWAgreementVC.h"
@interface SWAboutVC ()

@end

@implementation SWAboutVC

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor colorWithRGBHex:0xe8edf3];
  [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
  self.navigationItem.titleView = [[ALTitleLabel alloc] initWithTitle:@"關於" color:[UIColor colorWithRGBHex:NAV_BAR_COLOR_HEX]];
  
  UIImageView *logo = [[UIImageView alloc] initWithFrame:CGRectMake(0, iOSNavHeight, UIScreenWidth, UIScreenWidth/2.0)];
  logo.image = [UIImage imageNamed:@"setting_about_img"];
  [self.view addSubview:logo];
  
  UILabel *lblIntro = [UILabel initWithFrame:CGRectMake(10, logo.bottom+20, UIScreenWidth-20, UIScreenHeight-logo.bottom-112)
                                         bgColor:[UIColor clearColor]
                                       textColor:[UIColor colorWithRGBHex:0x93a0ab]
                                        text:@"″從今天起在SeeWorld+透過Free Tag串連全世界″\r\r\rSeeWorld+是一款內容豐富的社交型通訊APP，支援手機網路發送語音訊息、文字及圖片可一對一聊天或建立多人群組聊天室以及清晰的視訊通話歡迎在SeeWorld+和親友們盡情享受暢快免費通話、視訊、傳訊的樂趣！\r\r\rSeeWorld+創作平台讓您輕鬆經營自我風格，內建多樣化濾鏡與貼紙，簡單隨手拍即能打造獨特相片調性第一時間發送最精彩、最新潮、最美麗的相片，分享給親友並且藉由Free Tag找尋相同興趣愛好者，讓您無論身在何處都不孤單！\r\r\r透過SeeWorld+分享生活，輕鬆Tag串連全世界！"
                                   textAlignment:NSTextAlignmentCenter font:[UIFont systemFontOfSize:14] numberOfLines:0];
  [self.view addSubview:lblIntro];
  
  UIButton *btnAgreement = [[UIButton alloc] initWithFrame:CGRectMake((UIScreenWidth-70)/2.0, UIScreenHeight-70, 70, 25)];
  [btnAgreement setTitle:@"用戶協議" forState:UIControlStateNormal];
  [btnAgreement setTitleColor:[UIColor colorWithRGBHex:0x55acef] forState:UIControlStateNormal];
  [btnAgreement.titleLabel setFont:[UIFont systemFontOfSize:16]];
  [self.view addSubview:btnAgreement];
  [btnAgreement addTarget:self action:@selector(onAgreement) forControlEvents:UIControlEventTouchUpInside];
  [btnAgreement addSubview:[ALLineView lineWithFrame:CGRectMake(0, 21, btnAgreement.width, 0.5) colorHex:0x4d9fb7]];
  
  UILabel *lblCopyright = [UILabel initWithFrame:CGRectMake(10, UIScreenHeight-29, UIScreenWidth-20, 9)
                             bgColor:[UIColor clearColor]
                           textColor:[UIColor colorWithRGBHex:0x191d28]
                                text:@"seeworldplus.com 2011-2016 © All Rights Reserved"
                       textAlignment:NSTextAlignmentCenter font:[UIFont systemFontOfSize:9]];
  [self.view addSubview:lblCopyright];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)onAgreement{
  SWAgreementVC *vc = [[SWAgreementVC alloc] init];
  vc.url = SWURLAgreement;
  [self.navigationController pushViewController:vc animated:YES];
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
