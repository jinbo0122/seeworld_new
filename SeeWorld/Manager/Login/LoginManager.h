//
//  LoginManager.h
//  SeeWorld
//
//  Created by  on 15/8/9.
//  Copyright (c) 2015年 SeeWorld
//

#import <UIKit/UIKit.h>
#import "SWManager.h"
#import "SWFoundation.h"

@interface LoginManager : SWManager<SWManager>
AS_SINGLETON;
- (void )loginWithUsername:(NSString *)username password:(NSString *)password;
- (void )registerWithUsername:(NSString *)username password:(NSString *)password;
@end
