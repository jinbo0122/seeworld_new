//
//  SWHomeAddFriendVC.m
//  SeeWorld
//
//  Created by Albert Lee on 9/2/15.
//  Copyright (c) 2015 SeeWorld. All rights reserved.
//

#import "SWHomeAddFriendVC.h"
#import "SWSearchFriendVC.h"
#import "SWFBAddFriendVC.h"
#import "SWFBLoginAPI.h"
@interface SWHomeAddFriendVC ()
@property(nonatomic, strong)SWSearchBar *searchBar;
@property(nonatomic, strong)UIButton    *btnSearch;
@property(nonatomic, strong)UIButton    *btnFacebook;
@end

@implementation SWHomeAddFriendVC

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  self.view.backgroundColor = [UIColor colorWithRGBHex:0x1a2531];
  self.navigationItem.titleView = [[ALTitleLabel alloc] initWithTitle:SWStringAddFriend
                                                                color:[UIColor colorWithRGBHex:NAV_BAR_COLOR_HEX]
                                                             fontSize:18];
  
  self.btnSearch = [[UIButton alloc] initWithFrame:CGRectMake(0, iOSNavHeight, self.view.width, 50)];
  [self.view addSubview:self.btnSearch];
  
  self.searchBar = [[SWSearchBar alloc] initWithFrame:CGRectMake(0, 7+iOSTopHeight, self.view.width, 30)];
  self.searchBar.placeholder = SWStringSearchFriend;
  self.searchBar.userInteractionEnabled = NO;
  self.searchBar.showsCancelButton = NO;
  [self.btnSearch addSubview:self.searchBar];
  
  self.btnFacebook = [[UIButton alloc] initWithFrame:CGRectMake(-0.5, self.btnSearch.bottom, self.btnSearch.width+1, 60)];
  self.btnFacebook.layer.masksToBounds = YES;
  self.btnFacebook.layer.borderWidth   = 0.5;
  self.btnFacebook.layer.borderColor   = [UIColor colorWithRGBHex:0x2a3847].CGColor;
  [self.view addSubview:self.btnFacebook];
  
  self.btnFacebook.customImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 20, 20)];
  self.btnFacebook.customImageView.image = [UIImage imageNamed:@"home_icon_fb_addfriends"];
  [self.btnFacebook addSubview:self.btnFacebook.customImageView];
  
  self.btnFacebook.lblCustom = [UILabel initWithFrame:CGRectMake(self.btnFacebook.customImageView.right+10, 0,
                                                                 self.btnFacebook.width-65, self.btnFacebook.height)
                                              bgColor:[UIColor clearColor]
                                            textColor:[UIColor whiteColor]
                                                 text:SWStringFBSearchFriend
                                        textAlignment:NSTextAlignmentLeft
                                                 font:[UIFont systemFontOfSize:16]];
  [self.btnFacebook addSubview:self.btnFacebook.lblCustom];
  
  [self.btnSearch addTarget:self action:@selector(onSearchClicked:) forControlEvents:UIControlEventTouchUpInside];
  [self.btnFacebook addTarget:self action:@selector(onFBClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)onSearchClicked:(UIButton *)button{
  SWSearchFriendVC *vc = [[SWSearchFriendVC alloc] init];
  UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
  [self presentViewController:nav animated:YES completion:nil];
}

- (void)onFBClicked:(UIButton *)button{
  if (![FBSDKAccessToken currentAccessToken]) {
    __weak typeof(self)wSelf = self;
    NSArray *permissions =  @[@"public_profile", @"email",@"user_friends",@"read_custom_friendlists"];
    FBSDKLoginManager *loginA = [[FBSDKLoginManager alloc] init];
    [loginA logInWithReadPermissions:permissions
                  fromViewController:self
                             handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
                               if (!error && !result.isCancelled) {
                                 [wSelf fbBound];
                                 [wSelf onFBFriendsPushed];
                               }else{
                                 [MBProgressHUD showTip:@"Facebook绑定失败"];
                               }
                             }];
  }else{
    [self onFBFriendsPushed];
  }
}

- (void)fbBound{
  SWFBLoginAPI *api = [[SWFBLoginAPI alloc] init];
  api.openID = [[FBSDKAccessToken currentAccessToken] userID];
  api.token  = [[FBSDKAccessToken currentAccessToken] tokenString];
  [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
  } failure:^(YTKBaseRequest *request) {
  }];
}

- (void)onFBFriendsPushed{
  SWFBAddFriendVC *vc = [[SWFBAddFriendVC alloc] init];
  vc.hidesBottomBarWhenPushed = YES;
  [self.navigationController pushViewController:vc animated:YES];
}
@end
