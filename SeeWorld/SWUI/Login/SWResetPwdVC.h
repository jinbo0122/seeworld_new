//
//  SWResetPwdVC.h
//  SeeWorld
//
//  Created by Albert Lee on 6/5/16.
//  Copyright © 2016 SeeWorld. All rights reserved.
//

#import "ALBaseVC.h"

@interface SWResetPwdVC : ALBaseVC
@property(nonatomic, strong)NSString *account;
@property(nonatomic, strong)NSString *secret;
@property(nonatomic, assign)NSInteger type;//0:邮件   1:手机号（手机号时secrect传0）
@end
