//
//  LoginManager.m
//  SeeWorld
//
//  Created by  on 15/8/9.
//  Copyright (c) 2015年 SeeWorld
//

#import "LoginManager.h"
#import "LoginRequestApi.h"

@implementation LoginManager
DEF_SINGLETON(LoginManager);
- (void )loginWithUsername:(NSString *)username password:(NSString *)password
{
    LoginRequestApi *api = [[LoginRequestApi alloc] initWithUsername:username password:password];
    [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        
    } failure:^(YTKBaseRequest *request) {
    }];
}

- (void )registerWithUsername:(NSString *)username password:(NSString *)password
{
    
}
@end
